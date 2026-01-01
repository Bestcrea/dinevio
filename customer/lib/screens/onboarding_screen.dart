import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'widgets/onboarding_page.dart';
import '../auth/phone_login_screen.dart';
import '../app/modules/login/controllers/login_controller.dart';
import '../widgets/primary_button.dart';

/// Professional onboarding screen with 2 pages, inspired by inDrive design
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/login/oboarding_login1.png',
      'title': 'Your safety is our priority',
      'subtitle': 'Only verified service providers.\nChoose yours by rating and other info',
    },
    {
      'image': 'assets/login/oboarding_login2.png',
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


  @override
  Widget build(BuildContext context) {
    // Primary color: Violet #7E57C2 (Dinevio brand color)
    const primaryColor = Color(0xFF7E57C2);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // PageView with onboarding pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return OnboardingPage(
                    imagePath: page['image']!,
                    title: page['title']!,
                    subtitle: page['subtitle']!,
                  );
                },
              ),
            ),
            // Dots indicator (with proper spacing to avoid overlap)
            SizedBox(height: screenHeight * 0.02.clamp(8.0, 16.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 10 : 8,
                  height: _currentPage == index ? 10 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? primaryColor : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03.clamp(16.0, 24.0)),
            // Buttons section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Primary button: Continue with Phone
                  PrimaryButton(
                    label: 'Continue With Phone',
                    onPressed: _navigateToPhoneLogin,
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  // Secondary button: Continue with Google
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade50,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        // Get or create LoginController
                        try {
                          final controller = Get.find<LoginController>();
                          await controller.loginWithGoogle();
                        } catch (e) {
                          final controller = Get.put(LoginController());
                          await controller.loginWithGoogle();
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Google logo placeholder (you can use an SVG asset if available)
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.g_mobiledata,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Continue With Google',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Terms text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Joining our app means you agree with our ',
                          ),
                          TextSpan(
                            text: 'Terms of Use',
                            style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // TODO: Navigate to Terms of Use
                                Get.snackbar('Terms', 'Terms of Use page');
                              },
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // TODO: Navigate to Privacy Policy
                                Get.snackbar('Privacy', 'Privacy Policy page');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

