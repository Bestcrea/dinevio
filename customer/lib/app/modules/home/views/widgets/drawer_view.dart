// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, deprecated_member_use

import 'package:customer/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:customer/app/modules/home/controllers/home_controller.dart';
import 'package:customer/app/modules/html_view_screen/views/html_view_screen_view.dart';
import 'package:customer/app/modules/login/views/login_view.dart';
import 'package:customer/app/modules/my_wallet/views/my_wallet_view.dart';
import 'package:customer/app/modules/payment_method/views/payment_method_view.dart';
import 'package:customer/app/modules/statement_screen/views/statement_view.dart';
import 'package:customer/app/modules/support_screen/views/support_screen_view.dart';
import 'package:customer/app/modules/language/views/language_view.dart';
import 'package:customer/app/routes/app_pages.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/custom_dialog_box.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  // Design System Colors - Exact match from reference
  static const Color _primaryViolet = Color(0xFFCC99FF);
  static const Color _lightGrey = Color(0xFFF5F5F5);
  static const Color _greenStar = Color(0xFF4CAF50);
  static const Color _redDestructive = Color(0xFFE53935);
  static const Color _greyText = Color(0xFF757575);
  static const Color _greyDivider = Color(0xFFE0E0E0);

  // Design System Constants
  static const double _spacingUnit = 8.0;
  static const double _cardRadius = 14.0;
  static const double _iconSize = 24.0;
  static const double _minTouchTarget = 44.0;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: HomeController(),
      builder: (controller) {
        return Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            children: [
              // Header Section
              _buildHeader(context, controller),
              
              SizedBox(height: _spacingUnit * 2), // 16px
              
              // Profile Banner
              _buildProfileBanner(context, controller),
              
              SizedBox(height: _spacingUnit * 3), // 24px
              
              // Explore Section
              _buildSectionTitle('Explore'),
              SizedBox(height: _spacingUnit),
              _buildSectionCard([
                _buildMenuItem(
                  icon: Icons.local_offer_outlined,
                  title: 'Promotions',
                  onTap: () => _handleNavigation(() {
                    Get.toNamed(Routes.COUPON_SCREEN);
                  }),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.star_border_outlined,
                  title: 'Favorites',
                  onTap: () => _handleNavigation(() {
                    Get.snackbar('Favorites', 'Coming soon');
                  }),
                ),
              ]),
              
              SizedBox(height: _spacingUnit * 3), // 24px
              
              // My Account Section
              _buildSectionTitle('My account'),
              SizedBox(height: _spacingUnit),
              _buildSectionCard([
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Personal information',
                  subtitle: 'Complete your profile •',
                  subtitleColor: _redDestructive,
                  onTap: () => _handleNavigation(() {
                    Get.to(const EditProfileView());
                  }),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Wallet',
                  onTap: () => _handleNavigation(() {
                    Get.to(const MyWalletView());
                  }),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.credit_card_outlined,
                  title: 'Payment methods',
                  onTap: () => _handleNavigation(() {
                    Get.to(const PaymentMethodView(index: 0));
                  }),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.history_outlined,
                  title: 'Activity',
                  onTap: () => _handleNavigation(() {
                    Get.to(const StatementView());
                  }),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.location_on_outlined,
                  title: 'Saved addresses',
                  onTap: () => _handleNavigation(() {
                    Get.snackbar('Saved addresses', 'Coming soon');
                  }),
                ),
              ]),
              
              SizedBox(height: _spacingUnit * 3), // 24px
              
              // Additional Section
              _buildSectionTitle('Additional'),
              SizedBox(height: _spacingUnit),
              _buildSectionCard([
                _buildMenuItem(
                  icon: Icons.headset_mic_outlined,
                  title: 'Support',
                  onTap: () => _handleNavigation(() {
                    Get.to(const SupportScreenView());
                  }),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.business_outlined,
                  title: 'Dinevio Business',
                  onTap: () => _handleNavigation(() {
                    Get.snackbar('Dinevio Business', 'Coming soon');
                  }),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.shield_outlined,
                  title: 'Data & Privacy',
                  onTap: () => _handleNavigation(() {
                    Get.to(HtmlViewScreenView(
                      title: "Privacy & Policy".tr,
                      htmlData: Constant.privacyPolicy.isNotEmpty
                          ? Constant.privacyPolicy
                          : "<h1>Privacy & Policy</h1><p>Content coming soon...</p>",
                    ));
                  }),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  onTap: () => _handleNavigation(() {
                    Get.to(const LanguageView());
                  }),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  titleColor: _redDestructive,
                  iconColor: _redDestructive,
                  onTap: () => _handleLogout(context, themeChange),
                ),
              ]),
              
              SizedBox(height: _spacingUnit * 3), // 24px
            ],
          ),
        );
      },
    );
  }

  // Helper method for navigation with drawer close
  void _handleNavigation(VoidCallback action) {
    Get.back();
    Future.delayed(const Duration(milliseconds: 200), action);
  }

  // Header with back arrow, name, star rating, phone, avatar
  Widget _buildHeader(BuildContext context, HomeController controller) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + _spacingUnit * 2,
        bottom: _spacingUnit * 2.5,
        left: _spacingUnit * 2,
        right: _spacingUnit * 2,
      ),
      child: Obx(
        () => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back arrow button
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ),
            ),
            SizedBox(width: _spacingUnit),
            // Name and info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        controller.name.value.isNotEmpty
                            ? controller.name.value
                            : 'Demo',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(width: _spacingUnit),
                      // Green star with rating
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: _greenStar,
                            size: 18,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '5.0',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: _spacingUnit * 0.5),
                  Text(
                    controller.phoneNumber.value.isNotEmpty
                        ? controller.phoneNumber.value
                        : '+212 1234567890',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: _greyText,
                    ),
                  ),
                ],
              ),
            ),
            // Purple avatar with initial
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _primaryViolet,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _primaryViolet.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  controller.name.value.isNotEmpty
                      ? controller.name.value[0].toUpperCase()
                      : 'D',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Profile completion banner
  Widget _buildProfileBanner(BuildContext context, HomeController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: _spacingUnit * 2),
      decoration: BoxDecoration(
        color: _lightGrey,
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleNavigation(() {
            Get.to(const EditProfileView());
          }),
          borderRadius: BorderRadius.circular(_cardRadius),
          child: Padding(
            padding: EdgeInsets.all(_spacingUnit * 2),
            child: Row(
              children: [
                // Circular progress indicator with avatar
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: 0.4,
                        strokeWidth: 4,
                        valueColor: const AlwaysStoppedAnimation<Color>(_primaryViolet),
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _primaryViolet,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          controller.name.value.isNotEmpty
                              ? controller.name.value[0].toUpperCase()
                              : 'D',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: _spacingUnit * 1.5),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Complete your profile',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: _spacingUnit * 0.5),
                      Text(
                        'And get the most out of your account!',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: _greyText,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: _greyText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _spacingUnit * 2),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  // Section card container
  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: _spacingUnit * 2),
      decoration: BoxDecoration(
        color: _lightGrey,
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // Menu item with icon, title, subtitle, and arrow
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? subtitleColor,
    Color? titleColor,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: _minTouchTarget),
          padding: EdgeInsets.symmetric(
            horizontal: _spacingUnit * 2,
            vertical: _spacingUnit * 2,
          ),
          child: Row(
            children: [
              // Icon
              Icon(
                icon,
                color: iconColor ?? Colors.black,
                size: _iconSize,
              ),
              SizedBox(width: _spacingUnit * 2),
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: titleColor ?? Colors.black,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: _spacingUnit * 0.25),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: subtitleColor ?? _greyText,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Arrow
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: _greyText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Divider between menu items
  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.only(left: _spacingUnit * 7), // Icon + spacing
      child: Divider(
        height: 1,
        thickness: 1,
        color: _greyDivider,
      ),
    );
  }

  // Logout handler
  void _handleLogout(BuildContext context, DarkThemeProvider themeChange) {
    Get.back();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogBox(
          themeChange: themeChange,
          title: "Logout".tr,
          descriptions: "Are you sure you want to logout?".tr,
          positiveString: "Log out".tr,
          negativeString: "Cancel".tr,
          positiveClick: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pop(context);
            Get.offAll(const LoginView());
          },
          negativeClick: () {
            Navigator.pop(context);
          },
          img: const Icon(
            Icons.logout,
            color: _redDestructive,
            size: 40,
          ),
        );
      },
    );
  }
}
