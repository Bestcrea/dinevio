# Stripe Wallet Integration - Deployment Checklist

## Pre-Deployment Setup

### 1. Stripe Account Configuration
- [ ] Log in to Stripe Dashboard (dinevio609@gmail.com)
- [ ] Enable test mode for development
- [ ] Get publishable key from Dashboard → Developers → API keys
- [ ] Get secret key from Dashboard → Developers → API keys (keep secret!)
- [ ] Configure Apple Pay in Stripe Dashboard:
  - [ ] Go to Settings → Payment methods → Apple Pay
  - [ ] Add merchant identifier: `merchant.com.dinevio.app`
  - [ ] Upload domain association file if required
- [ ] Configure Google Pay in Stripe Dashboard:
  - [ ] Go to Settings → Payment methods → Google Pay
  - [ ] Enable Google Pay for Morocco (MA)
  - [ ] Configure merchant country code: MA
  - [ ] Configure currency: MAD

### 2. Firebase Configuration

#### Firestore Settings
- [ ] Add Stripe publishable key to Firestore:
  - Collection: `settings` → Document: `payment`
  - Field: `strip.clientPublishableKey` = `pk_test_...` (test key)
  - Field: `strip.isActive` = `true`

#### Cloud Functions Environment
- [ ] Set Stripe secret key in Firebase Functions:
  ```bash
  cd function
  firebase functions:config:set stripe.secret="sk_test_..."
  ```
  OR use environment variable:
  ```bash
  firebase functions:config:set stripe.secret="sk_test_..."
  ```

- [ ] Verify environment variable is set:
  ```bash
  firebase functions:config:get
  ```

### 3. Flutter App Configuration

#### iOS Configuration
- [ ] Open `customer/ios/Runner.xcworkspace` in Xcode
- [ ] Go to Signing & Capabilities
- [ ] Add Apple Pay capability
- [ ] Configure merchant identifier: `merchant.com.dinevio.app`
- [ ] Update `Info.plist` if required by flutter_stripe:
  ```xml
  <key>NSApplePayMerchantIdentifier</key>
  <string>merchant.com.dinevio.app</string>
  ```

#### Android Configuration
- [ ] Verify `android/app/build.gradle` includes Google Pay dependencies
- [ ] No additional configuration needed (handled by flutter_stripe)

### 4. Code Verification

#### Flutter
- [ ] Verify `PaymentService.initializeStripe()` is called in `main.dart`
- [ ] Verify `WalletController` is registered in GetX bindings
- [ ] Verify `CheckoutController` uses `WalletController`
- [ ] Verify all imports are correct
- [ ] Run `flutter analyze` and fix any errors

#### Cloud Functions
- [ ] Verify `createPaymentIntent` function uses `onCall` (HTTPS callable)
- [ ] Verify Stripe secret key is loaded from environment
- [ ] Verify error handling is implemented
- [ ] Test function locally:
  ```bash
  cd function
  npm install
  firebase emulators:start --only functions
  ```

### 5. Firestore Security Rules

Update Firestore rules to allow order creation:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Orders collection
    match /orders/{orderId} {
      // Allow authenticated users to create their own orders
      allow create: if request.auth != null && 
                       request.resource.data.userId == request.auth.uid;
      
      // Allow guest users to create orders (userId can be null)
      allow create: if request.resource.data.userId == null;
      
      // Users can read their own orders
      allow read: if request.auth != null && 
                     resource.data.userId == request.auth.uid;
      
      // Users can update payment status of their own orders
      allow update: if request.auth != null && 
                       resource.data.userId == request.auth.uid &&
                       request.resource.data.diff(resource.data).affectedKeys()
                         .hasOnly(['paymentStatus', 'paymentIntentId', 'updatedAt']);
    }
    
    // Wallet settings (optional, for future use)
    match /users/{userId}/wallet/{document=**} {
      allow read, write: if request.auth != null && 
                           request.auth.uid == userId;
    }
  }
}
```

- [ ] Update Firestore rules in Firebase Console
- [ ] Test rules with Firebase Rules Playground

## Deployment Steps

### 1. Deploy Cloud Functions
```bash
cd function
npm install
firebase deploy --only functions:createPaymentIntent
```

- [ ] Verify deployment successful
- [ ] Check function logs:
  ```bash
  firebase functions:log --only createPaymentIntent
  ```

### 2. Test Cloud Function
- [ ] Test function with curl or Postman:
  ```bash
  curl -X POST https://YOUR-REGION-YOUR-PROJECT.cloudfunctions.net/createPaymentIntent \
    -H "Content-Type: application/json" \
    -d '{"data": {"amount": 10000, "currency": "mad"}}'
  ```
- [ ] Verify response contains `clientSecret`

### 3. Build and Test Flutter App

#### iOS
```bash
cd customer
flutter build ios --release
```

- [ ] Test on iOS device (Apple Pay requires real device)
- [ ] Verify Stripe initialization in logs
- [ ] Test Wallet selection
- [ ] Test Checkout flow with Apple Pay
- [ ] Test Checkout flow with Cash

#### Android
```bash
cd customer
flutter build apk --release
```

- [ ] Test on Android device (Google Pay requires real device or emulator with Google Play)
- [ ] Verify Stripe initialization in logs
- [ ] Test Wallet selection
- [ ] Test Checkout flow with Google Pay
- [ ] Test Checkout flow with Cash

### 4. Production Deployment

#### Switch to Production Keys
- [ ] Get production publishable key from Stripe Dashboard
- [ ] Update Firestore `settings.payment.strip.clientPublishableKey` with production key
- [ ] Set production secret key in Firebase Functions:
  ```bash
  firebase functions:config:set stripe.secret="sk_live_..."
  ```
- [ ] Update `PaymentService` to use production Google Pay (testEnv: false)
- [ ] Redeploy Cloud Functions:
  ```bash
  firebase deploy --only functions:createPaymentIntent
  ```

#### App Store / Play Store
- [ ] Build release versions:
  - iOS: `flutter build ios --release`
  - Android: `flutter build appbundle --release`
- [ ] Submit to App Store / Play Store
- [ ] Monitor Stripe Dashboard for live transactions

## Post-Deployment Monitoring

### Stripe Dashboard
- [ ] Monitor payment intents in Stripe Dashboard
- [ ] Check for failed payments
- [ ] Review payment method usage (Apple Pay vs Google Pay vs Cash)
- [ ] Monitor revenue and transaction volume

### Firebase
- [ ] Monitor Cloud Functions logs for errors
- [ ] Monitor Firestore usage (order creation rate)
- [ ] Set up alerts for function failures

### App Analytics
- [ ] Track payment method selection in analytics
- [ ] Track checkout completion rate
- [ ] Track payment success/failure rates

## Rollback Plan

If issues occur:
1. **Disable Stripe in Firestore**: Set `settings.payment.strip.isActive = false`
2. **Revert Cloud Function**: Deploy previous version
3. **Update App**: Force users to update if critical bug

## Support Contacts

- **Stripe Support**: https://support.stripe.com
- **Firebase Support**: https://firebase.google.com/support
- **Flutter Stripe Docs**: https://pub.dev/packages/flutter_stripe

## Notes

- Keep Stripe secret keys secure (never commit to git)
- Use test mode for development
- Test on real devices for Apple Pay / Google Pay
- Monitor Firestore costs (order creation)
- Consider rate limiting for order creation
- Implement retry logic for failed payments

