import 'package:customer/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:customer/app/modules/html_view_screen/views/html_view_screen_view.dart';
import 'package:customer/app/modules/language/views/language_view.dart';
import 'package:customer/app/modules/my_wallet/views/my_wallet_view.dart';
import 'package:customer/app/modules/payment_method/views/payment_method_view.dart';
import 'package:customer/app/modules/statement_screen/views/statement_view.dart';
import 'package:customer/app/modules/support_screen/views/support_screen_view.dart';
import 'package:customer/app/routes/app_pages.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/my_account_controller.dart';

class MyAccountView extends GetView<MyAccountController> {
  const MyAccountView({super.key});

  Color get _cardColor => const Color(0xFFF8F8F8);
  Color get _accent => const Color(0xFF7E3FF2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'My account',
          style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildProfileCompletionCard(),
              const SizedBox(height: 24),
              _sectionTitle('Explore'),
              const SizedBox(height: 8),
              _card([
                _tile(
                  icon: Icons.local_offer_outlined,
                  title: 'Promotions',
                  onTap: () => Get.toNamed(Routes.COUPON_SCREEN),
                ),
                _divider(),
                _tile(
                  icon: Icons.favorite_border_rounded,
                  title: 'Favorites',
                  onTap: () => Get.snackbar('Favorites', 'Coming soon'),
                ),
              ]),
              const SizedBox(height: 24),
              _sectionTitle('My account'),
              const SizedBox(height: 8),
              _card([
                _tile(
                  icon: Icons.person_outline,
                  title: 'Personal information',
                  subtitle: 'Complete your profile',
                  subtitleColor: Colors.red.shade400,
                  onTap: () => Get.to(const EditProfileView()),
                ),
                _divider(),
                _tile(
                  svg: "assets/icon/ic_my_wallet.svg",
                  title: 'Wallet',
                  onTap: () => Get.to(const MyWalletView()),
                ),
                _divider(),
                _tile(
                  icon: Icons.credit_card_outlined,
                  title: 'Payment methods',
                  onTap: () => Get.to(const PaymentMethodView(index: 0)),
                ),
                _divider(),
                _tile(
                  icon: Icons.history_toggle_off_rounded,
                  title: 'Activity',
                  onTap: () => Get.to(const StatementView()),
                ),
                _divider(),
                _tile(
                  icon: Icons.location_on_outlined,
                  title: 'Saved addresses',
                  onTap: () => Get.snackbar('Saved addresses', 'Coming soon'),
                ),
              ]),
              const SizedBox(height: 24),
              _sectionTitle('Additional'),
              const SizedBox(height: 8),
              _card([
                _tile(
                  svg: "assets/icon/ic_support.svg",
                  title: 'Support',
                  onTap: () => Get.to(const SupportScreenView()),
                ),
                _divider(),
                _tile(
                  icon: Icons.apartment_outlined,
                  title: 'Dinevio Business',
                  onTap: () => _launchUrl('https://www.dinevio.com'),
                ),
                _divider(),
                _tile(
                  icon: Icons.shield_outlined,
                  title: 'Data & Privacy',
                  onTap: () => Get.to(HtmlViewScreenView(title: "Privacy & Policy".tr, htmlData: Constant.privacyPolicy)),
                ),
                _divider(),
                _tile(
                  icon: Icons.public,
                  title: 'Language',
                  onTap: () => Get.to(const LanguageView()),
                ),
              ]),
              const SizedBox(height: 12),
              _card([
                _tile(
                  icon: Icons.logout,
                  title: 'Logout',
                  titleColor: AppThemData.error07,
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Get.offAllNamed(Routes.LOGIN);
                  },
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      controller.name.value.isNotEmpty ? controller.name.value : 'Demo',
                      style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.star, color: AppThemData.success07, size: 20),
                  Text(
                    controller.rating.value.toStringAsFixed(1),
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              const SizedBox(height: 4),
              Text(
                controller.phone.value,
                style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 28,
          backgroundColor: _accent,
          backgroundImage: controller.profilePic.value.isNotEmpty ? NetworkImage(controller.profilePic.value) : null,
          child: controller.profilePic.value.isEmpty
              ? Text(
                  controller.name.value.isNotEmpty ? controller.name.value.characters.first.toUpperCase() : 'D',
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                )
              : null,
        )
      ],
    );
  }

  Widget _buildProfileCompletionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'D',
                    style: GoogleFonts.inter(color: _accent, fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${(controller.profileCompletion.value * 100).round()}%',
                    style: GoogleFonts.inter(color: _accent, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Complete your profile', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  'And get the most out of your account!',
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() {
    return Divider(height: 1, color: Colors.grey.shade300, indent: 16, endIndent: 16);
  }

  Widget _tile({
    String? svg,
    IconData? icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    Color? subtitleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: svg != null
          ? SvgPicture.asset(
              svg,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.srcIn),
            )
          : Icon(icon, size: 24, color: Colors.black87),
      title: Text(
        title,
        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: titleColor ?? Colors.black),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.inter(fontSize: 14, color: subtitleColor ?? Colors.grey[700]),
            )
          : null,
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.black45),
      onTap: onTap,
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Unavailable', 'Cannot open $url');
    }
  }
}

