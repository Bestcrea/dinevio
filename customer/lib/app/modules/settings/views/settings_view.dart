import 'package:customer/app/modules/legal/views/licenses_view.dart';
import 'package:customer/app/modules/legal/views/privacy_policy_view.dart';
import 'package:customer/app/modules/legal/views/terms_and_conditions_view.dart';
import 'package:customer/app/modules/settings/controllers/settings_controller.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    
    return Scaffold(
      backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Phone number
          _buildSection(
            context: context,
            title: '',
            items: [
              _buildPhoneNumberItem(context: context),
            ],
          ),
          const SizedBox(height: 24),
          // Language
          _buildSection(
            context: context,
            title: 'Language',
            items: [
              Obx(() => _buildSelectableItem(
                    context: context,
                    label: _getCurrentLanguageDisplay(),
                    value: controller.selectedLanguage.value,
                    selectedValue: controller.selectedLanguage.value,
                    onTap: () => _showLanguageOptions(context),
                  )),
            ],
          ),
          const SizedBox(height: 24),
          // Distances
          _buildSection(
            context: context,
            title: 'DISTANCES',
            items: [
              _buildSelectableItem(
                context: context,
                label: 'Kilometres',
                value: 'kilometres',
                selectedValue: controller.selectedDistanceUnit.value,
                onTap: () => _showDistanceOptions(context),
              ),
              _buildSelectableItem(
                context: context,
                label: 'Miles',
                value: 'miles',
                selectedValue: controller.selectedDistanceUnit.value,
                onTap: () => _showDistanceOptions(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Dark mode
          _buildSection(
            context: context,
            title: 'Dark mode',
            items: [
              _buildSelectableItem(
                context: context,
                label: 'Off',
                value: 'off',
                selectedValue: controller.selectedDarkMode.value,
                onTap: () => _showDarkModeOptions(context),
              ),
              _buildSelectableItem(
                context: context,
                label: 'Always enabled',
                value: 'always',
                selectedValue: controller.selectedDarkMode.value,
                onTap: () => _showDarkModeOptions(context),
              ),
              _buildSelectableItem(
                context: context,
                label: 'System',
                value: 'system',
                selectedValue: controller.selectedDarkMode.value,
                onTap: () => _showDarkModeOptions(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Navigation
          _buildSection(
            context: context,
            title: 'Navigation',
            items: [
              _buildInfoBox(
                context: context,
                text: 'Select an app to guide you along the route. For drivers and couriers only',
              ),
              const SizedBox(height: 12),
              _buildSelectableItem(
                context: context,
                label: 'Apple Maps',
                value: 'apple_maps',
                selectedValue: controller.selectedNavigation.value,
                icon: Icons.apple,
                onTap: () => _showNavigationOptions(context),
              ),
              _buildSelectableItem(
                context: context,
                label: 'Google Maps',
                value: 'google_maps',
                selectedValue: controller.selectedNavigation.value,
                icon: Icons.map,
                onTap: () => _showNavigationOptions(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Rules & terms
          _buildSection(
            context: context,
            title: 'Rules and terms',
            items: [
              _buildNavigationItem(
                context: context,
                label: 'Terms and conditions',
                onTap: () => Get.to(() => const TermsAndConditionsView()),
              ),
              _buildNavigationItem(
                context: context,
                label: 'Licenses',
                onTap: () => Get.to(() => const LicensesView()),
              ),
              _buildNavigationItem(
                context: context,
                label: 'Privacy Policy',
                onTap: () => Get.to(() => const PrivacyPolicyView()),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Action buttons
          _buildActionButton(
            context: context,
            label: 'Log out',
            textColor: Colors.black,
            onTap: () => _showLogoutDialog(context),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context: context,
            label: 'Delete my account',
            textColor: Colors.red,
            onTap: () => controller.deleteAccount(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> items,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: themeChange.isDarkTheme() ? AppThemData.grey950 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey200,
            ),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberItem({required BuildContext context}) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final controller = Get.find<SettingsController>();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Phone number',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
              ),
            ),
          ),
          Obx(() {
            final phoneNumber = controller.phoneNumber.value;
            if (phoneNumber.isEmpty) {
              return const SizedBox.shrink();
            }
            // Mask phone number: show first 2 and last 2 digits
            final masked = phoneNumber.length > 4
                ? '${phoneNumber.substring(0, 2)}${'*' * (phoneNumber.length - 4)}${phoneNumber.substring(phoneNumber.length - 2)}'
                : phoneNumber;
            return Text(
              masked,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey600,
              ),
            );
          }),
        ],
      ),
    );
  }

  String _getCurrentLanguageDisplay() {
    final lang = controller.languages.firstWhere(
      (l) => l['name']?.toLowerCase() == controller.selectedLanguage.value,
      orElse: () => {'display': 'English'},
    );
    return lang['display'] ?? 'English';
  }

  Widget _buildSelectableItem({
    required BuildContext context,
    required String label,
    required String value,
    required String selectedValue,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isSelected = value == selectedValue;
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey200,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20,
                color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey600,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: const Color(0xFF007AFF), // iOS blue
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey200,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: themeChange.isDarkTheme() ? AppThemData.grey600 : AppThemData.grey400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox({
    required BuildContext context,
    required String text,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey700,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: themeChange.isDarkTheme() ? AppThemData.grey900 : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey200,
            ),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  void _showLanguageOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Provider.of<DarkThemeProvider>(context, listen: false).isDarkTheme()
              ? AppThemData.black
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Language',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Provider.of<DarkThemeProvider>(context, listen: false).isDarkTheme()
                    ? AppThemData.grey25
                    : AppThemData.grey950,
              ),
            ),
            const SizedBox(height: 16),
            ...controller.languages.map((lang) => Obx(() => _buildLanguageOption(
                  context: context,
                  label: lang['display']!,
                  value: lang['name']!.toLowerCase(),
                  isSelected: controller.selectedLanguage.value == lang['name']!.toLowerCase(),
                  onTap: () {
                    controller.setLanguage(lang['name']!.toLowerCase());
                    Get.back();
                  },
                ))),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String label,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey200,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: const Color(0xFF007AFF),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  void _showDistanceOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Provider.of<DarkThemeProvider>(context, listen: false).isDarkTheme()
              ? AppThemData.black
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DISTANCES',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Provider.of<DarkThemeProvider>(context, listen: false).isDarkTheme()
                    ? AppThemData.grey25
                    : AppThemData.grey950,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => _buildSelectableItem(
                  context: context,
                  label: 'Kilometres',
                  value: 'kilometres',
                  selectedValue: controller.selectedDistanceUnit.value,
                  onTap: () {
                    controller.setDistanceUnit('kilometres');
                    Get.back();
                  },
                )),
            Obx(() => _buildSelectableItem(
                  context: context,
                  label: 'Miles',
                  value: 'miles',
                  selectedValue: controller.selectedDistanceUnit.value,
                  onTap: () {
                    controller.setDistanceUnit('miles');
                    Get.back();
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showDarkModeOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Provider.of<DarkThemeProvider>(context, listen: false).isDarkTheme()
              ? AppThemData.black
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dark mode',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Provider.of<DarkThemeProvider>(context, listen: false).isDarkTheme()
                    ? AppThemData.grey25
                    : AppThemData.grey950,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => _buildSelectableItem(
                  context: context,
                  label: 'Off',
                  value: 'off',
                  selectedValue: controller.selectedDarkMode.value,
                  onTap: () {
                    controller.setDarkMode('off', context);
                    Get.back();
                  },
                )),
            Obx(() => _buildSelectableItem(
                  context: context,
                  label: 'Always enabled',
                  value: 'always',
                  selectedValue: controller.selectedDarkMode.value,
                  onTap: () {
                    controller.setDarkMode('always', context);
                    Get.back();
                  },
                )),
            Obx(() => _buildSelectableItem(
                  context: context,
                  label: 'System',
                  value: 'system',
                  selectedValue: controller.selectedDarkMode.value,
                  onTap: () {
                    controller.setDarkMode('system', context);
                    Get.back();
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showNavigationOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Provider.of<DarkThemeProvider>(context, listen: false).isDarkTheme()
              ? AppThemData.black
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Navigation',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Provider.of<DarkThemeProvider>(context, listen: false).isDarkTheme()
                    ? AppThemData.grey25
                    : AppThemData.grey950,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => _buildSelectableItem(
                  context: context,
                  label: 'Apple Maps',
                  value: 'apple_maps',
                  selectedValue: controller.selectedNavigation.value,
                  icon: Icons.apple,
                  onTap: () {
                    controller.setNavigation('apple_maps');
                    Get.back();
                  },
                )),
            Obx(() => _buildSelectableItem(
                  context: context,
                  label: 'Google Maps',
                  value: 'google_maps',
                  selectedValue: controller.selectedNavigation.value,
                  icon: Icons.map,
                  onTap: () {
                    controller.setNavigation('google_maps');
                    Get.back();
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logOut();
            },
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}

