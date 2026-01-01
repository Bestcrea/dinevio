import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritesEmptyStateView extends StatelessWidget {
  const FavoritesEmptyStateView({super.key});

  static const Color _darkText = Color(0xFF1A1A1A);
  static const Color _greyText = Color(0xFF757575);
  static const Color _pinkGlow = Color(0xFFFF69B4); // Pink for heart glow
  static const Color _lightPink = Color(0xFFFFB6C1); // Light pink for gradient

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
          'Favorites',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _darkText,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3D Heart illustration with glow effect
              Center(
                child: _buildHeartIllustration(),
              ),
              const SizedBox(height: 40),
              // Title
              Text(
                'Find a gem?',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _darkText,
                ),
              ),
              const SizedBox(height: 12),
              // Description text (left-aligned, spans two lines)
              Text(
                'Add restaurants to your favorites to reorder from them faster in the future.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: _greyText,
                  height: 1.5, // Line height for readability
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build 3D heart illustration with pink glow gradient
  Widget _buildHeartIllustration() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Gradient from bright pink center to lighter pink edges with glow
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [
            _pinkGlow.withOpacity(0.9), // Bright pink at center
            _pinkGlow.withOpacity(0.7), // Medium pink
            _lightPink.withOpacity(0.5), // Light pink
            _lightPink.withOpacity(0.2), // Very light pink at edges
            Colors.transparent, // Fade to transparent
          ],
          stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
        ),
        // Outer glow effect
        boxShadow: [
          BoxShadow(
            color: _pinkGlow.withOpacity(0.4),
            blurRadius: 40,
            spreadRadius: 10,
          ),
          BoxShadow(
            color: _pinkGlow.withOpacity(0.2),
            blurRadius: 60,
            spreadRadius: 20,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Inner glow for depth
            gradient: RadialGradient(
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
          child: const Icon(
            Icons.favorite,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
    );
  }
}
