# Firebase Authentication Setup Checklist for Dinevio

## 📋 Step-by-Step Console Configuration

Follow this checklist to properly configure Firebase Authentication for Phone Auth in your Dinevio app.

---

## ✅ Step 1: Enable Phone Authentication Provider

### In Firebase Console:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **dinevio-app**
3. Navigate to: **Authentication** → **Sign-in method**
4. Find **Phone** in the list of providers
5. Click on **Phone** to open settings
6. Toggle **Enable** to ON
7. Click **Save**

**Status:** ☐ Phone provider enabled

---

## ✅ Step 2: Add Android SHA-1 and SHA-256 Certificates

### Why This Is Needed:
Firebase uses SHA certificates to verify that requests come from your Android app. Without these, Phone Auth will fail on Android.

### For Debug Build (Development):
1. Open terminal/command prompt
2. Navigate to your Android keystore directory:
   ```bash
   cd customer/android/app
   ```
3. Get SHA-1:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
   Or on macOS/Linux:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep SHA1
   ```
4. Get SHA-256:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep SHA256
   ```

### For Release Build (Production):
1. Use your release keystore (e.g., `dinevio_test.keystore`):
   ```bash
   keytool -list -v -keystore customer/android/app/dinevio_test.keystore -alias <your-alias>
   ```
2. Enter keystore password when prompted
3. Copy SHA-1 and SHA-256 values

### Add to Firebase Console:
1. Go to: **Project Settings** → **Your apps** → **Android app**
2. Click on your Android app: **com.dinevio.customer**
3. Scroll to **SHA certificate fingerprints**
4. Click **Add fingerprint**
5. Paste SHA-1 value → Click **Save**
6. Click **Add fingerprint** again
7. Paste SHA-256 value → Click **Save**

**Status:** ☐ Debug SHA-1 added  
**Status:** ☐ Debug SHA-256 added  
**Status:** ☐ Release SHA-1 added  
**Status:** ☐ Release SHA-256 added

---

## ✅ Step 3: iOS APNs (Apple Push Notification Service) Configuration

### Why This Is Needed:
iOS Phone Auth uses APNs for silent push notifications to verify phone numbers. Without APNs, Phone Auth will fail on iOS.

### Option A: Using Firebase Cloud Messaging (FCM) - Recommended
1. Go to: **Project Settings** → **Cloud Messaging** tab
2. Under **Apple app configuration**, upload your APNs certificate or key
3. If you don't have one, create it:
   - Go to [Apple Developer Portal](https://developer.apple.com/account/)
   - Navigate to **Certificates, Identifiers & Profiles**
   - Create APNs Key or Certificate
   - Download and upload to Firebase

### Option B: Manual APNs Setup
1. In Firebase Console: **Project Settings** → **Cloud Messaging**
2. Under **Apple app configuration**:
   - Upload **APNs Authentication Key** (.p8 file)
   - Or upload **APNs Certificates** (.p12 file)
3. Enter **Key ID** and **Team ID** (if using .p8 key)

### Get APNs Key/Certificate:
1. **APNs Key (.p8)** - Recommended:
   - Apple Developer Portal → **Keys**
   - Create new key with **Apple Push Notifications service (APNs)** enabled
   - Download .p8 file
   - Note the **Key ID**

2. **APNs Certificate (.p12)**:
   - Apple Developer Portal → **Certificates**
   - Create **Apple Push Notification service SSL** certificate
   - Download and convert to .p12

**Status:** ☐ APNs key/certificate uploaded to Firebase

---

## ✅ Step 4: Verify App Configuration Files

### Android:
- [ ] `android/app/google-services.json` exists
- [ ] `google-services.json` contains correct `package_name`: `com.dinevio.customer`
- [ ] `android/app/build.gradle` has `com.google.gms.google-services` plugin applied
- [ ] `android/settings.gradle` has Google Services plugin declared

### iOS:
- [ ] `ios/Runner/GoogleService-Info.plist` exists
- [ ] `GoogleService-Info.plist` contains correct `BUNDLE_ID`: `com.mytaxi.customers`
- [ ] File is included in Xcode project (Runner target)

### Web:
- [ ] `lib/firebase_options.dart` contains web configuration
- [ ] Web options include `authDomain`: `dinevio-app.firebaseapp.com`

**Status:** ☐ All configuration files verified

---

## ✅ Step 5: Test Phone Authentication

### Test Flow:
1. **Request Code:**
   - Enter phone number in app
   - Tap "Send Code"
   - Check Firebase Console → **Authentication** → **Users** for verification attempts

2. **Verify Code:**
   - Enter SMS code received
   - Tap "Verify"
   - Check if user is created in Firebase Console

### Common Issues:
- **"invalid-phone-number"**: Phone number format incorrect
- **"quota-exceeded"**: SMS quota exceeded (check Firebase Console)
- **"operation-not-allowed"**: Phone provider not enabled (Step 1)
- **"app-not-authorized"**: SHA certificates missing (Step 2)
- **iOS silent push fails**: APNs not configured (Step 3)

**Status:** ☐ Test phone authentication successful

---

## ✅ Step 6: Configure ReCAPTCHA (Web - Optional)

If using Phone Auth on web:
1. Go to: **Authentication** → **Settings** → **Authorized domains**
2. Add your web domain (e.g., `dinevio.com`)
3. ReCAPTCHA will be used for web Phone Auth

**Status:** ☐ Web domains authorized (if applicable)

---

## ✅ Step 7: Set Up Test Phone Numbers (Optional)

For testing without sending real SMS:
1. Go to: **Authentication** → **Sign-in method** → **Phone**
2. Scroll to **Phone numbers for testing**
3. Click **Add phone number**
4. Add test numbers (e.g., `+212600000000`)
5. Enter test code (e.g., `123456`)

**Status:** ☐ Test phone numbers configured (optional)

---

## ✅ Step 8: Monitor Usage and Quotas

### Check SMS Quota:
1. Go to: **Authentication** → **Settings** → **Usage**
2. Monitor **SMS messages sent**
3. Check quota limits (free tier: 10 SMS/day)

### Upgrade if Needed:
- Firebase Blaze plan required for production SMS
- Free tier is for development/testing only

**Status:** ☐ SMS quota monitored

---

## 📝 Quick Reference Commands

### Get SHA-1/SHA-256 (Debug):
```bash
# SHA-1
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep SHA1

# SHA-256
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep SHA256
```

### Get SHA-1/SHA-256 (Release):
```bash
keytool -list -v -keystore customer/android/app/dinevio_test.keystore -alias <alias>
```

### Verify Firebase Config:
```bash
# Check if google-services.json exists
ls -la customer/android/app/google-services.json

# Check if GoogleService-Info.plist exists
ls -la customer/ios/Runner/GoogleService-Info.plist
```

---

## 🚨 Troubleshooting

### Android Phone Auth Not Working:
1. ✅ Verify SHA-1/SHA-256 are added in Firebase Console
2. ✅ Check `google-services.json` is in correct location
3. ✅ Verify package name matches: `com.dinevio.customer`
4. ✅ Rebuild app after adding SHA certificates

### iOS Phone Auth Not Working:
1. ✅ Verify APNs is configured in Firebase Console
2. ✅ Check `GoogleService-Info.plist` bundle ID: `com.mytaxi.customers`
3. ✅ Ensure APNs key/certificate is valid and not expired
4. ✅ Test on real device (not simulator for APNs)

### Web Phone Auth Not Working:
1. ✅ Verify web options in `firebase_options.dart`
2. ✅ Check `authDomain` is correct
3. ✅ Ensure domain is authorized in Firebase Console
4. ✅ ReCAPTCHA may be required

---

## ✅ Final Checklist

Before going to production:
- [ ] Phone provider enabled
- [ ] SHA-1 and SHA-256 added (both debug and release)
- [ ] APNs configured for iOS
- [ ] Test authentication successful
- [ ] Error handling implemented in app
- [ ] User-friendly error messages added
- [ ] Debug logging added (non-sensitive)
- [ ] SMS quota monitored
- [ ] Production keystore SHA certificates added

---

**Last Updated:** 2024-12-27  
**Project:** Dinevio Customer App  
**Firebase Project:** dinevio-app

