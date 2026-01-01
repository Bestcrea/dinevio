/**
 * Firebase Cloud Functions for Dinevio
 * Includes ride assignment and Stripe payment processing
 */

const { onDocumentWritten } = require('firebase-functions/v2/firestore');
const { onRequest } = require('firebase-functions/v2/https');
const { initializeApp } = require('firebase-admin/app');
const { getFirestore, Timestamp, FieldValue } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');
const { v4: uuidv4 } = require("uuid");
const Stripe = require('stripe');

initializeApp();
const db = getFirestore();

// Initialize Stripe with secret key from environment config
// Set via: firebase functions:config:set stripe.secret="sk_test_..."
// Or use environment variable: STRIPE_SECRET_KEY
let stripeSecret = process.env.STRIPE_SECRET_KEY;
if (!stripeSecret) {
  try {
    // Try to get from Firebase config (legacy method)
    const functions = require('firebase-functions');
    if (functions.config && functions.config().stripe) {
      stripeSecret = functions.config().stripe.secret;
    }
  } catch (e) {
    console.warn('Could not load Stripe secret from config. Set STRIPE_SECRET_KEY environment variable.');
  }
}
const stripe = stripeSecret ? Stripe(stripeSecret) : null;

/**
 * Create Stripe PaymentIntent (HTTPS Callable)
 * Input: { amount (cents), currency ("mad"), metadata (optional) }
 * Output: { clientSecret }
 */
const { onCall } = require('firebase-functions/v2/https');

exports.createPaymentIntent = onCall(
  {
    cors: true, // Enable CORS for Flutter web
    maxInstances: 10,
  },
  async (request) => {
    try {
      const { amount, currency = 'mad', metadata = {} } = request.data;

      // Validate Stripe is initialized
      if (!stripe) {
        throw new HttpsError(
          'internal',
          'Stripe is not configured. Please set STRIPE_SECRET_KEY.'
        );
      }

      // Validate amount
      if (!amount || typeof amount !== 'number' || amount <= 0) {
        throw new HttpsError(
          'invalid-argument',
          'Invalid amount. Must be a positive number in cents.'
        );
      }

      // Create PaymentIntent with automatic payment methods
      // This enables Apple Pay and Google Pay automatically if configured in Stripe Dashboard
      const paymentIntent = await stripe.paymentIntents.create({
        amount: Math.round(amount), // Ensure integer
        currency: currency.toLowerCase(), // 'mad' for Moroccan Dirham
        automatic_payment_methods: {
          enabled: true, // Automatically enables Apple Pay, Google Pay, etc. if available
        },
        metadata: {
          ...metadata,
          created_at: new Date().toISOString(),
        },
      });

      // Return only the client secret (never expose the full PaymentIntent)
      return {
        clientSecret: paymentIntent.client_secret,
        paymentIntentId: paymentIntent.id, // Optional: for tracking
      };
    } catch (error) {
      console.error('Error creating PaymentIntent:', error);
      if (error instanceof HttpsError) {
        throw error;
      }
      throw new HttpsError(
        'internal',
        'Failed to create payment intent',
        error.message
      );
    }
  }
);

// Existing ride assignment function
exports.cancelledRide = onDocumentWritten({ document: 'bookings/{bookingId}' }, async (event) => {
  const beforeData = event.data.before.exists ? event.data.before.data() : null;
  const afterData = event.data.after.exists ? event.data.after.data() : null;
  const bookingId = event.params.bookingId;

  if (!afterData || !['booking_placed', 'booking_rejected'].includes(afterData.bookingStatus)) return null;
  if (beforeData && beforeData.bookingStatus === afterData.bookingStatus) return null;

  const vehicleTypeId = afterData.vehicleType?.id;
  const rejectedDriverIds = afterData.rejectedDriverId || [];
  const pickupLocation = afterData?.pickUpLocation;

  if (!pickupLocation?.latitude || !pickupLocation?.longitude) {
    console.error("Invalid Pickup Location", pickupLocation);
    return null;
  }

  const nearestDrivers = await getNearestAvailableDrivers(pickupLocation, rejectedDriverIds, vehicleTypeId);
  const settingData = await db.collection("settings").doc("constant").get();
  const orderSeconds = parseInt(settingData.data()?.secondsForRideCancel, 10) || 60;
  if (nearestDrivers.length === 0) {
    console.log("No nearby drivers found for Ride:", bookingId);
     setTimeout(async () => {
          const bookingDoc = await db.collection("bookings").doc(bookingId).get();
          const bookingData = bookingDoc.data();
          if (bookingData && ['booking_placed', 'booking_rejected'].includes(bookingData.bookingStatus)) {
            console.log(`Cancelling ride ${bookingId} after timeout due to no drivers.`);
            await cancelBooking(bookingData, bookingId, 'No Nearest Driver Available');
          }
        }, orderSeconds * 1000);
    return null;
}


  for (let driver of nearestDrivers) {
    if (driver.isActive && driver.isOnline && driver.isVerified && driver.driverVehicleDetails?.isVerified) {
      await assignOrderToDriver(afterData.id, driver.id);
      await sendNotification(driver.fcmToken, 'New Ride Request', 'A customer has placed a ride in your area. Accept now!');
      await saveNotification({
        type: 'order',
        title: 'New Ride Request',
        description: 'A customer has placed a ride in your area. Accept now!',
        bookingId: afterData.id,
        driverId: driver.id,
        senderId: afterData.customerId
      });

      const settingData = await db.collection("settings").doc("constant").get();
      const orderSeconds = parseInt(settingData.data()?.secondsForRideCancel, 10) || 60;

      setTimeout(async () => {
        const updatedOrder = (await db.collection("bookings").doc(afterData.id).get()).data();
        if (updatedOrder.bookingStatus === "driver_assigned") {
          await db.collection("bookings").doc(afterData.id).update({
            rejectedDriverId: FieldValue.arrayUnion(driver.id)
          });

          await db.collection("drivers").doc(driver.id).update({
            bookingId: "",
            status: "free"
          });

          console.log(`${driver.fullName || driver.id} marked free. Reassigning...`);
          await reassignOrCancelOrder(afterData.id);
        }
      }, orderSeconds * 1000);

      return null;
    }
  }

  return null;
});

async function getNearestAvailableDrivers(pickupLocation, rejectedDriverIds, vehicleTypeId) {
  const snapshot = await db.collection('drivers')
    .where('isOnline', '==', true)
    .where('status', '==', 'free')
    .get();

  const settings = await db.collection("settings").doc("globalValue").get();
  const driverRadius = parseFloat(settings.data()?.radius || 100);

  const drivers = snapshot.docs.map(doc => {
    const data = doc.data();
    const driverLocation = data.location;
    const driverVehicleTypeId = data.driverVehicleDetails?.vehicleTypeId;

    if (!driverLocation?.latitude || !driverLocation?.longitude) return null;
    if (driverVehicleTypeId !== vehicleTypeId) return null;

    const distance = calculateDistance(pickupLocation, driverLocation);
    if (distance > driverRadius) return null;

    return {
      ...data,
      id: doc.id,
      distance
    };
  }).filter(driver => driver !== null && !rejectedDriverIds.includes(driver.id));

  return drivers.sort((a, b) => a.distance - b.distance);
}

async function assignOrderToDriver(bookingId, driverId) {
  await db.collection('bookings').doc(bookingId).update({
    driverId,
    bookingStatus: 'driver_assigned',
    assignedAt: FieldValue.serverTimestamp()
  });

  await db.collection('drivers').doc(driverId).update({
    status: 'busy',
    bookingId
  });
}

async function reassignOrCancelOrder(bookingId) {
  const bookingRef = db.collection("bookings").doc(bookingId);
  const bookingDetails = (await bookingRef.get()).data();

  const rejectedDriverIds = bookingDetails.rejectedDriverId || [];
  const nearestDrivers = await getNearestAvailableDrivers(bookingDetails.pickUpLocation, rejectedDriverIds, bookingDetails.vehicleType?.id);

  if (nearestDrivers.length === 0) {
      await cancelBooking(bookingDetails, bookingId, 'No Nearest Driver Available');
      return;
    }

  for (let driver of nearestDrivers) {
    if (driver.isActive && driver.isOnline && driver.isVerified && driver.driverVehicleDetails?.isVerified) {
      await assignOrderToDriver(bookingDetails.id, driver.id);
      await sendNotification(driver.fcmToken, 'New Ride Request', 'A customer has placed a ride in your area. Accept now!');
      await saveNotification({
        type: 'order',
        title: 'New Ride Request',
        description: 'A customer has placed a ride in your area. Accept now!',
        bookingId: bookingDetails.id,
        driverId: driver.id,
        senderId: bookingDetails.customerId
      });

      const settingData = await db.collection("settings").doc("constant").get();
      const orderSeconds = parseInt(settingData.data()?.secondsForRideCancel, 10) || 60;

      setTimeout(async () => {
        const updatedOrder = (await bookingRef.get()).data();
        if (updatedOrder.bookingStatus === "driver_assigned") {
          await db.collection("bookings").doc(bookingDetails.id).update({
            rejectedDriverId: FieldValue.arrayUnion(driver.id)
          });

          await db.collection("drivers").doc(driver.id).update({
            bookingId: "",
            status: "free"
          });

          await reassignOrCancelOrder(bookingDetails.id);
        }
      }, orderSeconds * 1000);
      return;
    }
  }
}

async function cancelBooking(bookingDetails, bookingId, reason) {
  await db.collection('bookings').doc(bookingId).update({
    driverId: '',
    bookingStatus: 'booking_cancelled',
    cancelledReason: reason
  });

  if (bookingDetails.driverId) {
    await db.collection("drivers").doc(bookingDetails.driverId).update({
      bookingId: "",
      status: 'free'
    });
  }

  const userProfile = await getUserProfile(bookingDetails.customerId);
  if (userProfile?.fcmToken) {
    await sendNotification(
      userProfile.fcmToken,
      'Your Ride is Cancelled',
      `Your ride with #${bookingId.substring(0, 4)} has been cancelled because no driver accepted.`
    );

    await saveNotification({
      type: "order",
      title: "Your Ride is Cancelled",
      description: `Your ride with #${bookingId.substring(0, 4)} has been cancelled because no driver accepted.`,
      bookingId: bookingDetails.id,
      customerId: bookingDetails.customerId,
      senderId: ''
    });
  }
}

function calculateDistance(location1, location2) {
  const lat1 = location1.latitude;
  const lon1 = location1.longitude;
  const lat2 = location2.latitude;
  const lon2 = location2.longitude;

  const R = 6371;
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;

  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLat / 2) * Math.sin(dLat / 2);

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

async function getUserProfile(customerId) {
  try {
    const userProfile = await db.collection('users').doc(customerId).get();
    return userProfile.exists ? userProfile.data() : null;
  } catch (error) {
    console.error(`Error fetching profile for ${customerId}:`, error);
    return null;
  }
}

async function sendNotification(fcmToken, title, body) {
  try {
    await getMessaging().send({
      token: fcmToken,
      notification: { title, body }
    });
    console.log('Notification sent to:', fcmToken);
  } catch (error) {
    console.error('Error sending FCM:', error);
  }
}

async function saveNotification({
  type,
  title,
  description,
  bookingId,
  driverId = null,
  customerId = null,
  senderId
}) {
  try {
    const notification = {
      id: uuidv4(),
      type,
      title,
      description,
      bookingId,
      driverId,
      customerId,
      senderId,
      createdAt: Timestamp.now()
    };
    await db.collection("notification").doc(notification.id).set(notification);
    console.log("Notification saved for:", driverId || customerId);
  } catch (error) {
    console.error("Error saving notification:", error);
  }
}
