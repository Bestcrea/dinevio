# Stripe Payment Setup Guide for Dinevio

This guide covers setting up Stripe PaymentSheet with Apple Pay and Google Pay support in the Dinevio Flutter app.

## Overview

The implementation uses:
- **Stripe PaymentSheet** for secure payment processing
- **Firebase Cloud Functions** backend to create PaymentIntents (never expose secret keys in Flutter)
- **Automatic Apple Pay / Google Pay** detection (appears automatically if enabled in Stripe Dashboard and device supports it)

## Prerequisites

1. Stripe account: `dinevio609@gmail.com` (Test mode)
2. Firebase project configured
3. Flutter app with `flutter_stripe` and `cloud_functions` packages

## Step 1: Enable Apple Pay and Google Pay in Stripe Dashboard

### Apple Pay Setup

1. Log in to [Stripe Dashboard](https://dashboard.stripe.com)
2. Go to **Settings** → **Payment methods**
3. Find **Apple Pay** and click **Activate**
4. Follow the setup wizard:
   - Upload your domain verification file (for web)
   - For iOS: Apple Pay will work automatically if your app is configured correctly
5. **Important**: The Payment Method Config reference is: `pmc_1Sj5HOBBU7ptzerEgC0aUE23` (DinevioPay)

### Google Pay Setup

1. In Stripe Dashboard, go to **Settings** → **Payment methods**
2. Find **Google Pay** and click **Activate**
3. Configure Google Pay settings:
   - Merchant country: **Morocco (MA)**
   - Currency: **MAD (Moroccan Dirham)**
4. **Important**: The Payment Method Config reference is: `pmc_1Sj5UvBBU7ptzerEVgqdgaJ4` (GooglePay)

### Other Payment Methods (Optional)

- **PayPal**: `cpmt_1Sj5SiBBU7ptzerEGsqmrLyl`
- **PikPay**: `cpmt_1Sj5TUBBU7ptzerEwLROiqAb`
- **PayPay**: `cpmt_1Sj5UDBBU7ptzerE0FBIShz2`

**Note**: These configs are managed in Stripe Dashboard. Do NOT try to attach them by ID in client code. Stripe will automatically enable them in PaymentSheet if configured correctly.

## Step 2: Configure Firebase Functions

### Install Dependencies

```bash
cd function/functions
npm install
```

This will install `stripe` package (already added to `package.json`).

### Set Stripe Secret Key

**Option 1: Using Firebase Config (Legacy)**

```bash
firebase functions:config:set stripe.secret="sk_test_YOUR_SECRET_KEY"
```

**Option 2: Using Environment Variables (Recommended)**

For Firebase Functions v2, use environment variables:

```bash
# Set environment variable for your Firebase project
firebase functions:secrets:set STRIPE_SECRET_KEY
# When prompted, paste your Stripe secret key: sk_test_...
```

Or set it in Firebase Console:
1. Go to Firebase Console → Functions → Configuration
2. Add secret: `STRIPE_SECRET_KEY` with value `sk_test_...`

### Deploy Functions

```bash
cd function
firebase deploy --only functions:createPaymentIntent
```

Verify deployment:
```bash
firebase functions:log --only createPaymentIntent
```

## Step 3: Configure Flutter App

### iOS Configuration

1. **Enable Apple Pay Capability**:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select **Runner** target → **Signing & Capabilities**
   - Click **+ Capability** → Add **Apple Pay**
   - Ensure **Merchant Identifier** is set to: `merchant.com.dinevio.app`

2. **Update Info.plist** (if needed):
   - The merchant identifier should match: `merchant.com.dinevio.app`

### Android Configuration

1. **No additional setup required** for Google Pay
   - Google Pay will work automatically if:
     - Google Play Services is installed
     - User has a payment method configured
     - Stripe Dashboard has Google Pay enabled

## Step 4: Test the Implementation

### Test on iOS

1. **Prerequisites**:
   - iOS device (Apple Pay doesn't work in simulator)
   - Apple Pay configured with a test card
   - App built with development/production certificate

2. **Test Flow**:
   ```dart
   // Navigate to checkout screen
   Get.toNamed(Routes.CHECKOUT, arguments: {
     'subtotal': 5000,  // 50.00 MAD in cents
     'deliveryFee': 1000,  // 10.00 MAD
     'tax': 500,  // 5.00 MAD
     'orderId': 'test_order_123',
     'userId': 'user_123',
   });
   ```

3. **Expected Behavior**:
   - PaymentSheet opens
   - Apple Pay button appears at the top (if device supports it)
   - User can select Apple Pay or enter card details
   - Payment processes successfully

### Test on Android

1. **Prerequisites**:
   - Android device with Google Play Services
   - Google Pay configured with a test card
   - App built and installed

2. **Test Flow**:
   - Same as iOS (navigate to checkout screen)
   - PaymentSheet opens
   - Google Pay button appears at the top (if device supports it)
   - User can select Google Pay or enter card details

### Test Payment Methods

Use Stripe test cards:
- **Success**: `4242 4242 4242 4242`
- **Decline**: `4000 0000 0000 0002`
- **3D Secure**: `4000 0027 6000 3184`

Expiry: Any future date (e.g., `12/34`)
CVC: Any 3 digits (e.g., `123`)

## Step 5: Verify Payment Method Configs

The PaymentSheet will automatically show Apple Pay / Google Pay if:

1. ✅ Enabled in Stripe Dashboard
2. ✅ Device/platform supports it
3. ✅ User has payment methods configured
4. ✅ Merchant identifier matches (iOS)

**You do NOT need to manually attach payment method configs by ID in the code.** Stripe handles this automatically via `automatic_payment_methods: { enabled: true }` in the PaymentIntent.

## Troubleshooting

### Apple Pay Not Appearing

1. Check merchant identifier matches: `merchant.com.dinevio.app`
2. Verify Apple Pay capability is added in Xcode
3. Ensure device has Apple Pay configured
4. Check Stripe Dashboard: Apple Pay is activated
5. Verify test mode vs production mode matches

### Google Pay Not Appearing

1. Check Google Play Services is installed
2. Verify user has Google Pay configured
3. Check Stripe Dashboard: Google Pay is activated
4. Ensure currency is set to `MAD` and country to `MA`

### PaymentIntent Creation Fails

1. Check Firebase Functions logs:
   ```bash
   firebase functions:log --only createPaymentIntent
   ```
2. Verify Stripe secret key is set correctly
3. Check function is deployed:
   ```bash
   firebase functions:list
   ```

### PaymentSheet Initialization Fails

1. Verify Stripe publishable key is correct in Firestore
2. Check `PaymentService.initializeStripe()` is called in `main.dart`
3. Ensure `cloud_functions` package is added to `pubspec.yaml`

## Production Checklist

Before going live:

- [ ] Switch Stripe to **Live mode**
- [ ] Update `testEnv: false` in `PaymentService.initPaymentSheet()` (Google Pay)
- [ ] Set production Stripe secret key in Firebase Functions
- [ ] Test with real payment methods
- [ ] Configure webhook endpoints for payment confirmation
- [ ] Update merchant identifier if needed for production

## Code Structure

```
customer/
├── lib/
│   ├── services/
│   │   └── payment_service.dart          # Stripe PaymentSheet service
│   └── app/
│       └── modules/
│           └── checkout/
│               ├── controllers/
│               │   └── checkout_controller.dart
│               ├── views/
│               │   └── checkout_screen.dart
│               └── bindings/
│                   └── checkout_binding.dart

function/
└── functions/
    └── index.js                           # createPaymentIntent function
```

## API Reference

### PaymentService

```dart
// Initialize Stripe (call once in main.dart)
await PaymentService.initializeStripe(
  publishableKey: 'pk_test_...',
  merchantIdentifier: 'merchant.com.dinevio.app',
);

// Process payment
final success = await PaymentService().processPayment(
  amount: 10000,  // 100.00 MAD in cents
  currency: 'mad',
  metadata: {'orderId': '123'},
);
```

### Firebase Function

**Endpoint**: `createPaymentIntent`

**Request**:
```json
{
  "amount": 10000,
  "currency": "mad",
  "metadata": {
    "orderId": "123",
    "userId": "user_123"
  }
}
```

**Response**:
```json
{
  "clientSecret": "pi_xxx_secret_xxx",
  "paymentIntentId": "pi_xxx"
}
```

## Support

For issues:
1. Check Firebase Functions logs
2. Check Stripe Dashboard → Logs
3. Verify all configuration steps above
4. Test with Stripe test cards first

---

**Last Updated**: 2024
**Stripe Account**: dinevio609@gmail.com
**Test Mode**: Enabled

