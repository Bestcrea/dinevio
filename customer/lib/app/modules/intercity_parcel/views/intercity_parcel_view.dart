// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:customer/theme/app_them_data.dart';
import '../controllers/intercity_parcel_controller.dart';

class IntercityParcelView extends GetView<IntercityParcelController> {
  const IntercityParcelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemData.grey50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form Card - Pickup & Dropoff
                    _buildFormCard(context),
                    const SizedBox(height: 16),
                    
                    // Parcel Details Card
                    _buildParcelDetailsCard(context),
                    const SizedBox(height: 16),
                    
                    // Scheduling & Pricing Card
                    _buildSchedulingCard(context),
                    const SizedBox(height: 100), // Space for bottom CTA
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Bottom CTA
      bottomNavigationBar: _buildBottomCTA(context),
    );
  }

  /// Header with gradient background
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppThemData.primary500,
            AppThemData.primary400,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Send a Parcel',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'City-to-city delivery',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.white),
              onPressed: () {
                Get.snackbar(
                  'Help',
                  'Fill in the form to send a parcel between cities',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Form Card with Pickup & Dropoff sections
  Widget _buildFormCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step A: Pickup
            _buildSectionTitle('Step A: Pickup', Icons.location_on_outlined),
            const SizedBox(height: 12),
            CitySelector(
              label: 'Pickup City',
              controller: controller.pickupCityController,
              selectedCity: controller.selectedPickupCity,
              cities: controller.cities,
              isLoading: controller.isLoadingCities.value,
              error: controller.pickupCityError.value,
              onCitySelected: (city) => controller.setPickupCity(city),
              onRetry: () => controller.fetchCities(),
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: controller.pickupAddressController,
              label: 'Pickup Point / Address (Optional)',
              icon: Icons.place_outlined,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: controller.pickupPhoneController,
              label: 'Contact Phone (Optional)',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            
            const SizedBox(height: 24),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 24),
            
            // Step B: Dropoff
            _buildSectionTitle('Step B: Dropoff', Icons.location_on),
            const SizedBox(height: 12),
            CitySelector(
              label: 'Dropoff City',
              controller: controller.dropoffCityController,
              selectedCity: controller.selectedDropoffCity,
              cities: controller.cities,
              isLoading: controller.isLoadingCities.value,
              error: controller.dropoffCityError.value,
              onCitySelected: (city) => controller.setDropoffCity(city),
              onRetry: () => controller.fetchCities(),
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: controller.dropoffAddressController,
              label: 'Dropoff Point / Address (Optional)',
              icon: Icons.place_outlined,
            ),
            const SizedBox(height: 12),
            Obx(() => _buildTextField(
              controller: controller.dropoffPhoneController,
              label: 'Receiver Phone',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              errorText: controller.dropoffPhoneError.value.isNotEmpty
                  ? controller.dropoffPhoneError.value
                  : null,
            )),
          ],
        ),
      ),
    );
  }

  /// Parcel Details Card
  Widget _buildParcelDetailsCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Parcel Details', Icons.inventory_2_outlined),
            const SizedBox(height: 16),
            
            // Parcel Type
            Text(
              'Parcel Type',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            ParcelTypeChips(
              selectedType: controller.selectedParcelType,
              onTypeSelected: (type) => controller.setParcelType(type),
            ),
            
            const SizedBox(height: 20),
            
            // Weight Selector
            Text(
              'Weight (kg)',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => WeightSelector(
              weight: controller.selectedWeight.value,
              onWeightChanged: (weight) => controller.setWeight(weight),
              errorText: controller.weightError.value.isNotEmpty
                  ? controller.weightError.value
                  : null,
            )),
            
            const SizedBox(height: 20),
            
            // Dimensions (Optional)
            Text(
              'Dimensions (Optional)',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: controller.lengthController,
                    label: 'Length (cm)',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: controller.widthController,
                    label: 'Width (cm)',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: controller.heightController,
                    label: 'Height (cm)',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Notes
            _buildTextField(
              controller: controller.notesController,
              label: 'Notes (Optional)',
              icon: Icons.note_outlined,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  /// Scheduling & Pricing Card
  Widget _buildSchedulingCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Delivery Time', Icons.schedule_outlined),
            const SizedBox(height: 12),
            
            // Now or Schedule toggle
            Obx(() => Row(
              children: [
                Expanded(
                  child: _buildToggleButton(
                    label: 'Now',
                    isSelected: !controller.isScheduled.value,
                    onTap: () => controller.toggleSchedule(false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildToggleButton(
                    label: 'Schedule',
                    isSelected: controller.isScheduled.value,
                    onTap: () => controller.toggleSchedule(true),
                  ),
                ),
              ],
            )),
            
            // Date/Time picker if scheduled
            Obx(() {
              if (controller.isScheduled.value) {
                return Column(
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDatePickerButton(context),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTimePickerButton(context),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
            
            const SizedBox(height: 24),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 16),
            
            // Estimate Card
            Text(
              'Price Estimate',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => PriceEstimateCard(
              isLoading: controller.isLoadingEstimate.value,
              estimate: controller.estimate.value,
              onGetEstimate: () => controller.getEstimate(),
            )),
          ],
        ),
      ),
    );
  }

  /// Bottom CTA
  Widget _buildBottomCTA(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(() {
          final isValid = controller.isFormValid();
          return SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isValid ? () => controller.navigateToConfirmation() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isValid ? AppThemData.primary500 : Colors.grey.shade300,
                foregroundColor: isValid ? Colors.white : Colors.grey.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Continue',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Helper widgets
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppThemData.primary500),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, size: 20) : null,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppThemData.primary500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppThemData.error07, width: 1),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppThemData.primary500 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppThemData.primary500 : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerButton(BuildContext context) {
    return Obx(() {
      final date = controller.scheduledDate.value;
      return InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 30)),
          );
          if (picked != null) {
            controller.setScheduledDate(picked);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  date != null
                      ? DateFormat('MMM dd, yyyy').format(date)
                      : 'Select Date',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: date != null ? Colors.black87 : Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTimePickerButton(BuildContext context) {
    return Obx(() {
      final time = controller.scheduledTime.value;
      return InkWell(
        onTap: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: time ?? TimeOfDay.now(),
          );
          if (picked != null) {
            controller.setScheduledTime(picked);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.access_time, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  time != null
                      ? time.format(context)
                      : 'Select Time',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: time != null ? Colors.black87 : Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

/// City Selector Widget (Searchable Dropdown)
class CitySelector extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Rx<CityModel?> selectedCity;
  final RxList<CityModel> cities;
  final bool isLoading;
  final String error;
  final Function(CityModel?) onCitySelected;
  final VoidCallback onRetry;

  const CitySelector({
    super.key,
    required this.label,
    required this.controller,
    required this.selectedCity,
    required this.cities,
    required this.isLoading,
    required this.error,
    required this.onCitySelected,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Loading state
      if (isLoading) {
        return _buildSkeleton();
      }

      // Error state
      if (error.isNotEmpty) {
        return _buildErrorState();
      }

      // Empty state
      if (cities.isEmpty) {
        return _buildEmptyState();
      }

      // Normal state with searchable dropdown
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            readOnly: true,
            onTap: () => _showCityPicker(context),
            style: GoogleFonts.inter(fontSize: 14),
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: const Icon(Icons.location_city_outlined, size: 20),
              suffixIcon: const Icon(Icons.arrow_drop_down, size: 24),
              errorText: error.isNotEmpty ? error : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppThemData.primary500, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppThemData.error07, width: 1),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      );
    });
  }

  void _showCityPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CityPickerSheet(
        cities: cities,
        selectedCity: selectedCity.value,
        onCitySelected: (city) {
          onCitySelected(city);
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildSkeleton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppThemData.primary500),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppThemData.error02,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppThemData.error07),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: AppThemData.error07, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  error,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppThemData.error07,
                  ),
                ),
              ),
              TextButton(
                onPressed: onRetry,
                child: Text(
                  'Retry',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppThemData.error07,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(Icons.location_off, size: 32, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            'No cities available',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppThemData.primary500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// City Picker Bottom Sheet
class _CityPickerSheet extends StatefulWidget {
  final RxList<CityModel> cities;
  final CityModel? selectedCity;
  final Function(CityModel) onCitySelected;

  const _CityPickerSheet({
    required this.cities,
    this.selectedCity,
    required this.onCitySelected,
  });

  @override
  State<_CityPickerSheet> createState() => _CityPickerSheetState();
}

class _CityPickerSheetState extends State<_CityPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<CityModel> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _filteredCities = widget.cities.toList();
    _searchController.addListener(_filterCities);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCities() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCities = widget.cities.toList();
      } else {
        _filteredCities = widget.cities
            .where((city) => city.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Search field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search cities...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Cities list
          Expanded(
            child: _filteredCities.isEmpty
                ? Center(
                    child: Text(
                      'No cities found',
                      style: GoogleFonts.inter(color: Colors.grey.shade600),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredCities.length,
                    itemBuilder: (context, index) {
                      final city = _filteredCities[index];
                      final isSelected = widget.selectedCity?.id == city.id;
                      
                      return ListTile(
                        title: Text(
                          city.name,
                          style: GoogleFonts.inter(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                        subtitle: city.code != null
                            ? Text(
                                city.code!,
                                style: GoogleFonts.inter(fontSize: 12),
                              )
                            : null,
                        trailing: isSelected
                            ? Icon(Icons.check_circle, color: AppThemData.primary500)
                            : null,
                        onTap: () => widget.onCitySelected(city),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Parcel Type Chips
class ParcelTypeChips extends StatelessWidget {
  final Rx<ParcelType> selectedType;
  final Function(ParcelType) onTypeSelected;

  const ParcelTypeChips({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final types = [
        (ParcelType.document, 'Document', Icons.description_outlined),
        (ParcelType.box, 'Box', Icons.inventory_2_outlined),
        (ParcelType.fragile, 'Fragile', Icons.warning_amber_outlined),
        (ParcelType.other, 'Other', Icons.category_outlined),
      ];

      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: types.map((type) {
          final isSelected = selectedType.value == type.$1;
          return InkWell(
            onTap: () => onTypeSelected(type.$1),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppThemData.primary500 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppThemData.primary500 : Colors.grey.shade300,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    type.$3,
                    size: 18,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    type.$2,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

/// Weight Selector with Slider and Quick Chips
class WeightSelector extends StatelessWidget {
  final double weight;
  final Function(double) onWeightChanged;
  final String? errorText;

  const WeightSelector({
    super.key,
    required this.weight,
    required this.onWeightChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [1.0, 3.0, 5.0, 10.0].map((quickWeight) {
            final isSelected = (weight - quickWeight).abs() < 0.1;
            return InkWell(
              onTap: () => onWeightChanged(quickWeight),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? AppThemData.primary500 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppThemData.primary500 : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  '${quickWeight.toStringAsFixed(0)}kg',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 12),
        
        // Slider
        Row(
          children: [
            Text(
              '0.1 kg',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            Expanded(
              child: Slider(
                value: weight,
                min: 0.1,
                max: 20.0,
                divisions: 199,
                label: '${weight.toStringAsFixed(1)} kg',
                onChanged: onWeightChanged,
                activeColor: AppThemData.primary500,
              ),
            ),
            Text(
              '20 kg',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        
        // Weight display
        Center(
          child: Text(
            '${weight.toStringAsFixed(1)} kg',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppThemData.primary500,
            ),
          ),
        ),
        
        // Error text
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText!,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppThemData.error07,
              ),
            ),
          ),
      ],
    );
  }
}

/// Price Estimate Card
class PriceEstimateCard extends StatelessWidget {
  final bool isLoading;
  final EstimateModel? estimate;
  final VoidCallback onGetEstimate;

  const PriceEstimateCard({
    super.key,
    required this.isLoading,
    this.estimate,
    required this.onGetEstimate,
  });

  @override
  Widget build(BuildContext context) {
    // Loading skeleton
    if (isLoading) {
      return _buildSkeleton();
    }

    // Empty state (no estimate available)
    if (estimate == null || estimate!.isEmpty) {
      return _buildEmptyState();
    }

    // Success state with estimate
    return _buildEstimateDisplay(estimate!);
  }

  Widget _buildSkeleton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Spacer(),
              Container(
                width: 40,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline, size: 32, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            'Estimate not available',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Please check your selections and try again',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onGetEstimate,
            child: Text(
              'Get Estimate',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppThemData.primary500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstimateDisplay(EstimateModel estimate) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemData.primary50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppThemData.primary200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price Range',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (estimate.minPrice != null && estimate.maxPrice != null)
                Text(
                  '${estimate.minPrice!.toStringAsFixed(0)} - ${estimate.maxPrice!.toStringAsFixed(0)} MAD',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppThemData.primary500,
                  ),
                ),
            ],
          ),
          if (estimate.distance != null || estimate.eta != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (estimate.distance != null) ...[
                  Icon(Icons.straighten, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${estimate.distance!.toStringAsFixed(1)} km',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
                if (estimate.distance != null && estimate.eta != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('•', style: TextStyle(color: Colors.grey.shade400)),
                  ),
                if (estimate.eta != null) ...[
                  Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${estimate.eta} min',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

