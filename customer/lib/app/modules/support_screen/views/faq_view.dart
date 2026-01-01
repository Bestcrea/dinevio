import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQView extends StatefulWidget {
  const FAQView({super.key});

  @override
  State<FAQView> createState() => _FAQViewState();
}

class _FAQViewState extends State<FAQView> {
  int? _expandedIndex;

  static const Color _darkText = Color(0xFF1A1A1A);
  static const Color _greyText = Color(0xFF757575);
  static const Color _lightGrey = Color(0xFFF5F5F5);
  static const Color _primaryPurple = Color(0xFF7E57C2);

  final List<FAQItem> _faqs = [
    FAQItem(
      question: 'How do I place an order?',
      answer:
          'To place an order, browse through our categories, select the items you want, add them to your cart, and proceed to checkout. You can choose your payment method and delivery address before confirming your order.',
    ),
    FAQItem(
      question: 'What payment methods are accepted?',
      answer:
          'We accept cash on delivery, Apple Pay, Google Pay, and credit/debit cards. You can manage your payment methods in the Wallet section of your profile.',
    ),
    FAQItem(
      question: 'How long does delivery take?',
      answer:
          'Delivery time varies depending on your location and the type of service. Food orders typically take 30-45 minutes, while grocery and marketplace orders may take 1-2 hours. You can track your order in real-time through the app.',
    ),
    FAQItem(
      question: 'Can I cancel my order?',
      answer:
          'Yes, you can cancel your order if it hasn\'t been prepared yet. Go to your order details and tap the cancel button. Refunds will be processed according to your payment method within 3-5 business days.',
    ),
    FAQItem(
      question: 'How do I track my order?',
      answer:
          'Once your order is confirmed, you can track it in real-time from the "My Orders" section. You\'ll receive notifications about order status updates, including when it\'s being prepared, picked up, and out for delivery.',
    ),
    FAQItem(
      question: 'What if I receive the wrong item?',
      answer:
          'If you receive the wrong item, please contact our support team immediately through the app or call us. We\'ll arrange for a replacement or refund. You can also report the issue in your order details.',
    ),
    FAQItem(
      question: 'How do I apply a promo code?',
      answer:
          'You can apply a promo code during checkout. Enter your code in the promo code field and tap "Apply". Valid codes will automatically discount your order total. You can also add promo codes in the Promotions section of your profile.',
    ),
    FAQItem(
      question: 'Is there a minimum order amount?',
      answer:
          'Minimum order amounts vary by service type. Food orders typically have a minimum of 50 MAD, while grocery and marketplace orders may have different minimums. The minimum amount will be displayed before checkout.',
    ),
    FAQItem(
      question: 'How do I save my delivery address?',
      answer:
          'You can save multiple delivery addresses in the "Saved Addresses" section of your profile. Tap "Add new address" to save a new location. You can also use GPS to automatically detect your current location.',
    ),
    FAQItem(
      question: 'How do I contact customer support?',
      answer:
          'You can contact our 24/7 customer support through multiple channels: Chat with us via social media, call us at +212763495158, send an email to contact@dinevio.com, or use the in-app support feature.',
    ),
  ];

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
          'FAQ',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _darkText,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _faqs.length,
        itemBuilder: (context, index) {
          final faq = _faqs[index];
          final isExpanded = _expandedIndex == index;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              initiallyExpanded: isExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _expandedIndex = expanded ? index : null;
                });
              },
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _lightGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.help_outline,
                  color: _darkText,
                  size: 22,
                ),
              ),
              title: Text(
                faq.question,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _darkText,
                ),
              ),
              trailing: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: _primaryPurple,
              ),
              children: [
                Divider(color: Colors.grey.shade200),
                Text(
                  faq.answer,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: _greyText,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}

