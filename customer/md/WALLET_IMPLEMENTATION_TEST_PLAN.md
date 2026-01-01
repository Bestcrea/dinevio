# Wallet Implementation Test Plan

## Overview
This document outlines the test plan for the Wallet module implementation in Dinevio Flutter app.

## Test Environment
- **Platforms**: iOS and Android
- **Flutter Version**: Latest stable
- **GetX**: State management
- **Firebase**: Authentication and Firestore (optional for guest users)

## Test Cases

### 1. Navigation Flow
- [ ] **TC-1.1**: From Profile/Account screen, tap "Payment methods" → Should navigate to Wallet screen
- [ ] **TC-1.2**: Wallet screen displays with "Wallet" title and close (X) button
- [ ] **TC-1.3**: Close button returns to Profile screen
- [ ] **TC-1.4**: From Wallet screen, tap "+ Add payment method" → Should navigate to Add Payment Method screen
- [ ] **TC-1.5**: Back button from Add Payment Method returns to Wallet screen

### 2. Platform-Specific Payment Methods
- [ ] **TC-2.1 (iOS)**: Wallet screen shows only "Apple Pay" and "Cash" options
- [ ] **TC-2.2 (iOS)**: "Google Pay" should NOT appear on iOS
- [ ] **TC-2.3 (Android)**: Wallet screen shows only "Google Pay" and "Cash" options
- [ ] **TC-2.4 (Android)**: "Apple Pay" should NOT appear on Android
- [ ] **TC-2.5**: "Cash" appears on both iOS and Android

### 3. Payment Method Selection
- [ ] **TC-3.1**: Tap on a payment method row → Method becomes selected (checkmark appears)
- [ ] **TC-3.2**: Selected method persists after closing and reopening Wallet screen
- [ ] **TC-3.3**: Selecting a different method updates the selection
- [ ] **TC-3.4**: Selection triggers haptic feedback (if supported)
- [ ] **TC-3.5**: Selection shows success snackbar with method name

### 4. Add Payment Method Screen
- [ ] **TC-4.1**: Add Payment Method screen displays available methods to add
- [ ] **TC-4.2 (iOS)**: Shows "Apple Pay" option if not already added
- [ ] **TC-4.3 (Android)**: Shows "Google Pay" option if not already added
- [ ] **TC-4.4**: Shows "Card" option with "Coming soon" label (disabled)
- [ ] **TC-4.5**: Tapping Apple Pay/Google Pay adds it to wallet and returns to Wallet screen
- [ ] **TC-4.6**: Added method appears in Wallet screen list

### 5. Persistence
- [ ] **TC-5.1**: Selected payment method persists after app restart (local storage)
- [ ] **TC-5.2**: If user is logged in, selection should sync to Firestore (when implemented)
- [ ] **TC-5.3**: Guest users can still select and persist methods locally
- [ ] **TC-5.4**: If Firestore is unavailable, local storage still works

### 6. UI/UX
- [ ] **TC-6.1**: All text is readable with textScaleFactor up to 1.5
- [ ] **TC-6.2**: No overflow errors on small screens (320px width)
- [ ] **TC-6.3**: Row tap animations are smooth (scale 0.98, 100ms)
- [ ] **TC-6.4**: Colors match Dinevio brand (#7E57C2 purple)
- [ ] **TC-6.5**: Dividers are subtle and properly aligned
- [ ] **TC-6.6**: Icons are properly sized and colored

### 7. Error Handling
- [ ] **TC-7.1**: App doesn't crash if Firestore is unavailable
- [ ] **TC-7.2**: App doesn't crash if SharedPreferences fails
- [ ] **TC-7.3**: Guest users can use wallet without authentication errors
- [ ] **TC-7.4**: Invalid method types are handled gracefully

### 8. Edge Cases
- [ ] **TC-8.1**: Wallet screen loads correctly when no methods are available
- [ ] **TC-8.2**: Switching between methods quickly doesn't cause state issues
- [ ] **TC-8.3**: Network errors don't block local wallet functionality
- [ ] **TC-8.4**: App handles platform detection correctly (iOS/Android)

## Test Data
- **Default Method**: Cash (should be pre-selected)
- **Test User**: Both authenticated and guest users
- **Network**: Both online and offline scenarios

## Expected Results
- ✅ All navigation flows work smoothly
- ✅ Platform-specific methods display correctly
- ✅ Selection persists across app sessions
- ✅ No crashes or errors
- ✅ UI is responsive and accessible
- ✅ Brand colors and styling are consistent

## Notes
- Stripe integration is not yet implemented (coming soon)
- Card payment method is disabled with "Coming soon" label
- Firestore sync is optional and won't block local functionality

