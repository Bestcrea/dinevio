import 'package:customer/app/modules/html_view_screen/views/html_view_screen_view.dart';
import 'package:flutter/material.dart';

class LicensesView extends StatelessWidget {
  const LicensesView({super.key});

  @override
  Widget build(BuildContext context) {
    return HtmlViewScreenView(
      title: 'Licenses',
      htmlData: _getLicensesContent(),
    );
  }

  String _getLicensesContent() {
    return '''
    <div style="padding: 20px; font-family: Arial, sans-serif; line-height: 1.8; color: #333;">
      <h1 style="color: #7E57C2; margin-bottom: 30px; font-size: 28px;">Application Licenses</h1>
      
      <div style="background-color: #f5f5f5; padding: 20px; border-radius: 8px; margin-bottom: 30px;">
        <p style="font-size: 16px; line-height: 1.8; text-align: justify;">
          The application was developed by <strong>Bestcrea LLC</strong>. The application programmer's name is <strong>Mr. Marouan BAHTIT</strong>. It was programmed in <strong>2025</strong>. Copyright (c) <strong>2025</strong> All rights reserved. The application owner is <strong>Othman Benhada</strong>. This is a 100% Moroccan program launched to help solve people's problems and provide innovative solutions for everyday needs in Morocco.
        </p>
      </div>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">1. Intellectual Property Rights</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        All content, features, and functionality of the Dinevio application, including but not limited to text, graphics, logos, icons, images, audio clips, digital downloads, data compilations, and software, are the exclusive property of Bestcrea LLC and its licensors and are protected by Moroccan and international copyright, trademark, patent, trade secret, and other intellectual property laws.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">2. Software License</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        Subject to your compliance with these terms, Bestcrea LLC grants you a limited, non-exclusive, non-transferable, non-sublicensable license to access and use the Dinevio application for your personal, non-commercial use. This license does not include any resale or commercial use of the application or its contents.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">3. Restrictions on Use</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        You may not:
      </p>
      <ul style="font-size: 16px; line-height: 1.8; margin-left: 20px; margin-bottom: 20px;">
        <li>Copy, modify, or create derivative works of the application</li>
        <li>Reverse engineer, decompile, or disassemble the application</li>
        <li>Remove any copyright, trademark, or other proprietary notices from the application</li>
        <li>Use the application for any illegal or unauthorized purpose</li>
        <li>Attempt to gain unauthorized access to any portion of the application</li>
      </ul>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">4. Third-Party Licenses</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        The Dinevio application may incorporate third-party software, libraries, and frameworks that are subject to their respective open-source or commercial licenses. These third-party components are used in accordance with their respective license terms, and their use does not affect the proprietary nature of the Dinevio application itself.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">5. Trademark Rights</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        "Dinevio" and related logos, trademarks, service marks, and trade names are the property of Bestcrea LLC and Othman Benhada. You may not use these marks without the prior written consent of the owners. All other trademarks, service marks, and trade names appearing in the application are the property of their respective owners.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">6. User-Generated Content</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        By submitting content to the Dinevio application, you grant Bestcrea LLC a worldwide, royalty-free, perpetual, irrevocable, non-exclusive license to use, reproduce, modify, adapt, publish, translate, create derivative works from, distribute, and display such content in any media. You represent and warrant that you own or have the necessary rights to grant this license.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">7. Updates and Modifications</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        Bestcrea LLC reserves the right to update, modify, or discontinue any aspect of the Dinevio application at any time. These updates may include bug fixes, feature enhancements, security patches, or other improvements. By continuing to use the application after such updates, you agree to be bound by the updated terms.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">8. Termination of License</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        Your license to use the Dinevio application is effective until terminated. Bestcrea LLC may terminate or suspend your access to the application immediately, without prior notice or liability, for any reason, including if you breach these terms. Upon termination, your right to use the application will cease immediately.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">9. Disclaimer of Warranties</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        The Dinevio application is provided "as is" and "as available" without warranties of any kind, either express or implied. Bestcrea LLC does not warrant that the application will be uninterrupted, error-free, or free from viruses or other harmful components.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">10. Limitation of Liability</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        To the fullest extent permitted by law, Bestcrea LLC, Othman Benhada, and their respective officers, directors, employees, and agents shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising out of or related to your use of the Dinevio application.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">11. Governing Law</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        These license terms shall be governed by and construed in accordance with the laws of the Kingdom of Morocco. Any disputes arising from or related to these terms shall be subject to the exclusive jurisdiction of the courts of Morocco.
      </p>
      
      <h2 style="color: #7E57C2; margin-top: 30px; margin-bottom: 15px; font-size: 22px;">12. Contact Information</h2>
      <p style="font-size: 16px; line-height: 1.8; text-align: justify; margin-bottom: 20px;">
        For any questions or concerns regarding these licenses, please contact:
      </p>
      <div style="background-color: #f5f5f5; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
        <p style="font-size: 16px; line-height: 1.8; margin: 5px 0;"><strong>Bestcrea LLC</strong></p>
        <p style="font-size: 16px; line-height: 1.8; margin: 5px 0;"><strong>Application Owner:</strong> Othman Benhada</p>
        <p style="font-size: 16px; line-height: 1.8; margin: 5px 0;"><strong>Developer:</strong> Mr. Marouan BAHTIT</p>
        <p style="font-size: 16px; line-height: 1.8; margin: 5px 0;"><strong>Year of Development:</strong> 2025</p>
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

