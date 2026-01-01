// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

/// City model for dropdown
class CityModel {
  final String id;
  final String name;
  final String? code;

  CityModel({required this.id, required this.name, this.code});

  @override
  String toString() => name;
}

/// Parcel type enum
enum ParcelType {
  document,
  box,
  fragile,
  other,
}

/// Estimate model
class EstimateModel {
  final double? minPrice;
  final double? maxPrice;
  final double? distance; // in km
  final int? eta; // in minutes

  EstimateModel({
    this.minPrice,
    this.maxPrice,
    this.distance,
    this.eta,
  });

  bool get isEmpty => minPrice == null && maxPrice == null && distance == null && eta == null;
}

/// Controller for Intercity Parcel feature
class IntercityParcelController extends GetxController {
  // Form fields
  final TextEditingController pickupCityController = TextEditingController();
  final TextEditingController pickupAddressController = TextEditingController();
  final TextEditingController pickupPhoneController = TextEditingController();
  final TextEditingController dropoffCityController = TextEditingController();
  final TextEditingController dropoffAddressController = TextEditingController();
  final TextEditingController dropoffPhoneController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // Selected values
  Rx<CityModel?> selectedPickupCity = Rx<CityModel?>(null);
  Rx<CityModel?> selectedDropoffCity = Rx<CityModel?>(null);
  Rx<ParcelType> selectedParcelType = ParcelType.box.obs;
  RxDouble selectedWeight = 1.0.obs;
  RxBool isScheduled = false.obs;
  Rx<DateTime?> scheduledDate = Rx<DateTime?>(null);
  Rx<TimeOfDay?> scheduledTime = Rx<TimeOfDay?>(null);
  RxString selectedPaymentMethod = 'Cash'.obs;

  // State management
  RxList<CityModel> cities = <CityModel>[].obs;
  RxBool isLoadingCities = true.obs;
  RxString citiesError = ''.obs;
  RxBool isLoadingEstimate = false.obs;
  Rx<EstimateModel?> estimate = Rx<EstimateModel?>(null);

  // Validation errors
  RxString pickupCityError = ''.obs;
  RxString dropoffCityError = ''.obs;
  RxString weightError = ''.obs;
  RxString dropoffPhoneError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCities();
  }

  @override
  void onClose() {
    pickupCityController.dispose();
    pickupAddressController.dispose();
    pickupPhoneController.dispose();
    dropoffCityController.dispose();
    dropoffAddressController.dispose();
    dropoffPhoneController.dispose();
    weightController.dispose();
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    notesController.dispose();
    super.onClose();
  }

  /// Fetch cities list (mock API)
  Future<void> fetchCities() async {
    try {
      isLoadingCities.value = true;
      citiesError.value = '';
      
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock cities data
      final mockCities = [
        CityModel(id: '1', name: 'Casablanca', code: 'CASA'),
        CityModel(id: '2', name: 'Rabat', code: 'RAB'),
        CityModel(id: '3', name: 'Marrakech', code: 'MAR'),
        CityModel(id: '4', name: 'Fes', code: 'FES'),
        CityModel(id: '5', name: 'Tangier', code: 'TNG'),
        CityModel(id: '6', name: 'Agadir', code: 'AGA'),
        CityModel(id: '7', name: 'Meknes', code: 'MEK'),
        CityModel(id: '8', name: 'Oujda', code: 'OUJ'),
        CityModel(id: '9', name: 'Kenitra', code: 'KEN'),
        CityModel(id: '10', name: 'Tetouan', code: 'TET'),
      ];
      
      // Defensive check: ensure list is not empty before assignment
      if (mockCities.isNotEmpty) {
        cities.value = mockCities;
      } else {
        citiesError.value = 'No cities available';
      }
    } catch (e) {
      citiesError.value = 'Failed to load cities. Please try again.';
      cities.value = []; // Ensure empty list on error
    } finally {
      isLoadingCities.value = false;
    }
  }

  /// Get estimate (mock API)
  Future<void> getEstimate() async {
    // Validate required fields first
    if (!isFormValid()) {
      return;
    }

    try {
      isLoadingEstimate.value = true;
      estimate.value = null;

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 1200));

      final pickupCity = selectedPickupCity.value;
      final dropoffCity = selectedDropoffCity.value;
      final weight = selectedWeight.value;

      // Defensive check: ensure cities are selected
      if (pickupCity == null || dropoffCity == null) {
        estimate.value = null;
        return;
      }

      // Mock estimate calculation
      // Simulate empty response 10% of the time
      if (Random().nextDouble() < 0.1) {
        estimate.value = null; // Empty state
        return;
      }

      // Calculate mock distance (random between 50-500 km)
      final distance = 50.0 + Random().nextDouble() * 450.0;
      
      // Calculate mock price based on distance and weight
      final basePrice = distance * 2.5; // 2.5 MAD per km
      final weightMultiplier = 1.0 + (weight - 1.0) * 0.3; // +30% per extra kg
      final calculatedPrice = basePrice * weightMultiplier;
      
      final minPrice = calculatedPrice * 0.9;
      final maxPrice = calculatedPrice * 1.1;
      
      // ETA: 1 hour per 100km + base 30 min
      final eta = (distance / 100 * 60).round() + 30;

      estimate.value = EstimateModel(
        minPrice: minPrice,
        maxPrice: maxPrice,
        distance: distance,
        eta: eta,
      );
    } catch (e) {
      estimate.value = null; // Show empty state on error
    } finally {
      isLoadingEstimate.value = false;
    }
  }

  /// Validate form
  bool isFormValid() {
    bool isValid = true;

    // Reset errors
    pickupCityError.value = '';
    dropoffCityError.value = '';
    weightError.value = '';
    dropoffPhoneError.value = '';

    // Validate pickup city
    if (selectedPickupCity.value == null) {
      pickupCityError.value = 'Please select pickup city';
      isValid = false;
    }

    // Validate dropoff city
    if (selectedDropoffCity.value == null) {
      dropoffCityError.value = 'Please select dropoff city';
      isValid = false;
    }

    // Validate same city
    if (selectedPickupCity.value != null &&
        selectedDropoffCity.value != null &&
        selectedPickupCity.value!.id == selectedDropoffCity.value!.id) {
      dropoffCityError.value = 'Dropoff city must be different from pickup';
      isValid = false;
    }

    // Validate weight
    if (selectedWeight.value < 0.1 || selectedWeight.value > 20.0) {
      weightError.value = 'Weight must be between 0.1 and 20 kg';
      isValid = false;
    }

    // Validate dropoff phone (required)
    if (dropoffPhoneController.text.trim().isEmpty) {
      dropoffPhoneError.value = 'Receiver phone is required';
      isValid = false;
    } else if (!_isValidPhone(dropoffPhoneController.text.trim())) {
      dropoffPhoneError.value = 'Please enter a valid phone number';
      isValid = false;
    }

    return isValid;
  }

  /// Simple phone validation
  bool _isValidPhone(String phone) {
    // Basic validation: 9-15 digits, may start with +
    final phoneRegex = RegExp(r'^\+?[0-9]{9,15}$');
    return phoneRegex.hasMatch(phone.replaceAll(' ', '').replaceAll('-', ''));
  }

  /// Set pickup city
  void setPickupCity(CityModel? city) {
    selectedPickupCity.value = city;
    pickupCityController.text = city?.name ?? '';
    pickupCityError.value = '';
    
    // Clear estimate if cities change
    if (estimate.value != null) {
      estimate.value = null;
    }
  }

  /// Set dropoff city
  void setDropoffCity(CityModel? city) {
    selectedDropoffCity.value = city;
    dropoffCityController.text = city?.name ?? '';
    dropoffCityError.value = '';
    
    // Clear estimate if cities change
    if (estimate.value != null) {
      estimate.value = null;
    }
  }

  /// Set parcel type
  void setParcelType(ParcelType type) {
    selectedParcelType.value = type;
  }

  /// Set weight
  void setWeight(double weight) {
    selectedWeight.value = weight.clamp(0.1, 20.0);
    weightController.text = selectedWeight.value.toStringAsFixed(1);
    weightError.value = '';
    
    // Clear estimate if weight changes
    if (estimate.value != null) {
      estimate.value = null;
    }
  }

  /// Toggle schedule
  void toggleSchedule(bool value) {
    isScheduled.value = value;
    if (!value) {
      scheduledDate.value = null;
      scheduledTime.value = null;
    }
  }

  /// Set scheduled date
  void setScheduledDate(DateTime date) {
    scheduledDate.value = date;
  }

  /// Set scheduled time
  void setScheduledTime(TimeOfDay time) {
    scheduledTime.value = time;
  }

  /// Set payment method
  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  /// Navigate to confirmation page
  void navigateToConfirmation() {
    if (isFormValid()) {
      Get.toNamed('/intercity-parcel-confirmation');
    }
  }

  /// Place order (final step)
  void placeOrder() {
    // Here you would call the actual API
    Get.snackbar(
      'Order Placed',
      'Your parcel order has been placed successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
    
    // Navigate back to home or order tracking
    Get.until((route) => route.isFirst);
  }
}

