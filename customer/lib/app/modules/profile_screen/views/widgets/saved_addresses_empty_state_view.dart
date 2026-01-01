import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedAddressesEmptyStateView extends StatelessWidget {
  const SavedAddressesEmptyStateView({super.key});

  static const Color _primaryPurple = Color(0xFF7E57C2);
  static const Color _darkText = Color(0xFF1A1A1A);
  static const Color _greyText = Color(0xFF757575);

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
          'Saved addresses',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _darkText,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                // Illustration (SVG)
                SizedBox(
                  width: 240, // Consistent size: 220-260px range
                  height: 240,
                  child: SvgPicture.asset(
                    'assets/illustrations/profile/map_pin.svg',
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    placeholderBuilder: (context) => _buildIllustrationSkeleton(240, 240),
                    errorBuilder: (context, error, stackTrace) => _buildIllustrationError(
                      icon: Icons.location_on_outlined,
                      message: 'Addresses illustration',
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Saved addresses',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: _darkText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Easily access your favorite locations.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: _greyText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Address list placeholder
                _buildAddressItem(
                  icon: Icons.home_outlined,
                  title: 'Home',
                  subtitle: 'Tap to set the address',
                ),
                const SizedBox(height: 12),
                _buildAddressItem(
                  icon: Icons.business_outlined,
                  title: 'Work',
                  subtitle: 'Tap to set the address',
                ),
                const SizedBox(height: 12),
                _buildAddressItem(
                  icon: Icons.add_circle_outline,
                  title: 'Add new address',
                  subtitle: null,
                  isAddButton: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressItem({
    required IconData icon,
    required String title,
    String? subtitle,
    bool isAddButton = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.snackbar(title, 'Coming soon');
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isAddButton
                      ? _primaryPurple.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isAddButton ? _primaryPurple : _darkText,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _darkText,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: _greyText,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Subtle skeleton placeholder for illustration
  Widget _buildIllustrationSkeleton(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  /// Error fallback with icon and text
  Widget _buildIllustrationError({
    required IconData icon,
    required String message,
  }) {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


