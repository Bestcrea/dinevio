import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:customer/app/modules/personal_info/controllers/personal_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalInfoView extends GetView<PersonalInfoController> {
  const PersonalInfoView({super.key});

  static const Color _primaryPurple = Color(0xFF7E57C2);
  static const Color _darkText = Color(0xFF1A1A1A);
  static const Color _greyText = Color(0xFF757575);
  static const Color _lightGrey = Color(0xFFF5F5F5);
  static const Color _lightGrey2 = Color(0xFFF7F7F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _darkText),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Profile settings',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _darkText,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.shade200.withOpacity(0.5),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.isGuest.value) {
          return _buildGuestView();
        }

        return _buildFormView();
      }),
    );
  }

  Widget _buildGuestView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 80,
              color: _greyText.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Sign in to edit profile',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Please sign in to access and edit your profile information.',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _greyText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Sign in',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Avatar section
                _buildAvatarSection(),
                const SizedBox(height: 32),
                // Form fields
                _buildFormField(
                  label: 'First name',
                  controller: controller.firstNameController,
                  required: true,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  label: 'Last name',
                  controller: controller.lastNameController,
                  required: true,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  label: 'Email',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildPhoneField(),
                const SizedBox(height: 16),
                _buildLocationField(
                  label: 'Country',
                  fieldController: controller.countryController,
                  onDetectLocation: () => controller.detectLocation(),
                  isDetecting: controller.isDetectingLocation.value,
                ),
                const SizedBox(height: 16),
                _buildLocationField(
                  label: 'City',
                  fieldController: controller.cityController,
                  onDetectLocation: () => controller.detectLocation(),
                  isDetecting: controller.isDetectingLocation.value,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        // Save button
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildAvatarSection() {
    return Obx(() {
      return Stack(
        alignment: Alignment.center,
        children: [
          // Avatar circle
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _lightGrey,
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: controller.photoUrl.value.isNotEmpty
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: controller.photoUrl.value,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => _buildAvatarPlaceholder(),
                    ),
                  )
                : _buildAvatarPlaceholder(),
          ),
          // Floating action button
          Positioned(
            bottom: 0,
            right: 0,
            child: _buildAvatarActionButton(),
          ),
        ],
      );
    });
  }

  Widget _buildAvatarPlaceholder() {
    final firstName = controller.firstNameController.text;
    final lastName = controller.lastNameController.text;
    final initial = firstName.isNotEmpty
        ? firstName[0].toUpperCase()
        : lastName.isNotEmpty
            ? lastName[0].toUpperCase()
            : 'U';

    return Center(
      child: Text(
        initial,
        style: GoogleFonts.inter(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: _primaryPurple,
        ),
      ),
    );
  }

  Widget _buildAvatarActionButton() {
    return Obx(() {
      return GestureDetector(
        onTap: controller.isUploadingPhoto.value
            ? null
            : () {
                HapticFeedback.lightImpact();
                controller.pickAndUploadAvatar();
              },
        child: AnimatedScale(
          scale: controller.isUploadingPhoto.value ? 0.9 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _primaryPurple,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: controller.isUploadingPhoto.value
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
          ),
        ),
      );
    });
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    bool required = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _lightGrey2,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label + (required ? ' *' : ''),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _greyText,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: _darkText,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _lightGrey2,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phone number',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _greyText,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Obx(() {
                return CountryCodePicker(
                  onChanged: (country) {
                    controller.selectedCountryCode.value = country.dialCode ?? '+212';
                  },
                  initialSelection: controller.selectedCountryCode.value.replaceAll('+', ''),
                  favorite: ['+212', 'MA'],
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                  textStyle: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: _darkText,
                  ),
                );
              }),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: _darkText,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Enter phone number',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField({
    required String label,
    required TextEditingController fieldController,
    required VoidCallback onDetectLocation,
    required bool isDetecting,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _lightGrey2,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _greyText,
                  ),
                ),
              ),
              TextButton(
                onPressed: isDetecting ? null : onDetectLocation,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: isDetecting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Use my location',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _primaryPurple,
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: fieldController,
                  readOnly: true,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: _darkText,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Tap to select',
                  ),
                  onTap: () {
                    // Allow manual input as fallback
                    _showLocationInputDialog(label, fieldController);
                  },
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: _greyText,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLocationInputDialog(String label, TextEditingController fieldController) {
    final textController = TextEditingController(text: fieldController.text);
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter $label',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _darkText,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter $label',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        color: _greyText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      fieldController.text = textController.text;
                      // Change will be detected automatically via listener
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Obx(() {
      final isDisabled = !controller.hasChanges.value ||
          controller.isSaving.value ||
          controller.isUploadingPhoto.value;

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
          top: false,
          child: SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: isDisabled
                  ? null
                  : () {
                      HapticFeedback.lightImpact();
                      controller.updateProfile();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryPurple,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: controller.isSaving.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Save',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      );
    });
  }
}

