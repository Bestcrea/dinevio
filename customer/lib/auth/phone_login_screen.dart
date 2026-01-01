import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/country_picker_sheet.dart';
import 'models/country.dart';
import 'data/countries.dart';
import '../screens/widgets/phone_input_field.dart';
import '../widgets/primary_button.dart';
import 'otp_verification_screen.dart';
import 'services/firebase_phone_auth.dart';

/// Professional phone login screen inspired by inDrive design
class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  Country _country = kCountries.first; // Morocco by default
  bool _loading = false;

  // Primary color: Violet #7E57C2
  static const _primaryColor = Color(0xFF7E57C2);

  bool get _isValid => _phoneController.text.trim().length >= 8;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickCountry() async {
    final result = await showCountryPicker(context, _country);
    if (result != null) {
      setState(() => _country = result);
    }
  }

  void _showError(Object err) {
    Get.snackbar(
      'Error',
      err.toString(),
      backgroundColor: Colors.red.shade50,
      colorText: Colors.red.shade900,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _completeLogin() async {
    try {
      await Get.offAllNamed('/home');
    } catch (_) {
      Get.back(result: true);
    }
  }

  Future<void> _startVerification() async {
    if (!_isValid || _loading) return;

    final phone = '${_country.dialCode}${_phoneController.text.trim()}';
    setState(() => _loading = true);

    try {
      final result = await FirebasePhoneAuthService.instance.requestCode(
        phone: phone,
      );

      if (result.autoVerified) {
        await _completeLogin();
        return;
      }

      if (result.verificationId == null) {
        _showError('Verification failed. Please try again.');
        return;
      }

      final verified = await Get.to<bool>(
        () => OtpVerificationScreen(
          phone: phone,
          verificationId: result.verificationId!,
          resendToken: result.resendingToken,
        ),
      );

      if (verified == true) {
        await _completeLogin();
      }
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final textScaleFactor = MediaQuery.textScaleFactorOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: viewInsets.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Title
              Text(
                'Join us via phone number',
                style: GoogleFonts.inter(
                  fontSize: (28 * (1.0 / textScaleFactor.clamp(1.0, 1.5)))
                      .clamp(24.0, 32.0),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111111),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                'We\'ll text a code to verify your phone',
                style: GoogleFonts.inter(
                  fontSize: (16 * (1.0 / textScaleFactor.clamp(1.0, 1.5)))
                      .clamp(14.0, 18.0),
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF666666),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              // Phone input field
              PhoneInputField(
                country: _country,
                controller: _phoneController,
                onCountryTap: _pickCountry,
                onClear: () {
                  _phoneController.clear();
                  setState(() {});
                },
              ),
              const Spacer(),
              // Loading indicator
              if (_loading)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        _primaryColor,
                      ),
                    ),
                  ),
                ),
              // Next button (sticky at bottom)
              PrimaryButton(
                label: 'Next',
                onPressed: _startVerification,
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                enabled: _isValid && !_loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
