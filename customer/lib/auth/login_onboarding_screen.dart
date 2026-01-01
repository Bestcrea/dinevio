// This file is kept for backward compatibility
// The new professional onboarding screen is in lib/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import '../screens/onboarding_screen.dart';

/// Legacy onboarding screen - redirects to new professional version
class LoginOnboardingScreen extends StatelessWidget {
  const LoginOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingScreen();
  }
}









