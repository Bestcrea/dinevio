import 'package:customer/app/modules/html_view_screen/views/html_view_screen_view.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return HtmlViewScreenView(
      title: 'Privacy Policy',
      htmlData: _getPrivacyPolicyContent(),
    );
  }

  String _getPrivacyPolicyContent() {
    return '''
    <div style="padding: 20px; font-family: Arial, sans-serif; line-height: 1.8; color: #333;">
      <h1 style="color: #7E57C2; margin-bottom: 30px; font-size: 28px;">Privacy Policy</h1>
      
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        <strong>Last Updated: 2025</strong><br>
        <strong>Version: 1.0.0</strong>
      </p>
      
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 30px;">
        This Privacy Policy describes how Bestcrea LLC ("we," "our," or "us") collects, uses, and protects your personal information when you use the Dinevio mobile application. By using our application, you agree to the collection and use of information in accordance with this policy.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">1. Information We Collect</h2>
      
      <h3 style="color: #555; margin-top: 20px; margin-bottom: 10px; font-size: 18px;">1.1 Personal Information</h3>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        We collect information that you provide directly to us, including:
      </p>
      <ul style="font-size: 16px; line-height: 1.8; margin-left: 20px; margin-bottom: 20px;">
        <li>Name, email address, and phone number</li>
        <li>Profile picture and account preferences</li>
        <li>Payment information (processed securely through third-party payment processors)</li>
        <li>Delivery addresses and location data</li>
        <li>Communication preferences</li>
      </ul>
      
      <h3 style="color: #555; margin-top: 20px; margin-bottom: 10px; font-size: 18px;">1.2 Usage Information</h3>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        We automatically collect certain information about your device and how you interact with our application:
      </p>
      <ul style="font-size: 16px; line-height: 1.8; margin-left: 20px; margin-bottom: 20px;">
        <li>Device information (model, operating system, unique device identifiers)</li>
        <li>IP address and location data</li>
        <li>App usage patterns and preferences</li>
        <li>Transaction history and order details</li>
        <li>Log files and error reports</li>
      </ul>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">2. How We Use Your Information</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        We use the collected information for the following purposes:
      </p>
      <ul style="font-size: 16px; line-height: 1.8; margin-left: 20px; margin-bottom: 20px;">
        <li>To provide, maintain, and improve our services</li>
        <li>To process transactions and send related information</li>
        <li>To send you notifications, updates, and promotional communications</li>
        <li>To personalize your experience and provide relevant content</li>
        <li>To monitor and analyze usage patterns and trends</li>
        <li>To detect, prevent, and address technical issues and security threats</li>
        <li>To comply with legal obligations and enforce our terms of service</li>
      </ul>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">3. Information Sharing and Disclosure</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        We do not sell your personal information. We may share your information in the following circumstances:
      </p>
      <ul style="font-size: 16px; line-height: 1.8; margin-left: 20px; margin-bottom: 20px;">
        <li><strong>Service Providers:</strong> We share information with third-party service providers who perform services on our behalf, such as payment processing, data analytics, and customer support.</li>
        <li><strong>Business Partners:</strong> We may share information with partner restaurants, stores, drivers, and couriers to facilitate service delivery.</li>
        <li><strong>Legal Requirements:</strong> We may disclose information if required by law or in response to valid legal requests.</li>
        <li><strong>Business Transfers:</strong> In the event of a merger, acquisition, or sale of assets, your information may be transferred to the acquiring entity.</li>
        <li><strong>With Your Consent:</strong> We may share information with your explicit consent or at your direction.</li>
      </ul>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">4. Data Security</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        We implement appropriate technical and organizational security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. These measures include:
      </p>
      <ul style="font-size: 16px; line-height: 1.8; margin-left: 20px; margin-bottom: 20px;">
        <li>Encryption of data in transit and at rest</li>
        <li>Secure authentication and access controls</li>
        <li>Regular security assessments and updates</li>
        <li>Employee training on data protection</li>
        <li>Compliance with industry security standards</li>
      </ul>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        However, no method of transmission over the Internet or electronic storage is 100% secure. While we strive to protect your information, we cannot guarantee absolute security.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">5. Location Information</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        Our application collects location information to provide location-based services such as finding nearby services, calculating delivery distances, and facilitating ride-sharing. You can control location permissions through your device settings. Location data is used solely for service delivery and is not shared with third parties except as necessary to provide our services.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">6. Your Rights and Choices</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        You have the following rights regarding your personal information:
      </p>
      <ul style="font-size: 16px; line-height: 1.8; margin-left: 20px; margin-bottom: 20px;">
        <li><strong>Access:</strong> You can request access to the personal information we hold about you.</li>
        <li><strong>Correction:</strong> You can update or correct your personal information through the application settings.</li>
        <li><strong>Deletion:</strong> You can request deletion of your account and associated data.</li>
        <li><strong>Opt-Out:</strong> You can opt-out of promotional communications by adjusting your notification preferences.</li>
        <li><strong>Data Portability:</strong> You can request a copy of your data in a structured, machine-readable format.</li>
      </ul>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">7. Data Retention</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        We retain your personal information for as long as necessary to provide our services and fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law. When we no longer need your information, we will securely delete or anonymize it.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">8. Children's Privacy</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        Our application is not intended for children under the age of 18. We do not knowingly collect personal information from children. If we become aware that we have collected information from a child without parental consent, we will take steps to delete such information promptly.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">9. International Data Transfers</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        Your information may be transferred to and processed in countries other than your country of residence. These countries may have data protection laws that differ from those in your country. We take appropriate safeguards to ensure that your information receives adequate protection.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">10. Changes to This Privacy Policy</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        We may update this Privacy Policy from time to time to reflect changes in our practices or for other operational, legal, or regulatory reasons. We will notify you of any material changes by posting the new Privacy Policy in the application and updating the "Last Updated" date. Your continued use of the application after such changes constitutes your acceptance of the updated policy.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">11. Cookies and Tracking Technologies</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        Our application may use cookies and similar tracking technologies to enhance your experience, analyze usage patterns, and provide personalized content. You can control cookie preferences through your device settings, though this may affect certain features of the application.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">12. Third-Party Links and Services</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        Our application may contain links to third-party websites or services. We are not responsible for the privacy practices of these third parties. We encourage you to review their privacy policies before providing any personal information.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">13. Contact Us</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        If you have any questions, concerns, or requests regarding this Privacy Policy or our data practices, please contact us:
      </p>
      <div style="background-color: #f5f5f5; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
        <p style="font-size: 16px; line-height: 1.8; margin: 5px 0;"><strong>Bestcrea LLC</strong></p>
        <p style="font-size: 16px; line-height: 1.8; margin: 5px 0;"><strong>Application Owner:</strong> Othman Benhada</p>
        <p style="font-size: 16px; line-height: 1.8; margin: 5px 0;"><strong>Developer:</strong> Mr. Marouan BAHTIT</p>
        <p style="font-size: 16px; line-height: 1.8; margin: 5px 0;">Please use the in-app support feature or contact us through the application for privacy-related inquiries.</p>
      </div>
      
      <div style="margin-top: 40px; padding-top: 20px; border-top: 2px solid #e0e0e0;">
        <p style="font-size: 14px; color: #666; text-align: center;">
          Copyright (c) 2025 Bestcrea LLC. All rights reserved.<br>
          Version 1.0.0 (2025)
        </p>
      </div>
    </div>
    ''';
  }
}

