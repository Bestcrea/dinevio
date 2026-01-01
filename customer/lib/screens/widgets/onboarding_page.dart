import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget for a single onboarding page
/// Responsive design with proper spacing to avoid overlap with dots
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  final String imagePath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.textScaleFactorOf(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive illustration size
    final illustrationSize = (screenHeight * 0.35).clamp(240.0, 360.0);
    
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06.clamp(16.0, 24.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.03.clamp(16.0, 32.0)),
            // Logo at top center
            Image.asset(
              'assets/login/logo_login.png',
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox.shrink();
              },
            ),
            SizedBox(height: screenHeight * 0.04.clamp(24.0, 40.0)),
            // Illustration centered
            SizedBox(
              width: illustrationSize,
              height: illustrationSize,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    size: 100,
                    color: Colors.grey,
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.04.clamp(24.0, 32.0)),
            // Title (responsive font size)
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: (28 * (1.0 / textScaleFactor.clamp(1.0, 1.5)))
                    .clamp(24.0, 32.0),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111111),
                height: 1.2,
              ),
            ),
            SizedBox(height: screenHeight * 0.015.clamp(8.0, 12.0)),
            // Subtitle (responsive font size)
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: (16 * (1.0 / textScaleFactor.clamp(1.0, 1.5)))
                    .clamp(14.0, 18.0),
                fontWeight: FontWeight.normal,
                color: const Color(0xFF666666),
                height: 1.4,
              ),
            ),
            // Bottom spacing to prevent overlap with dots
            SizedBox(height: screenHeight * 0.08.clamp(32.0, 48.0)),
          ],
        ),
      ),
    );
  }
}
