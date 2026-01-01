# Personal Information Profile Settings - Test Plan

## Overview
This document outlines the test plan for the Personal Information Profile Settings screen in Dinevio Flutter app.

## Test Environment
- **Platforms**: iOS and Android
- **Flutter Version**: Latest stable
- **GetX**: State management
- **Firebase**: Authentication, Firestore, Storage

## Test Cases

### 1. Navigation & Access
- [ ] **TC-1.1**: From Profile/Account screen, tap "Personal information" → Should navigate to Profile Settings screen
- [ ] **TC-1.2**: Profile Settings screen displays with "Profile settings" title
- [ ] **TC-1.3**: Back button returns to Profile screen
- [ ] **TC-1.4**: Guest user sees "Sign in to edit profile" message
- [ ] **TC-1.5**: Guest user can tap "Sign in" button → Navigates to login screen

### 2. Avatar Section
- [ ] **TC-2.1**: Avatar displays user's photo if available
- [ ] **TC-2.2**: Avatar displays initial (first letter of first name) if no photo
- [ ] **TC-2.3**: Floating action button (camera icon) appears on bottom-right of avatar
- [ ] **TC-2.4**: Tap camera button → Opens image picker (gallery)
- [ ] **TC-2.5**: Select image from gallery → Shows loading indicator
- [ ] **TC-2.6**: Image uploads to Firebase Storage successfully
- [ ] **TC-2.7**: Avatar updates with new photo after upload
- [ ] **TC-2.8**: Success snackbar appears after upload
- [ ] **TC-2.9**: Cancel image picker → No changes made
- [ ] **TC-2.10**: Upload failure shows error snackbar

### 3. Form Fields - Display & Input
- [ ] **TC-3.1**: First name field displays with label "First name *"
- [ ] **TC-3.2**: Last name field displays with label "Last name *"
- [ ] **TC-3.3**: Email field displays with label "Email"
- [ ] **TC-3.4**: Phone number field displays with country code picker
- [ ] **TC-3.5**: Country field displays with label "Country" and "Use my location" button
- [ ] **TC-3.6**: City field displays with label "City" and "Use my location" button
- [ ] **TC-3.7**: All fields have light grey background (#F5F5F5 / #F7F7F7)
- [ ] **TC-3.8**: All fields have rounded corners (radius 18)
- [ ] **TC-3.9**: Fields are pre-filled with existing user data
- [ ] **TC-3.10**: Empty fields show placeholder text

### 4. Phone Number Input
- [ ] **TC-4.1**: Country code picker displays current country code
- [ ] **TC-4.2**: Tap country code picker → Opens country selection
- [ ] **TC-4.3**: Select different country → Country code updates
- [ ] **TC-4.4**: Phone number input accepts digits only
- [ ] **TC-4.5**: Phone number validation works (8-15 digits)

### 5. Location Detection (GPS)
- [ ] **TC-5.1**: Tap "Use my location" on Country field → Requests location permission
- [ ] **TC-5.2**: Grant location permission → Shows loading indicator
- [ ] **TC-5.3**: Location detected successfully → Country and City fields populated
- [ ] **TC-5.4**: Success snackbar appears after location detection
- [ ] **TC-5.5**: Deny location permission → Shows friendly error message
- [ ] **TC-5.6**: Location services disabled → Shows error message
- [ ] **TC-5.7**: GPS timeout → Shows error message
- [ ] **TC-5.8**: Manual input fallback: Tap Country/City field → Opens input dialog
- [ ] **TC-5.9**: Enter location manually → Field updates correctly

### 6. Form Validation
- [ ] **TC-6.1**: Leave first name empty → Save button disabled (or shows validation error)
- [ ] **TC-6.2**: Leave last name empty → Save button disabled (or shows validation error)
- [ ] **TC-6.3**: Enter invalid email format → Shows validation error
- [ ] **TC-6.4**: Enter valid email → No validation error
- [ ] **TC-6.5**: Enter invalid phone number → Shows validation error
- [ ] **TC-6.6**: Enter valid phone number → No validation error
- [ ] **TC-6.7**: All required fields filled → Save button enabled

### 7. Save Functionality
- [ ] **TC-7.1**: Make changes to form fields → Save button becomes enabled
- [ ] **TC-7.2**: No changes made → Save button disabled
- [ ] **TC-7.3**: Tap Save button → Shows loading indicator
- [ ] **TC-7.4**: Save successful → Shows success snackbar "Profile updated successfully"
- [ ] **TC-7.5**: Save successful → Navigates back to Profile screen
- [ ] **TC-7.6**: Save successful → Profile data updated in Firestore
- [ ] **TC-7.7**: Save successful → Country and City saved to Firestore
- [ ] **TC-7.8**: Save failure → Shows error snackbar
- [ ] **TC-7.9**: Save button disabled while uploading photo
- [ ] **TC-7.10**: Save button disabled while detecting location

### 8. Data Persistence
- [ ] **TC-8.1**: Update profile → Close and reopen screen → Changes persist
- [ ] **TC-8.2**: Upload avatar → Close and reopen screen → Avatar persists
- [ ] **TC-8.3**: Update location → Close and reopen screen → Location persists
- [ ] **TC-8.4**: Data syncs correctly with Firestore

### 9. UI/UX Polish
- [ ] **TC-9.1**: Avatar action button has tap animation (scale 0.96)
- [ ] **TC-9.2**: Save button has tap animation (scale 0.96)
- [ ] **TC-9.3**: All text readable with textScaleFactor up to 1.5
- [ ] **TC-9.4**: No overflow on small screens (320px width)
- [ ] **TC-9.5**: Loading states show appropriate indicators
- [ ] **TC-9.6**: Error messages are user-friendly
- [ ] **TC-9.7**: Colors match Dinevio brand (#7E57C2 purple)

### 10. Error Handling
- [ ] **TC-10.1**: Network error during save → Shows error message
- [ ] **TC-10.2**: Firestore unavailable → Shows error message
- [ ] **TC-10.3**: Storage upload failure → Shows error message
- [ ] **TC-10.4**: Location permission denied → Shows friendly message
- [ ] **TC-10.5**: Invalid image format → Shows error message
- [ ] **TC-10.6**: App doesn't crash on any error scenario

### 11. Guest User Flow
- [ ] **TC-11.1**: Guest user sees "Sign in to edit profile" screen
- [ ] **TC-11.2**: Guest user cannot access form fields
- [ ] **TC-11.3**: Guest user can tap "Sign in" button
- [ ] **TC-11.4**: After sign in, user can access profile settings

## Test Data
- **Test User**: Authenticated user with existing profile
- **Test Guest**: User not logged in
- **Test Locations**: Various GPS coordinates (Morocco, other countries)
- **Test Images**: Various formats (JPG, PNG), sizes (small, large)

## Expected Results
- ✅ All navigation flows work smoothly
- ✅ Avatar upload works correctly
- ✅ GPS location detection works with fallback
- ✅ Form validation prevents invalid data
- ✅ Data persists correctly in Firestore
- ✅ No crashes on any scenario
- ✅ UI is responsive and accessible
- ✅ Guest users handled gracefully

## Notes
- Test on real devices for GPS functionality
- Test with various network conditions
- Test with location permissions denied
- Test with storage permissions denied
- Verify Firestore rules allow user profile updates

