# Stripe Wallet Integration Test Plan

## Overview
This document outlines the test plan for integrating Stripe PaymentSheet with the Wallet module for Dinevio Flutter app.

## Prerequisites
- Stripe account: dinevio609@gmail.com
- Firebase project: dinevio-app
- Stripe publishable key configured in Firestore settings
- Stripe secret key configured in Firebase Functions environment
- Test mode enabled for development

## Test Environment
- **Platforms**: iOS and Android
- **Currency**: MAD (Moroccan Dirham)
- **Payment Methods**: Apple Pay (iOS), Google Pay (Android), Cash (both)

## Test Cases

### 1. Wallet Selection & Persistence
- [ ] **TC-1.1**: Select Apple Pay in Wallet → Verify selection persists after app restart
- [ ] **TC-1.2**: Select Google Pay in Wallet → Verify selection persists after app restart
- [ ] **TC-1.3**: Select Cash in Wallet → Verify selection persists after app restart
- [ ] **TC-1.4**: Change payment method from Checkout screen → Verify Wallet opens and selection updates
- [ ] **TC-1.5**: Guest user can select payment method → Verify local storage works without authentication

### 2. Checkout Flow - Cash Payment
- [ ] **TC-2.1**: Select Cash in Wallet → Go to Checkout → Verify "Place Order (Cash on Delivery)" button
- [ ] **TC-2.2**: Place order with Cash → Verify order created in Firestore with `paymentStatus: 'paid'`
- [ ] **TC-2.3**: Place order with Cash → Verify success snackbar shows "Order Placed"
- [ ] **TC-2.4**: Place order with Cash → Verify no Stripe PaymentSheet appears
- [ ] **TC-2.5**: Place order with Cash → Verify order details are correct (items, totals, address)

### 3. Checkout Flow - Apple Pay (iOS)
- [ ] **TC-3.1**: Select Apple Pay in Wallet → Go to Checkout → Verify "Pay XXX MAD" button
- [ ] **TC-3.2**: Place order with Apple Pay → Verify PaymentSheet appears with Apple Pay option
- [ ] **TC-3.3**: Complete Apple Pay payment → Verify order created with `paymentStatus: 'paid'`
- [ ] **TC-3.4**: Complete Apple Pay payment → Verify success snackbar
- [ ] **TC-3.5**: Cancel Apple Pay payment → Verify order created with `paymentStatus: 'failed'`
- [ ] **TC-3.6**: Cancel Apple Pay payment → Verify cancellation snackbar
- [ ] **TC-3.7**: Apple Pay not available on device → Verify fallback to card entry

### 4. Checkout Flow - Google Pay (Android)
- [ ] **TC-4.1**: Select Google Pay in Wallet → Go to Checkout → Verify "Pay XXX MAD" button
- [ ] **TC-4.2**: Place order with Google Pay → Verify PaymentSheet appears with Google Pay option
- [ ] **TC-4.3**: Complete Google Pay payment → Verify order created with `paymentStatus: 'paid'`
- [ ] **TC-4.4**: Complete Google Pay payment → Verify success snackbar
- [ ] **TC-4.5**: Cancel Google Pay payment → Verify order created with `paymentStatus: 'failed'`
- [ ] **TC-4.6**: Cancel Google Pay payment → Verify cancellation snackbar
- [ ] **TC-4.7**: Google Pay not available on device → Verify fallback to card entry

### 5. Checkout UI
- [ ] **TC-5.1**: Checkout screen displays selected payment method card
- [ ] **TC-5.2**: Payment method card shows correct icon (Apple Pay / Google Pay / Cash)
- [ ] **TC-5.3**: Payment method card shows "Change" button
- [ ] **TC-5.4**: Tap "Change" → Verify Wallet screen opens
- [ ] **TC-5.5**: Change payment method in Wallet → Return to Checkout → Verify method updated
- [ ] **TC-5.6**: Info box appears only for Stripe payment methods (Apple Pay / Google Pay)
- [ ] **TC-5.7**: Button text changes based on payment method ("Pay XXX" vs "Place Order (Cash on Delivery)")

### 6. Order Creation in Firestore
- [ ] **TC-6.1**: Order created with correct structure (orderId, userId, items, totals)
- [ ] **TC-6.2**: Order includes paymentMethod field (cash/apple_pay/google_pay)
- [ ] **TC-6.3**: Order includes paymentStatus field (pending/paid/failed)
- [ ] **TC-6.4**: Cash orders have paymentStatus: 'paid' immediately
- [ ] **TC-6.5**: Stripe orders have paymentStatus: 'pending' initially, then 'paid' after success
- [ ] **TC-6.6**: Failed Stripe payments have paymentStatus: 'failed'
- [ ] **TC-6.7**: Order includes paymentIntentId for Stripe payments
- [ ] **TC-6.8**: Order includes createdAt timestamp
- [ ] **TC-6.9**: Order includes updatedAt timestamp on status changes

### 7. Error Handling
- [ ] **TC-7.1**: Network error during PaymentIntent creation → Verify error snackbar
- [ ] **TC-7.2**: Stripe not configured → Verify graceful error handling
- [ ] **TC-7.3**: Invalid amount (0 or negative) → Verify validation error
- [ ] **TC-7.4**: Firestore unavailable → Verify order creation fails gracefully
- [ ] **TC-7.5**: PaymentSheet initialization fails → Verify error message
- [ ] **TC-7.6**: User cancels payment → Verify order still created with failed status

### 8. Platform-Specific
- [ ] **TC-8.1 (iOS)**: Apple Pay appears in PaymentSheet when available
- [ ] **TC-8.2 (iOS)**: Google Pay does NOT appear on iOS
- [ ] **TC-8.3 (Android)**: Google Pay appears in PaymentSheet when available
- [ ] **TC-8.4 (Android)**: Apple Pay does NOT appear on Android
- [ ] **TC-8.5**: Cash appears on both platforms

### 9. Integration with Existing Modules
- [ ] **TC-9.1**: Para marketplace → Cart → Checkout → Verify Wallet integration works
- [ ] **TC-9.2**: Grocery marketplace → Cart → Checkout → Verify Wallet integration works
- [ ] **TC-9.3**: Food marketplace → Cart → Checkout → Verify Wallet integration works
- [ ] **TC-9.4**: Order items passed correctly from cart to checkout
- [ ] **TC-9.5**: Totals calculated correctly (subtotal + delivery + tax)

### 10. Security & Data Validation
- [ ] **TC-10.1**: Stripe secret key NOT exposed in Flutter code
- [ ] **TC-10.2**: PaymentIntent created server-side only
- [ ] **TC-10.3**: Client secret returned securely
- [ ] **TC-10.4**: Order amounts validated (positive numbers only)
- [ ] **TC-10.5**: Currency fixed to MAD (no USD/EUR)

## Test Data
- **Test Amounts**: 100 MAD (10000 cents), 500 MAD (50000 cents)
- **Test Order Items**: Sample products with prices in MAD
- **Test Users**: Authenticated user and guest user

## Expected Results
- ✅ Wallet selection persists across app sessions
- ✅ Cash orders created immediately with paid status
- ✅ Stripe payments process through PaymentSheet
- ✅ Orders created in Firestore with correct structure
- ✅ Error handling is graceful and user-friendly
- ✅ Platform-specific payment methods appear correctly
- ✅ No security vulnerabilities (no secret keys in client)

## Notes
- Test mode should be enabled in Stripe Dashboard
- Google Pay testEnv should be true for development
- Apple Pay requires merchant identifier configuration
- Firestore rules should allow order creation by authenticated and guest users

