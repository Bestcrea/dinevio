import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer/app/modules/login/controllers/login_controller.dart';
import 'widgets/terms_text.dart';
import '../widgets/primary_button.dart';
import 'widgets/secondary_button.dart';
import 'phone_login_screen.dart';

/// Professional onboarding login screen with 2 slides, inspired by inDrive design
class OnboardingLoginScreen extends StatefulWidget {
  const OnboardingLoginScreen({super.key});

  @override
  State<OnboardingLoginScreen> createState() => _OnboardingLoginScreenState();
}

class _OnboardingLoginScreenState extends State<OnboardingLoginScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Primary color: Violet #7E57C2 (or use AppThemData.primary500 if preferred)
  static const _primaryColor = Color(0xFF7E57C2);

  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/login/onboarding_login1.png',
      'title': 'Your safety is our priority',
      'subtitle': 'Only verified service providers.\nChoose yours by rating and other info',
    },
    {
      'image': 'assets/login/onboarding_login2.png',
      'title': 'Your app for fair deals',
      'subtitle': 'Choose rides that are right for you',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _navigateToPhoneLogin() {
    Get.to(() => const PhoneLoginScreen());
  }

  Future<void> _handleGoogleSignIn() async {
    // Get or create LoginController
    LoginController controller;
    try {
      controller = Get.find<LoginController>();
    } catch (e) {
      // Controller not found, create it
      controller = Get.put(LoginController());
    }
    await controller.loginWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final viewInsets = MediaQuery.of(context).viewInsets;
    final textScaleFactor = MediaQuery.textScaleFactorOf(context);

    // Responsive illustration size
    final illustrationSize = (screenWidth * 0.75).clamp(240.0, 360.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: viewInsets.bottom,
          ),
          child: Column(
            children: [
              // Logo at top
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 8),
                child: Image.asset(
                  'assets/login/logo_login.png',
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
              // PageView with illustrations
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * 0.05),
                          // Illustration
                          SizedBox(
                            width: illustrationSize,
                            height: illustrationSize,
                            child: Image.asset(
                              page['image']!,
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
                          const SizedBox(height: 32),
                          // Title
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              page['title']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: (32 * (1.0 / textScaleFactor.clamp(1.0, 1.5))).clamp(24.0, 36.0),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Subtitle
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              page['subtitle']!,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: (18 * (1.0 / textScaleFactor.clamp(1.0, 1.5))).clamp(16.0, 20.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.black
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Bottom sticky section with buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Primary button: Continue with Phone
                    PrimaryButton(
                      label: 'Continue With Phone',
                      onPressed: _navigateToPhoneLogin,
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    // Secondary button: Continue with Google
                    SecondaryButton(
                      label: 'Continue With Google',
                      iconPath: 'assets/icon/ic_google.svg',
                      onPressed: _handleGoogleSignIn,
                    ),
                    const SizedBox(height: 8),
                    // Terms text
                    const TermsText(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

