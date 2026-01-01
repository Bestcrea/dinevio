import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:customer/app/modules/chatbot/views/chatbot_view.dart';
import 'contact_us_view.dart';
import 'faq_view.dart';

class SupportScreenView extends StatelessWidget {
  const SupportScreenView({super.key});

  static const Color _darkText = Color(0xFF1A1A1A);
  static const Color _greyText = Color(0xFF757575);
  static const Color _lightGrey = Color(0xFFF5F5F5);

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
          'Dinevio Assistance',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _darkText,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Help Section
            _buildSectionTitle('Help'),
            const SizedBox(height: 12),
            _buildHelpItem(
              icon: Icons.chat_bubble_outline,
              title: 'Chat with us',
              description: 'Stay in touch with us through social media.',
              onTap: () {
                Get.to(() => const ChatbotView());
              },
            ),
            const SizedBox(height: 12),
            _buildHelpItem(
              icon: Icons.phone_outlined,
              title: 'Contact us',
              description: 'Dinevio at your service 24/7.',
              onTap: () {
                Get.to(() => const ContactUsView());
              },
            ),
            const SizedBox(height: 12),
            _buildHelpItem(
              icon: Icons.help_outline,
              title: 'FAQ',
              description: 'Find answers to your questions.',
              onTap: () {
                Get.to(() => const FAQView());
              },
            ),
            const SizedBox(height: 32),
            // Links Section
            _buildSectionTitle('Links'),
            const SizedBox(height: 12),
            _buildLinkItem(
              icon: Icons.language,
              title: 'Web site',
              description: 'www.dinevio.com',
              onTap: () async {
                final url = Uri.parse('https://www.dinevio.com');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  Get.snackbar(
                    'Error',
                    'Could not open website',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            _buildLinkItem(
              icon: Icons.people_outline, // Social media icon for Facebook
              title: 'Dinevio on Facebook',
              description: 'Join our community on Facebook.',
              onTap: () async {
                // Try to open Facebook page
                final url = Uri.parse('https://www.facebook.com/dinevio');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  Get.snackbar(
                    'Error',
                    'Could not open Facebook',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            _buildLinkItem(
              icon: Icons.email_outlined,
              title: 'Email',
              description: 'contact@dinevio.com',
              onTap: () async {
                final url = Uri.parse('mailto:contact@dinevio.com');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  Get.snackbar(
                    'Error',
                    'Could not open email',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: _darkText,
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _lightGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: _darkText,
                  size: 22,
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
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: _greyText,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: _greyText,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinkItem({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _lightGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: _darkText,
                  size: 22,
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
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: _greyText,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: _greyText,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
