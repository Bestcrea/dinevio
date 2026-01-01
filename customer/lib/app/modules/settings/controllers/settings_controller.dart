import 'package:customer/services/localization_service.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller for Settings screen
class SettingsController extends GetxController {
  // Language
  final RxString selectedLanguage = 'english'.obs;
  final List<Map<String, String>> languages = [
    {'code': 'ar', 'name': 'Arabic', 'display': 'العربية'},
    {'code': 'en', 'name': 'English', 'display': 'English'},
    {'code': 'fr', 'name': 'Français', 'display': 'Français'},
    {'code': 'es', 'name': 'Español', 'display': 'Español'},
    {'code': 'de', 'name': 'Germany', 'display': 'Deutsch'},
  ];

  // Distance unit
  final RxString selectedDistanceUnit = 'kilometres'.obs; // 'kilometres' | 'miles'

  // Dark mode
  final RxString selectedDarkMode = 'system'.obs; // 'off' | 'always' | 'system'

  // Navigation app
  final RxString selectedNavigation = 'google_maps'.obs; // 'apple_maps' | 'google_maps'

  // Phone number
  final RxString phoneNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPhoneNumber();
    _loadSettings();
  }

  /// Load phone number from user profile
  Future<void> _loadPhoneNumber() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user?.phoneNumber != null) {
        phoneNumber.value = user!.phoneNumber!;
      } else {
        // Try to load from Firestore
        final uid = user?.uid;
        if (uid != null) {
          try {
            final userModel = await FireStoreUtils.getUserProfile(uid);
            if (userModel != null) {
              final countryCode = (userModel.countryCode ?? '').trim();
              final phoneNum = (userModel.phoneNumber ?? '').trim();
              if (countryCode.isNotEmpty && phoneNum.isNotEmpty) {
                phoneNumber.value = '$countryCode$phoneNum';
              }
            }
          } catch (e) {
            phoneNumber.value = '';
          }
        }
      }
    } catch (e) {
      phoneNumber.value = '';
    }
  }

  /// Load saved settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load language
      final savedLanguage = prefs.getString('settings_language');
      if (savedLanguage != null) {
        selectedLanguage.value = savedLanguage;
      }
      
      // Load distance unit
      final savedDistance = prefs.getString('settings_distance');
      if (savedDistance != null) {
        selectedDistanceUnit.value = savedDistance;
      }
      
      // Load dark mode
      final savedDarkMode = prefs.getString('settings_dark_mode');
      if (savedDarkMode != null) {
        selectedDarkMode.value = savedDarkMode;
      }
      
      // Load navigation
      final savedNavigation = prefs.getString('settings_navigation');
      if (savedNavigation != null) {
        selectedNavigation.value = savedNavigation;
      }
    } catch (e) {
      // Use defaults if loading fails
    }
  }

  /// Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('settings_language', selectedLanguage.value);
      await prefs.setString('settings_distance', selectedDistanceUnit.value);
      await prefs.setString('settings_dark_mode', selectedDarkMode.value);
      await prefs.setString('settings_navigation', selectedNavigation.value);
    } catch (e) {
      // Silent fail
    }
  }

  /// Set language
  void setLanguage(String language) {
    selectedLanguage.value = language;
    _saveSettings();
    
    // Apply language change
    final langData = languages.firstWhere((l) => l['name']?.toLowerCase() == language.toLowerCase());
    if (langData['code'] != null) {
      LocalizationService().changeLocale(langData['code']!);
    }
  }

  /// Set distance unit
  void setDistanceUnit(String unit) {
    selectedDistanceUnit.value = unit;
    _saveSettings();
  }

  /// Set dark mode
  void setDarkMode(String mode, BuildContext context) {
    selectedDarkMode.value = mode;
    _saveSettings();
    
    // Apply dark mode change
    // DarkThemeProvider uses int: 0 = dark, 1 = light, 2 = system
    final themeProvider = Provider.of<DarkThemeProvider>(context, listen: false);
    switch (mode) {
      case 'off':
        themeProvider.darkTheme = 1; // Light mode
        break;
      case 'always':
        themeProvider.darkTheme = 0; // Dark mode
        break;
      case 'system':
        themeProvider.darkTheme = 2; // System theme
        break;
    }
  }

  /// Set navigation app
  void setNavigation(String navigation) {
    selectedNavigation.value = navigation;
    _saveSettings();
  }

  /// Log out user
  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Failed to log out: $e');
    }
  }

  /// Delete account (placeholder - should be implemented with proper backend)
  Future<void> deleteAccount() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // TODO: Implement proper account deletion with backend
          await user.delete();
          Get.offAllNamed('/login');
          Get.snackbar('Success', 'Account deleted successfully');
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete account: $e');
      }
    }
  }
}

