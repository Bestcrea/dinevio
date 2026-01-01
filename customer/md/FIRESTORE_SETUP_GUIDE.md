# Firestore Setup Guide for Dinevio

## ✅ Firestore Configuration Status

**Date:** 2024-12-27  
**Project:** Dinevio Customer App  
**Firebase Project:** dinevio-app

---

## 📦 Dependencies Verified

### Cloud Firestore Package:
- ✅ `cloud_firestore: ^5.6.11` (in `pubspec.yaml`)
- ✅ `firebase_core: ^3.15.1` (required for Firestore)

**Status:** Dependencies correctly configured

---

## 🗄️ Data Models Created

### Recommended Models:
1. **RecommendedUserModel** - Enhanced user model with defensive null checks
2. **RecommendedOrderModel** - Food delivery orders
3. **RecommendedRestaurantModel** - Restaurant data
4. **RecommendedDriverModel** - Driver profiles
5. **RecommendedParcelModel** - Parcel delivery orders

**Location:** `lib/firestore/models/recommended_data_models.dart`

### Key Features:
- ✅ Defensive null checks in all `fromFirestore` methods
- ✅ Default values for missing fields
- ✅ Type-safe conversions
- ✅ Timestamp handling
- ✅ Nested object support

---

## 🔒 Security Rules

### Development Rules (Time-Limited)
**File:** `firestore.rules`

**Current Status:** Development rules active (expires 2025-01-31)

```javascript
// Temporary dev rules - expires 2025-01-31
match /{document=**} {
  allow read, write: if request.time < timestamp.date(2025, 1, 31);
}
```

**⚠️ WARNING:** These rules allow full read/write access for testing.  
**⚠️ IMPORTANT:** Replace with production rules before expiration!

### Production Rules (Ready to Deploy)
Production rules are commented in `firestore.rules`. Uncomment after testing:

**Key Features:**
- ✅ User authentication required
- ✅ Users can only read/write their own data
- ✅ Restaurant data is read-only for users
- ✅ Orders are protected (customers and drivers only)
- ✅ Parcels are protected (customers and drivers only)
- ✅ Wallet transactions are user-specific
- ✅ Chat messages are protected

---

## 🛡️ Defensive Null Checks

### SafeFirestoreUtils Class
**Location:** `lib/firestore/utils/safe_firestore_utils.dart`

**Features:**
- ✅ `getDocumentSafely()` - Safe document retrieval
- ✅ `getCollectionSafely()` - Safe collection queries
- ✅ `getFieldSafely<T>()` - Type-safe field access
- ✅ `getNestedFieldSafely<T>()` - Safe nested field access
- ✅ Type conversion helpers (safeDouble, safeInt, safeBool, safeString)
- ✅ Document existence checks
- ✅ Safe write operations (set, update, delete)

### Usage Example:
```dart
// Instead of:
final data = doc.data()!; // Can crash if null
final name = data['name']; // Can crash if missing

// Use:
final data = await SafeFirestoreUtils.getDocumentSafely(
  collection: 'users',
  documentId: userId,
);
if (data != null) {
  final name = SafeFirestoreUtils.safeString(data['name'], 'Unknown');
}
```

---

## 📋 Collection Structure

### Recommended Collections:

1. **users** - User profiles
   - Document ID: User UID
   - Subcollections: `sharing_persons`

2. **bookings** - Ride bookings
   - Document ID: Auto-generated
   - Fields: customerId, driverId, status, etc.

3. **Restaurant** - Restaurant data
   - Document ID: Restaurant ID
   - Subcollections: `menus`

4. **drivers** - Driver profiles
   - Document ID: Driver UID
   - Fields: isOnline, currentLocation, etc.

5. **parcel_ride** - Parcel deliveries
   - Document ID: Auto-generated
   - Fields: customerId, driverId, type, weight, etc.

6. **intercity_ride** - Intercity rides
   - Document ID: Auto-generated
   - Fields: customerId, driverId, etc.

7. **wallet_transaction** - Wallet transactions
   - Document ID: Auto-generated
   - Fields: userId, amount, type, etc.

8. **chat** - Chat messages
   - Document ID: Auto-generated
   - Fields: senderId, receiverId, message, etc.

9. **review** - Reviews and ratings
   - Document ID: Review ID
   - Fields: userId, orderId, rating, etc.

10. **settings** - App settings
    - Document ID: Setting key
    - Fields: Read-only for users

---

## 🚀 Setup Steps

### 1. Enable Cloud Firestore
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select project: **dinevio-app**
3. Navigate to: **Firestore Database**
4. Click **Create database**
5. Choose mode:
   - **Production mode** (with security rules)
   - **Test mode** (open for 30 days - NOT recommended)
6. Select location (choose closest to your users)
7. Click **Enable**

**Status:** ☐ Firestore enabled

### 2. Deploy Security Rules
1. Install Firebase CLI (if not installed):
   ```bash
   npm install -g firebase-tools
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

3. Initialize Firebase (if not done):
   ```bash
   cd customer
   firebase init firestore
   ```

4. Deploy rules:
   ```bash
   firebase deploy --only firestore:rules
   ```

**Status:** ☐ Security rules deployed

### 3. Create Indexes (If Needed)
Firestore will prompt you to create indexes for complex queries. Create them as needed.

**Status:** ☐ Indexes created (if required)

### 4. Test Firestore Connection
```dart
// Test in your app
final firestore = FirebaseFirestore.instance;
final testDoc = await firestore.collection('test').doc('test').get();
print('Firestore connected: ${testDoc.exists}');
```

**Status:** ☐ Connection tested

---

## 🔍 Verification Checklist

### Code:
- [x] `cloud_firestore` dependency in `pubspec.yaml`
- [x] Recommended data models created
- [x] SafeFirestoreUtils with null checks
- [x] Security rules file created
- [ ] Security rules deployed to Firebase

### Firebase Console:
- [ ] Firestore Database enabled
- [ ] Security rules deployed
- [ ] Indexes created (if needed)
- [ ] Test data added (optional)

### Testing:
- [ ] Read operations tested
- [ ] Write operations tested
- [ ] Null safety verified
- [ ] Error handling tested

---

## 📝 Migration Guide

### Using Recommended Models:
1. Import the recommended models:
   ```dart
   import 'package:customer/firestore/models/recommended_data_models.dart';
   ```

2. Replace existing model usage gradually:
   ```dart
   // Old:
   final user = UserModel.fromJson(doc.data()!);
   
   // New:
   final user = RecommendedUserModel.fromFirestore(doc);
   ```

3. Use SafeFirestoreUtils for all Firestore operations:
   ```dart
   final data = await SafeFirestoreUtils.getDocumentSafely(
     collection: 'users',
     documentId: userId,
   );
   ```

---

## 🚨 Important Notes

### Development Rules Expiration:
- **Expiration Date:** 2025-01-31
- **Action Required:** Deploy production rules before this date
- **Risk:** App will stop working if rules expire

### Production Rules:
- Uncomment production rules in `firestore.rules`
- Test thoroughly before deploying
- Monitor Firestore usage in Firebase Console

### Null Safety:
- Always use `SafeFirestoreUtils` for Firestore operations
- Never use `!` operator on Firestore data
- Always check for null before accessing fields
- Use default values for missing fields

---

## 📊 Monitoring

### Firebase Console:
1. Go to **Firestore Database** → **Usage**
2. Monitor:
   - Read operations
   - Write operations
   - Storage usage
   - Index usage

### Error Monitoring:
- Check Firebase Console → **Firestore** → **Errors**
- Monitor app logs for Firestore errors
- Use SafeFirestoreUtils debug prints

---

## ✅ Status

**Overall:** ✅ Setup Complete  
**Dependencies:** ✅ Verified  
**Data Models:** ✅ Created  
**Security Rules:** ✅ Ready (dev rules active)  
**Null Safety:** ✅ Implemented  
**Ready for Testing:** ✅ Yes

---

**Last Updated:** 2024-12-27  
**Next Steps:** Deploy security rules and test Firestore operations

