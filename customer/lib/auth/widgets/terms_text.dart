import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import '../screens/legal_webview_screen.dart';
import '../constants/legal_urls.dart';

/// Terms and Privacy Policy text widget with tappable links
class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            height: 1.4,
          ),
          children: [
            const TextSpan(
              text: 'joining our app means you agree with our ',
            ),
            TextSpan(
              text: 'Terms of use',
              style: TextStyle(
                color: Colors.black,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.to(() => LegalWebViewScreen(
                        title: 'Terms of Use',
                        url: LegalUrls.getTermsUrl(),
                      ));
                },
            ),
            const TextSpan(
              text: ' & ',
            ),
            TextSpan(
              text: 'Privacy policy',
              style: TextStyle(
                color: Colors.black,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.to(() => LegalWebViewScreen(
                        title: 'Privacy Policy',
                        url: LegalUrls.getPrivacyUrl(),
                      ));
                },
            ),
          ],
        ),
      ),
    );
  }
}

