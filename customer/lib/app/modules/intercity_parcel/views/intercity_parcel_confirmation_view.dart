// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:customer/theme/app_them_data.dart';
import '../controllers/intercity_parcel_controller.dart';

class IntercityParcelConfirmationView extends GetView<IntercityParcelController> {
  const IntercityParcelConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemData.grey50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Confirm Order',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Card
              _buildSummaryCard(context),
              const SizedBox(height: 16),
              
              // Payment Method Card
              _buildPaymentMethodCard(context),
              const SizedBox(height: 16),
              
              // Total Card
              Obx(() => _buildTotalCard(context)),
              const SizedBox(height: 100), // Space for bottom button
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildPlaceOrderButton(context),
    );
  }

  /// Summary Card with editable sections
  Widget _buildSummaryCard(BuildContext context) {
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
            Text(
              'Order Summary',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            // Pickup Section
            _buildEditableSection(
              title: 'Pickup',
              icon: Icons.location_on_outlined,
              content: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.selectedPickupCity.value?.name ?? 'Not selected',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (controller.pickupAddressController.text.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        controller.pickupAddressController.text,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    if (controller.pickupPhoneController.text.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        controller.pickupPhoneController.text,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                );
              }),
              onEdit: () => Get.back(), // Go back to edit
            ),
            
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 16),
            
            // Dropoff Section
            _buildEditableSection(
              title: 'Dropoff',
              icon: Icons.location_on,
              content: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.selectedDropoffCity.value?.name ?? 'Not selected',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (controller.dropoffAddressController.text.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        controller.dropoffAddressController.text,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    if (controller.dropoffPhoneController.text.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        controller.dropoffPhoneController.text,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                );
              }),
              onEdit: () => Get.back(), // Go back to edit
            ),
            
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 16),
            
            // Parcel Details
            Obx(() => _buildInfoRow(
              label: 'Parcel Type',
              value: _getParcelTypeName(controller.selectedParcelType.value),
            )),
            const SizedBox(height: 8),
            Obx(() => _buildInfoRow(
              label: 'Weight',
              value: '${controller.selectedWeight.value.toStringAsFixed(1)} kg',
            )),
            if (controller.lengthController.text.isNotEmpty ||
                controller.widthController.text.isNotEmpty ||
                controller.heightController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                label: 'Dimensions',
                value: '${controller.lengthController.text} × ${controller.widthController.text} × ${controller.heightController.text} cm',
              ),
            ],
            if (controller.notesController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                label: 'Notes',
                value: controller.notesController.text,
              ),
            ],
            
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 16),
            
            // Delivery Time
            Obx(() {
              if (controller.isScheduled.value &&
                  controller.scheduledDate.value != null &&
                  controller.scheduledTime.value != null) {
                final date = controller.scheduledDate.value!;
                final time = controller.scheduledTime.value!;
                return _buildInfoRow(
                  label: 'Scheduled Delivery',
                  value: '${DateFormat('MMM dd, yyyy').format(date)} at ${time.format(context)}',
                );
              } else {
                return _buildInfoRow(
                  label: 'Delivery Time',
                  value: 'Now',
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  /// Payment Method Card
  Widget _buildPaymentMethodCard(BuildContext context) {
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
            Text(
              'Payment Method',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final methods = ['Cash', 'Card', 'Wallet'];
              return Column(
                children: methods.map((method) {
                  final isSelected = controller.selectedPaymentMethod.value == method;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () => controller.setPaymentMethod(method),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppThemData.primary50 : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppThemData.primary500 : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                              color: isSelected ? AppThemData.primary500 : Colors.grey.shade400,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              method,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Total Card
  Widget _buildTotalCard(BuildContext context) {
    final estimate = controller.estimate.value;
    
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
            Text(
              'Total',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            if (estimate != null && !estimate.isEmpty && estimate.minPrice != null && estimate.maxPrice != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Estimated Price',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    '${estimate.minPrice!.toStringAsFixed(0)} - ${estimate.maxPrice!.toStringAsFixed(0)} MAD',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppThemData.primary500,
                    ),
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price will be calculated',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Icon(Icons.info_outline, size: 18, color: Colors.grey.shade400),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// Place Order Button
  Widget _buildPlaceOrderButton(BuildContext context) {
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
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => controller.placeOrder(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppThemData.primary500,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Place Order',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Helper widgets
  Widget _buildEditableSection({
    required String title,
    required IconData icon,
    required Widget content,
    required VoidCallback onEdit,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppThemData.primary500),
        const SizedBox(width: 12),
        Expanded(child: content),
        TextButton(
          onPressed: onEdit,
          child: Text(
            'Edit',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppThemData.primary500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  String _getParcelTypeName(ParcelType type) {
    switch (type) {
      case ParcelType.document:
        return 'Document';
      case ParcelType.box:
        return 'Box';
      case ParcelType.fragile:
        return 'Fragile';
      case ParcelType.other:
        return 'Other';
    }
  }
}

