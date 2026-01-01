import 'dart:developer';
import 'package:customer/app/models/user_model.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/utils/notification_service.dart';
import 'package:get/get.dart';

class ProfileScreenController extends GetxController {
  // User data with safe defaults
  RxString name = 'Guest'.obs;
  RxString phone = ''.obs; // Empty for guest
  RxString profilePic = ''.obs;
  RxDouble rating = 5.0.obs;
  RxDouble profileCompletion = 0.0.obs;

  // State flags
  RxBool isLoading = true.obs;
  RxBool isGuest = false.obs; // True if user is not logged in

  @override
  void onInit() {
    super.onInit();
    // Load data asynchronously without blocking screen
    _loadUserData();
  }

  /// Load user data with defensive error handling
  Future<void> _loadUserData() async {
    try {
      isLoading.value = true;
      
      // Check if user is logged in
      final uid = FireStoreUtils.getCurrentUid();
      if (uid == null) {
        // User not logged in - show Guest UI
        _setGuestDefaults();
        isLoading.value = false;
        return;
      }

      // Try to load user profile from Firestore
      try {
        final UserModel? user = await FireStoreUtils.getUserProfile(uid);
        if (user != null) {
          // User document exists - load data safely
          _loadUserDataSafely(user);
          
          // Update FCM token (non-blocking)
          try {
            user.fcmToken = await NotificationService.getToken();
            await FireStoreUtils.updateUser(user);
          } catch (e) {
            log('Failed to update FCM token: $e');
            // Non-critical, continue
          }
        } else {
          // User document missing - use safe defaults
          log('User document not found for uid: $uid');
          _setSafeDefaults();
        }
      } catch (e, stackTrace) {
        // Firestore error - use safe defaults
        log('Error loading user profile: $e');
        log('Stack trace: $stackTrace');
        _setSafeDefaults();
      }
    } catch (e, stackTrace) {
      // Critical error - use safe defaults
      log('Critical error in _loadUserData: $e');
      log('Stack trace: $stackTrace');
      _setSafeDefaults();
    } finally {
      // Always stop loading, never block screen
      isLoading.value = false;
    }
  }

  /// Set guest defaults (user not logged in)
  void _setGuestDefaults() {
    isGuest.value = true;
    name.value = 'Guest';
    phone.value = ''; // No phone for guest
    profilePic.value = '';
    rating.value = 5.0; // Default rating
    profileCompletion.value = 0.0; // No completion for guest
  }

  /// Set safe defaults when Firestore doc is missing or error occurs
  void _setSafeDefaults() {
    isGuest.value = false; // User is logged in but data missing
    name.value = 'User';
    phone.value = ''; // Safe default
    profilePic.value = '';
    rating.value = 5.0;
    profileCompletion.value = 0.0;
  }

  /// Load user data safely with null checks
  void _loadUserDataSafely(UserModel user) {
    isGuest.value = false;
    
    // Name with safe fallback
    name.value = (user.fullName ?? '').trim().isNotEmpty
        ? user.fullName!.trim()
        : 'User';
    
    // Phone with safe fallback
    final countryCode = (user.countryCode ?? '').trim();
    final phoneNumber = (user.phoneNumber ?? '').trim();
    phone.value = (countryCode.isNotEmpty && phoneNumber.isNotEmpty)
        ? '$countryCode$phoneNumber'
        : '';
    
    // Profile picture with safe fallback
    profilePic.value = (user.profilePic ?? '').trim();
    
    // Calculate profile completion safely
    double completion = 0.0;
    if ((user.fullName ?? '').trim().isNotEmpty) completion += 0.25;
    if ((user.email ?? '').trim().isNotEmpty) completion += 0.25;
    if ((user.profilePic ?? '').trim().isNotEmpty) completion += 0.25;
    if ((user.dateOfBirth ?? '').trim().isNotEmpty) completion += 0.25;
    profileCompletion.value = completion.clamp(0.0, 1.0);
    
    // Rating (default if not available)
    rating.value = 5.0; // Could be loaded from reviews if available
  }

  /// Refresh user data
  Future<void> refreshUserData() async {
    await _loadUserData();
  }

  /// Get user initial for avatar
  String get userInitial {
    if (name.value.isNotEmpty) {
      return name.value[0].toUpperCase();
    }
    return 'G'; // 'G' for Guest
  }
}

