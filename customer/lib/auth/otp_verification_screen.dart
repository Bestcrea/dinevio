import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import 'services/firebase_phone_auth.dart';

/// Professional OTP verification screen matching inDrive style
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.phone,
    required this.verificationId,
    this.resendToken,
  });
  final String phone;
  final String verificationId;
  final int? resendToken;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with WidgetsBindingObserver {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  late String _verificationId;
  int? _resendToken;
  bool _loading = false;
  bool _resending = false;
  String? _errorMessage;
  Timer? _timer;
  int _secondsLeft = 60;
  DateTime? _endTime;

  // Primary color: Violet #7E57C2
  static const _primaryColor = Color(0xFF7E57C2);

  bool get _valid => _otpController.text.trim().length == 6;
  bool get _canResend => !_resending && _secondsLeft == 0 && _resendToken != null;

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
    _resendToken = widget.resendToken;
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
    // Auto-focus on first box
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _otpFocusNode.requestFocus();
    });
    _otpController.addListener(_onOtpChanged);
  }

  @override
  void dispose() {
    _otpController.removeListener(_onOtpChanged);
    _otpController.dispose();
    _otpFocusNode.dispose();
    _cancelTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onOtpChanged() {
    setState(() {
      _errorMessage = null; // Clear error when user types
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _endTime != null) {
      _tick();
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
    // Optional: Haptic feedback
    HapticFeedback.mediumImpact();
  }

  void _showSuccess() {
    // Optional: Haptic feedback
    HapticFeedback.lightImpact();
  }

  String _formatPhoneNumber(String phone) {
    // Format: +212 XX XX XX XX (mask middle digits)
    if (phone.length < 8) return phone;
    
    // Remove all non-digits to get clean number
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length < 8) return phone;
    
    // Extract country code (first 1-3 digits, typically 1-3 digits)
    // For Morocco +212, we'll take first 3 digits as country code
    String countryCode = '';
    if (phone.startsWith('+')) {
      // Find where country code ends (usually 1-3 digits)
      final match = RegExp(r'^\+\d{1,3}').firstMatch(phone);
      if (match != null) {
        countryCode = match.group(0)!;
      } else {
        countryCode = '+212'; // Default to Morocco
      }
    } else {
      countryCode = '+212'; // Default if no +
    }
    
    // Get last 4 digits
    final lastFour = cleaned.length >= 4 
        ? cleaned.substring(cleaned.length - 4)
        : cleaned;
    
    // Format: +212 XX XX 5678
    return '$countryCode XX XX $lastFour';
  }

  String _formatTimer(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _startTimer() {
    _cancelTimer();
    _secondsLeft = 60;
    _endTime = DateTime.now().add(const Duration(seconds: 60));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    setState(() {});
  }

  void _tick() {
    if (_endTime == null) return;
    final remaining = _endTime!.difference(DateTime.now()).inSeconds;
    final next = remaining.clamp(0, 60);
    if (next != _secondsLeft && mounted) {
      setState(() {
        _secondsLeft = next;
      });
    } else {
      _secondsLeft = next;
    }
    if (_secondsLeft == 0) {
      _cancelTimer();
    }
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _verify() async {
    if (!_valid || _loading) return;
    
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      await FirebasePhoneAuthService.instance.verifyCode(
        verificationId: _verificationId,
        smsCode: _otpController.text.trim(),
      );
      _showSuccess();
      Get.back(result: true);
    } catch (e) {
      _showError('Invalid code. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _resend() async {
    if (!_canResend) return;
    
    setState(() {
      _resending = true;
      _errorMessage = null;
    });

    try {
      final result = await FirebasePhoneAuthService.instance.requestCode(
        phone: widget.phone,
        forceResendToken: _resendToken,
      );
      
      if (result.autoVerified) {
        _showSuccess();
        Get.back(result: true);
        return;
      }
      
      if (result.verificationId != null) {
        setState(() {
          _verificationId = result.verificationId!;
          _resendToken = result.resendingToken;
          _otpController.clear();
          _startTimer();
        });
        _otpFocusNode.requestFocus();
        Get.snackbar(
          'Code resent',
          'We sent a new code to ${_formatPhoneNumber(widget.phone)}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade900,
        );
      }
    } catch (e) {
      _showError('Failed to resend code. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _resending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final textScaleFactor = MediaQuery.textScaleFactorOf(context);
    final screenWidth = MediaQuery.of(context).size.width;

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
        child: GestureDetector(
          onTap: () {
            // Dismiss keyboard on tap outside
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: viewInsets.bottom + 24,
            ),
            child: Column(
              children: [
                const Spacer(flex: 2),
                // Title
                Text(
                  'Enter verification code',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: (32 * (1.0 / textScaleFactor.clamp(1.0, 1.5)))
                        .clamp(28.0, 36.0),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111111),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                // Subtitle
                Text(
                  'We sent a 6-digit code to ${_formatPhoneNumber(widget.phone)}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: (18 * (1.0 / textScaleFactor.clamp(1.0, 1.5)))
                        .clamp(16.0, 20.0),
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 48),
                // OTP Input
                Pinput(
                  length: 6,
                  controller: _otpController,
                  focusNode: _otpFocusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  defaultPinTheme: PinTheme(
                    width: (screenWidth * 0.12).clamp(48.0, 52.0),
                    height: 56,
                    textStyle: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: (screenWidth * 0.12).clamp(48.0, 52.0),
                    height: 56,
                    textStyle: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: _primaryColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: (screenWidth * 0.12).clamp(48.0, 52.0),
                    height: 56,
                    textStyle: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  errorPinTheme: PinTheme(
                    width: (screenWidth * 0.12).clamp(48.0, 52.0),
                    height: 56,
                    textStyle: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.red.shade400,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onCompleted: (pin) {
                    // Auto-verify when all 6 digits entered (optional)
                    // _verify();
                  },
                  onChanged: (value) {
                    setState(() {
                      _errorMessage = null;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Error text
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.red.shade600,
                        height: 1.4,
                      ),
                    ),
                  ),
                const Spacer(flex: 2),
                // Resend section
                Column(
                  children: [
                    Text(
                      "Didn't receive the code?",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_resending)
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                        ),
                      )
                    else if (_secondsLeft > 0)
                      Text(
                        _formatTimer(_secondsLeft),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      )
                    else
                      TextButton(
                        onPressed: _canResend ? _resend : null,
                        style: TextButton.styleFrom(
                          foregroundColor: _primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          'Resend code',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _primaryColor,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 32),
                // Verify button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (_valid && !_loading)
                          ? _primaryColor
                          : _primaryColor.withOpacity(0.4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    onPressed: (_valid && !_loading) ? _verify : null,
                    child: _loading
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Verify',
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
