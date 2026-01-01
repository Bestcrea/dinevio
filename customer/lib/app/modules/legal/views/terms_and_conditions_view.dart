import 'package:customer/app/modules/html_view_screen/views/html_view_screen_view.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    
    return Scaffold(
      backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuItem(
            context: context,
            title: 'Application Terms of Use',
            onTap: () => Get.to(() => HtmlViewScreenView(
              title: 'Application Terms of Use',
              htmlData: _getApplicationTermsOfUse(),
            )),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context: context,
            title: 'Dinevio Rides Terms of Use',
            onTap: () => Get.to(() => HtmlViewScreenView(
              title: 'Dinevio Rides Terms of Use',
              htmlData: _getRidesTermsOfUse(),
            )),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context: context,
            title: 'Dinevio Parcel Terms of Use',
            onTap: () => Get.to(() => HtmlViewScreenView(
              title: 'Dinevio Parcel Terms of Use',
              htmlData: _getParcelTermsOfUse(),
            )),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context: context,
            title: 'Dinevio Intercity Terms of Use',
            onTap: () => Get.to(() => HtmlViewScreenView(
              title: 'Dinevio Intercity Terms of Use',
              htmlData: _getIntercityTermsOfUse(),
            )),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context: context,
            title: 'Dinevio Grocery Terms of Use',
            onTap: () => Get.to(() => HtmlViewScreenView(
              title: 'Dinevio Grocery Terms of Use',
              htmlData: _getGroceryTermsOfUse(),
            )),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context: context,
            title: 'Dinevio Parapharmacy Terms of Use',
            onTap: () => Get.to(() => HtmlViewScreenView(
              title: 'Dinevio Parapharmacy Terms of Use',
              htmlData: _getParapharmacyTermsOfUse(),
            )),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            context: context,
            title: 'Dinevio Food Terms of Use',
            onTap: () => Get.to(() => HtmlViewScreenView(
              title: 'Dinevio Food Terms of Use',
              htmlData: _getFoodTermsOfUse(),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: themeChange.isDarkTheme() ? AppThemData.grey950 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey200,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: themeChange.isDarkTheme() ? AppThemData.grey600 : AppThemData.grey400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _getApplicationTermsOfUse() {
    return '''
    <div style="padding: 20px; font-family: Arial, sans-serif; line-height: 1.6;">
      <h1 style="color: #7E57C2; margin-bottom: 20px;">Application Terms of Use</h1>
      
      <h2>1. Acceptance of Terms</h2>
      <p>By accessing and using the Dinevio application, you accept and agree to be bound by the terms and provision of this agreement.</p>
      
      <h2>2. Use License</h2>
      <p>Permission is granted to temporarily download one copy of the materials on Dinevio's application for personal, non-commercial transitory viewing only.</p>
      
      <h2>3. User Account</h2>
      <p>You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.</p>
      
      <h2>4. Prohibited Uses</h2>
      <p>You may not use our application:</p>
      <ul>
        <li>In any way that violates any applicable national or international law or regulation</li>
        <li>To transmit, or procure the sending of, any advertising or promotional material</li>
        <li>To impersonate or attempt to impersonate the company, a company employee, another user, or any other person or entity</li>
      </ul>
      
      <h2>5. Service Availability</h2>
      <p>We reserve the right to withdraw or amend our application, and any service or material we provide on the application, in our sole discretion without notice.</p>
      
      <h2>6. Limitation of Liability</h2>
      <p>In no event shall Dinevio, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential, or punitive damages.</p>
      
      <h2>7. Changes to Terms</h2>
      <p>We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days notice prior to any new terms taking effect.</p>
      
      <p style="margin-top: 30px; color: #666; font-size: 14px;">Last updated: 2025</p>
    </div>
    ''';
  }

  String _getRidesTermsOfUse() {
    return '''
    <div style="padding: 20px; font-family: Arial, sans-serif; line-height: 1.6;">
      <h1 style="color: #7E57C2; margin-bottom: 20px;">Dinevio Rides Terms of Use</h1>
      
      <h2>1. Service Description</h2>
      <p>Dinevio Rides connects passengers with drivers for transportation services. By using this service, you agree to these terms.</p>
      
      <h2>2. User Responsibilities</h2>
      <p>Passengers must:</p>
      <ul>
        <li>Provide accurate pickup and destination locations</li>
        <li>Be present at the pickup location at the scheduled time</li>
        <li>Treat drivers with respect and follow safety guidelines</li>
        <li>Pay the agreed fare through the application</li>
      </ul>
      
      <h2>3. Driver Responsibilities</h2>
      <p>Drivers must:</p>
      <ul>
        <li>Maintain a valid driver's license and vehicle registration</li>
        <li>Provide safe and reliable transportation</li>
        <li>Follow all traffic laws and regulations</li>
        <li>Maintain vehicle insurance as required by law</li>
      </ul>
      
      <h2>4. Pricing and Payment</h2>
      <p>Fares are calculated based on distance, time, and demand. All payments must be made through the application using approved payment methods.</p>
      
      <h2>5. Cancellation Policy</h2>
      <p>Users may cancel rides subject to cancellation fees as outlined in the application. Drivers may cancel rides in accordance with platform policies.</p>
      
      <h2>6. Safety and Security</h2>
      <p>Dinevio is committed to user safety. All users must comply with safety guidelines and report any incidents immediately.</p>
      
      <p style="margin-top: 30px; color: #666; font-size: 14px;">Last updated: 2025</p>
    </div>
    ''';
  }

  String _getParcelTermsOfUse() {
    return '''
    <div style="padding: 20px; font-family: Arial, sans-serif; line-height: 1.6;">
      <h1 style="color: #7E57C2; margin-bottom: 20px;">Dinevio Parcel Terms of Use</h1>
      
      <h2>1. Service Description</h2>
      <p>Dinevio Parcel provides courier and delivery services for packages and parcels. By using this service, you agree to these terms.</p>
      
      <h2>2. Prohibited Items</h2>
      <p>The following items are strictly prohibited:</p>
      <ul>
        <li>Illegal substances or contraband</li>
        <li>Hazardous materials</li>
        <li>Perishable items without proper packaging</li>
        <li>Items exceeding weight or size limits</li>
        <li>Cash or negotiable instruments</li>
      </ul>
      
      <h2>3. Packaging Requirements</h2>
      <p>Users are responsible for properly packaging items. Dinevio is not liable for damage due to improper packaging.</p>
      
      <h2>4. Delivery Times</h2>
      <p>Estimated delivery times are provided for guidance only. Actual delivery times may vary based on traffic, weather, and other factors.</p>
      
      <h2>5. Liability and Insurance</h2>
      <p>Dinevio provides insurance coverage up to the declared value of the parcel. Users must accurately declare parcel value.</p>
      
      <h2>6. Tracking and Proof of Delivery</h2>
      <p>All parcels are tracked through the application. Proof of delivery is provided upon successful completion.</p>
      
      <h2>7. Claims and Disputes</h2>
      <p>Claims for lost or damaged items must be filed within 7 days of delivery or expected delivery date.</p>
      
      <p style="margin-top: 30px; color: #666; font-size: 14px;">Last updated: 2025</p>
    </div>
    ''';
  }

  String _getIntercityTermsOfUse() {
    return '''
    <div style="padding: 20px; font-family: Arial, sans-serif; line-height: 1.6;">
      <h1 style="color: #7E57C2; margin-bottom: 20px;">Dinevio Intercity Terms of Use</h1>
      
      <h2>1. Service Description</h2>
      <p>Dinevio Intercity provides transportation services between cities. By using this service, you agree to these terms.</p>
      
      <h2>2. Booking and Cancellation</h2>
      <p>Intercity rides must be booked in advance. Cancellation policies vary based on timing and distance. Full refunds are available for cancellations made at least 24 hours before departure.</p>
      
      <h2>3. Passenger Responsibilities</h2>
      <p>Passengers must:</p>
      <ul>
        <li>Arrive at the pickup location at least 10 minutes before scheduled departure</li>
        <li>Carry valid identification</li>
        <li>Comply with vehicle capacity limits</li>
        <li>Respect other passengers and the driver</li>
      </ul>
      
      <h2>4. Luggage Policy</h2>
      <p>Each passenger is allowed one standard-sized suitcase and one carry-on bag. Additional luggage may incur extra charges.</p>
      
      <h2>5. Route and Stops</h2>
      <p>Routes are optimized for efficiency. Additional stops may be available for an extra fee and must be arranged in advance.</p>
      
      <h2>6. Safety Standards</h2>
      <p>All intercity vehicles must meet safety standards and undergo regular inspections. Drivers must have appropriate licenses and insurance.</p>
      
      <h2>7. Pricing</h2>
      <p>Pricing is based on distance, route, and demand. Prices are confirmed at booking and are non-refundable except as specified in cancellation policies.</p>
      
      <p style="margin-top: 30px; color: #666; font-size: 14px;">Last updated: 2025</p>
    </div>
    ''';
  }

  String _getGroceryTermsOfUse() {
    return '''
    <div style="padding: 20px; font-family: Arial, sans-serif; line-height: 1.6;">
      <h1 style="color: #7E57C2; margin-bottom: 20px;">Dinevio Grocery Terms of Use</h1>
      
      <h2>1. Service Description</h2>
      <p>Dinevio Grocery connects customers with grocery stores and supermarkets for online shopping and delivery services.</p>
      
      <h2>2. Product Availability</h2>
      <p>Product availability is subject to stock levels at partner stores. We reserve the right to substitute items of equal or greater value if your selected item is unavailable.</p>
      
      <h2>3. Pricing</h2>
      <p>Prices displayed in the application are subject to change. Final prices are confirmed at checkout. Prices may vary from in-store prices.</p>
      
      <h2>4. Order Modifications</h2>
      <p>Orders can be modified or cancelled within 5 minutes of placement. After this period, orders cannot be modified.</p>
      
      <h2>5. Delivery</h2>
      <p>Delivery times are estimates and may vary. We will notify you of any significant delays. You must be available to receive your order at the specified delivery address.</p>
      
      <h2>6. Quality and Freshness</h2>
      <p>We work with partner stores to ensure product quality. However, we are not responsible for the quality of products provided by third-party stores.</p>
      
      <h2>7. Returns and Refunds</h2>
      <p>Returns and refunds are handled according to partner store policies. Damaged or incorrect items may be eligible for refund or replacement.</p>
      
      <h2>8. Payment</h2>
      <p>Payment is processed at checkout. Accepted payment methods include cash on delivery, credit/debit cards, and mobile payment solutions.</p>
      
      <p style="margin-top: 30px; color: #666; font-size: 14px;">Last updated: 2025</p>
    </div>
    ''';
  }

  String _getParapharmacyTermsOfUse() {
    return '''
    <div style="padding: 20px; font-family: Arial, sans-serif; line-height: 1.6;">
      <h1 style="color: #7E57C2; margin-bottom: 20px;">Dinevio Parapharmacy Terms of Use</h1>
      
      <h2>1. Service Description</h2>
      <p>Dinevio Parapharmacy provides access to parapharmacy products including health, beauty, and wellness items through partner pharmacies.</p>
      
      <h2>2. Medical Disclaimer</h2>
      <p>Dinevio is not a medical service provider. Products available through this service are for general wellness and should not replace professional medical advice. Always consult with a healthcare professional before using any health products.</p>
      
      <h2>3. Prescription Medications</h2>
      <p>Prescription medications require a valid prescription from a licensed healthcare provider. Prescriptions must be uploaded and verified before delivery.</p>
      
      <h2>4. Product Information</h2>
      <p>Product descriptions and information are provided by partner pharmacies. We strive for accuracy but are not responsible for errors in product information.</p>
      
      <h2>5. Age Restrictions</h2>
      <p>Certain products may have age restrictions. Users must be of legal age to purchase restricted items. Age verification may be required at delivery.</p>
      
      <h2>6. Storage and Handling</h2>
      <p>Products requiring special storage conditions will be handled appropriately. However, users are responsible for proper storage upon receipt.</p>
      
      <h2>7. Returns and Refunds</h2>
      <p>Due to health and safety regulations, certain products may not be returnable. Refund policies vary by product type and are subject to pharmacy regulations.</p>
      
      <h2>8. Regulatory Compliance</h2>
      <p>All products comply with Moroccan health and safety regulations. Partner pharmacies are licensed and regulated by appropriate authorities.</p>
      
      <p style="margin-top: 30px; color: #666; font-size: 14px;">Last updated: 2025</p>
    </div>
    ''';
  }

  String _getFoodTermsOfUse() {
    return '''
    <div style="padding: 20px; font-family: Arial, sans-serif; line-height: 1.6;">
      <h1 style="color: #7E57C2; margin-bottom: 20px;">Dinevio Food Terms of Use</h1>
      
      <h2>1. Service Description</h2>
      <p>Dinevio Food connects customers with restaurants and food establishments for food ordering and delivery services.</p>
      
      <h2>2. Menu and Pricing</h2>
      <p>Menu items and prices are set by partner restaurants and may differ from in-restaurant prices. Prices include applicable taxes and service fees.</p>
      
      <h2>3. Food Quality and Safety</h2>
      <p>Partner restaurants are responsible for food preparation and quality. Dinevio facilitates delivery but is not responsible for food quality, preparation, or safety standards of partner restaurants.</p>
      
      <h2>4. Allergen Information</h2>
      <p>Allergen information is provided by restaurants. Customers with food allergies should contact restaurants directly or exercise caution when ordering.</p>
      
      <h2>5. Delivery Times</h2>
      <p>Estimated delivery times are provided for guidance. Actual delivery times may vary based on restaurant preparation time, traffic, and weather conditions.</p>
      
      <h2>6. Order Modifications</h2>
      <p>Orders can be modified or cancelled within 2 minutes of placement. After this period, orders are sent to restaurants and cannot be modified.</p>
      
      <h2>7. Payment</h2>
      <p>Payment is processed at checkout. Accepted payment methods include cash on delivery, credit/debit cards, and mobile payment solutions.</p>
      
      <h2>8. Refunds and Complaints</h2>
      <p>Refund requests are handled on a case-by-case basis. Complaints about food quality should be reported immediately through the application.</p>
      
      <h2>9. Promotions and Discounts</h2>
      <p>Promotional offers and discounts are subject to terms and conditions. Dinevio reserves the right to modify or cancel promotions at any time.</p>
      
      <p style="margin-top: 30px; color: #666; font-size: 14px;">Last updated: 2025</p>
    </div>
    ''';
  }
}

