import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:customer/app/models/user_model.dart';
import 'package:customer/utils/fire_store_utils.dart';

class PersonalInfoController extends GetxController {
  // Form controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  // State
  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;
  final RxBool isUploadingPhoto = false.obs;
  final RxBool isDetectingLocation = false.obs;
  final RxString photoUrl = ''.obs;
  final RxString selectedCountryCode = '+212'.obs; // Default Morocco
  final RxBool isGuest = false.obs;
  final RxBool hasChanges = false.obs;

  // Original values to detect changes
  String _originalFirstName = '';
  String _originalLastName = '';
  String _originalEmail = '';
  String _originalPhone = '';
  String _originalCountry = '';
  String _originalCity = '';
  String _originalPhotoUrl = '';

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
    _loadUserProfile();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    countryController.dispose();
    cityController.dispose();
    super.onClose();
  }

  /// Setup listeners to detect changes
  void _setupListeners() {
    firstNameController.addListener(_checkChanges);
    lastNameController.addListener(_checkChanges);
    emailController.addListener(_checkChanges);
    phoneController.addListener(_checkChanges);
    countryController.addListener(_checkChanges);
    cityController.addListener(_checkChanges);
    photoUrl.listen((_) => _checkChanges());
  }

  void _checkChanges() {
    final hasChangesValue = 
        firstNameController.text != _originalFirstName ||
        lastNameController.text != _originalLastName ||
        emailController.text != _originalEmail ||
        phoneController.text != _originalPhone ||
        countryController.text != _originalCountry ||
        cityController.text != _originalCity ||
        photoUrl.value != _originalPhotoUrl;
    
    hasChanges.value = hasChangesValue;
  }

  /// Load user profile from Firestore
  Future<void> _loadUserProfile() async {
    try {
      isLoading.value = true;
      
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        isGuest.value = true;
        isLoading.value = false;
        return;
      }

      final UserModel? userModel = await FireStoreUtils.getUserProfile(user.uid);
      if (userModel != null) {
        // Load data
        final fullName = userModel.fullName ?? '';
        final nameParts = fullName.split(' ');
        firstNameController.text = nameParts.isNotEmpty ? nameParts[0] : '';
        lastNameController.text = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        
        emailController.text = userModel.email ?? '';
        phoneController.text = userModel.phoneNumber ?? '';
        
        // Extract country code if available
        if (userModel.countryCode != null && userModel.countryCode!.isNotEmpty) {
          selectedCountryCode.value = userModel.countryCode!;
        }
        
        photoUrl.value = userModel.profilePic ?? '';
        
        // Load country and city from Firestore (if stored separately)
        try {
          final firestore = FirebaseFirestore.instance;
          final doc = await firestore.collection('users').doc(user.uid).get();
          if (doc.exists) {
            final data = doc.data();
            countryController.text = data?['country'] ?? '';
            cityController.text = data?['city'] ?? '';
          }
        } catch (e) {
          // Non-critical, continue
        }

        // Store original values
        _originalFirstName = firstNameController.text;
        _originalLastName = lastNameController.text;
        _originalEmail = emailController.text;
        _originalPhone = phoneController.text;
        _originalCountry = countryController.text;
        _originalCity = cityController.text;
        _originalPhotoUrl = photoUrl.value;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      hasChanges.value = false;
    }
  }

  /// Pick and upload avatar image
  Future<void> pickAndUploadAvatar() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image == null) return;

      isUploadingPhoto.value = true;

      // Upload to Firebase Storage
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(user.uid)
          .child('profile_pic.jpg');

      final uploadTask = storageRef.putFile(File(image.path));
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      photoUrl.value = downloadUrl;
      hasChanges.value = true;

      Get.snackbar(
        'Success',
        'Photo uploaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload photo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  /// Detect location using GPS
  Future<void> detectLocation() async {
    try {
      isDetectingLocation.value = true;

      // Check location permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocode to get address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        countryController.text = place.country ?? '';
        cityController.text = place.locality ?? place.subAdministrativeArea ?? '';
        hasChanges.value = true;

        Get.snackbar(
          'Success',
          'Location detected successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Location Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isDetectingLocation.value = false;
    }
  }

  /// Validate form fields
  String? _validateForm() {
    if (firstNameController.text.trim().isEmpty) {
      return 'First name is required';
    }
    if (lastNameController.text.trim().isEmpty) {
      return 'Last name is required';
    }
    
    final email = emailController.text.trim();
    if (email.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        return 'Please enter a valid email address';
      }
    }

    final phone = phoneController.text.trim();
    if (phone.isNotEmpty) {
      // Basic phone validation (digits only, at least 8 digits)
      final phoneRegex = RegExp(r'^\d{8,15}$');
      if (!phoneRegex.hasMatch(phone)) {
        return 'Please enter a valid phone number';
      }
    }

    return null;
  }

  /// Update profile in Firestore
  Future<void> updateProfile() async {
    try {
      // Validate
      final validationError = _validateForm();
      if (validationError != null) {
        Get.snackbar(
          'Validation Error',
          validationError,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      if (!hasChanges.value) {
        Get.snackbar(
          'No Changes',
          'No changes to save',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey,
          colorText: Colors.white,
        );
        return;
      }

      isSaving.value = true;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Get existing user model
      UserModel? userModel = await FireStoreUtils.getUserProfile(user.uid);
      if (userModel == null) {
        // Create new user model
        userModel = UserModel(
          id: user.uid,
          fullName: '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
          email: emailController.text.trim(),
          phoneNumber: phoneController.text.trim(),
          countryCode: selectedCountryCode.value,
          profilePic: photoUrl.value,
        );
      } else {
        // Update existing model
        userModel.fullName = '${firstNameController.text.trim()} ${lastNameController.text.trim()}';
        userModel.email = emailController.text.trim().isNotEmpty ? emailController.text.trim() : null;
        userModel.phoneNumber = phoneController.text.trim();
        userModel.countryCode = selectedCountryCode.value;
        if (photoUrl.value.isNotEmpty) {
          userModel.profilePic = photoUrl.value;
        }
      }

      // Save to Firestore
      await FireStoreUtils.updateUser(userModel);

      // Save country and city separately (if not in UserModel)
      try {
        final firestore = FirebaseFirestore.instance;
        await firestore.collection('users').doc(user.uid).update({
          'country': countryController.text.trim(),
          'city': cityController.text.trim(),
        });
      } catch (e) {
        // Non-critical, continue
      }

      // Update original values
      _originalFirstName = firstNameController.text;
      _originalLastName = lastNameController.text;
      _originalEmail = emailController.text;
      _originalPhone = phoneController.text;
      _originalCountry = countryController.text;
      _originalCity = cityController.text;
      _originalPhotoUrl = photoUrl.value;
      hasChanges.value = false;

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate back
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }
}

