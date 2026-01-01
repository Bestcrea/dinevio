// ignore_for_file: use_build_context_synchronously
import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:customer/app/modules/support_screen/views/support_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../controllers/profile_screen_controller.dart';
import 'widgets/activity_empty_state_view.dart';
import 'widgets/favorites_empty_state_view.dart';
import 'widgets/promotions_empty_state_view.dart';
import 'widgets/saved_addresses_empty_state_view.dart';
import 'widgets/shimmer_widgets.dart';

/// Animated settings button with translucent background and tap feedback
class _AnimatedSettingsButton extends StatefulWidget {
  final VoidCallback onTap;

  const _AnimatedSettingsButton({required this.onTap});

  @override
  State<_AnimatedSettingsButton> createState() => _AnimatedSettingsButtonState();
}

class _AnimatedSettingsButtonState extends State<_AnimatedSettingsButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15), // Translucent circular background
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 22, // Icon size 22-24 (using 22)
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Animated quick action card with micro tap feedback (scale to 0.96 for 120ms)
class _AnimatedQuickActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AnimatedQuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_AnimatedQuickActionCard> createState() => _AnimatedQuickActionCardState();
}

class _AnimatedQuickActionCardState extends State<_AnimatedQuickActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120), // 120ms as specified
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              // Same width/height for perfect alignment: fixed height ensures consistency
              height: 100, // Fixed height for perfect alignment across all 3 cards
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA), // Very light purple/near-white background
                borderRadius: BorderRadius.circular(18), // BorderRadius: 18
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06), // Extremely subtle: opacity <= 0.06
                    blurRadius: 14, // Blur ~14
                    offset: const Offset(0, 6), // Offset 0,6
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: 24, // Icon size 24
                    color: const Color(0xFF7E57C2), // Primary purple
                  ),
                  const SizedBox(height: 8), // Consistent spacing
                  Text(
                    widget.label,
                    style: GoogleFonts.inter(
                      fontSize: 13, // Label: 12-13 (using 13)
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A), // Dark text
                      height: 1.2, // Standardized line-height
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProfileScreenView extends GetView<ProfileScreenController> {
  const ProfileScreenView({super.key});

  // Dinevio brand colors (reference-based)
  static const Color _primaryPurple = Color(0xFF7E57C2); // App primary purple
  static const Color _lightPurple = Color(0xFFF5F0FF);
  static const Color _lightOrange = Color(0xFFFFE5D9);
  static const Color _darkText = Color(0xFF1A1A1A);
  static const Color _greyText = Color(0xFF757575);
  static const Color _cardBackground = Color(0xFFFAFAFA);

  // Design system constants
  static const double _containerRadius = 22.0; // Main container border radius
  static const double _pillRadius = 999.0; // Pills border radius (circular)
  static const double _rowHeight = 54.0; // Menu item row height
  static const double _iconSize = 22.0; // Icon size (22-24 range)
  
  // Unified spacing system: 8/12/16/24
  static const double _spacing8 = 8.0;
  static const double _spacing12 = 12.0;
  static const double _spacing16 = 16.0;
  static const double _spacing24 = 24.0;
  
  // Subtle shadow system
  static BoxShadow get _subtleShadow => BoxShadow(
    color: Colors.black.withOpacity(0.08),
    blurRadius: 14,
    offset: const Offset(0, 6),
  );
  
  // Very subtle shadow for avatar
  static BoxShadow get _avatarShadow => BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileScreenController>(
      init: ProfileScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Obx(
              () => CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Header with gradient (shimmer or real)
                  controller.isLoading.value
                      ? const SliverToBoxAdapter(child: ShimmerHeader())
                      : _buildHeader(context, controller),
                  
                  // Quick action cards (shimmer or real)
                  SliverToBoxAdapter(
                    child: controller.isLoading.value
                        ? const ShimmerQuickActionCards()
                        : _buildQuickActionCards(context),
                  ),
                  
                  // Main menu card (shimmer or real)
                  SliverToBoxAdapter(
                    child: controller.isLoading.value
                        ? const ShimmerMenuCard()
                        : _buildMainMenuCard(context, controller),
                  ),
                  
                  // Bottom section with app info
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildBottomSection(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Header section with premium purple gradient
  Widget _buildHeader(BuildContext context, ProfileScreenController controller) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          // Premium deeper gradient: diagonal direction with refined stops for 3D depth
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.3, 0.6, 1.0],
            colors: [
              _primaryPurple,
              _primaryPurple.withOpacity(0.98),
              _primaryPurple.withOpacity(0.92),
              _primaryPurple.withOpacity(0.88),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(_spacing16, 20, _spacing16, _spacing24),
          child: Column(
            children: [
              // Top row: Settings icon with translucent background and tap animation
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _AnimatedSettingsButton(
                    onTap: () {
                      Get.toNamed('/settings');
                    },
                  ),
                ],
              ),
              SizedBox(height: _spacing16),
              
              // Profile section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar with completion badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Avatar circle: 60px with 2px white border and very subtle shadow
                      Container(
                        width: 60, // Avatar size: 60px (premium look)
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2, // 2px white border
                          ),
                          boxShadow: [_avatarShadow], // Very subtle shadow
                        ),
                        child: controller.profilePic.value.isNotEmpty
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: controller.profilePic.value,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      _buildAvatarFallback(controller),
                                ),
                              )
                            : _buildAvatarFallback(controller),
                      ),
                      // Completion indicator: thin circular progress ring (only if logged in)
                      if (!controller.isGuest.value && controller.profileCompletion.value > 0)
                        Positioned.fill(
                          child: CircularProgressIndicator(
                            value: controller.profileCompletion.value,
                            strokeWidth: 2.5, // Thin ring
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: _spacing16),
                  
                  // Name, rating, phone
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name with rating badge
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                controller.name.value,
                                style: GoogleFonts.inter(
                                  fontSize: 20, // Title: 18-20 semi-bold (using 20)
                                  fontWeight: FontWeight.w600, // Semi-bold
                                  color: Colors.white,
                                  height: 1.2, // Standardized line-height
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: _spacing8),
                            // Rating badge: small pill with star icon
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(_pillRadius),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 14, // Smaller star for pill badge
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    controller.rating.value.toStringAsFixed(1),
                                    style: GoogleFonts.inter(
                                      fontSize: 13, // Smaller text for pill
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      height: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: _spacing8),
                        // Phone number (only show if not guest and has phone)
                        if (!controller.isGuest.value && controller.phone.value.isNotEmpty)
                          Text(
                            controller.phone.value,
                            style: GoogleFonts.inter(
                              fontSize: 15, // Subtext: 12-13 regular grey (using 15 for phone)
                              fontWeight: FontWeight.w400, // Regular
                              color: Colors.white.withOpacity(0.9),
                              height: 1.4, // Standardized line-height
                            ),
                          )
                        else if (controller.isGuest.value)
                          Text(
                            'Sign in to access your profile',
                            style: GoogleFonts.inter(
                              fontSize: 13, // Subtext: 12-13 regular
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.7),
                              height: 1.4,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Avatar fallback with initial letter
  Widget _buildAvatarFallback(ProfileScreenController controller) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          controller.userInitial,
          style: GoogleFonts.inter(
            fontSize: 24, // Adjusted for 60px avatar (was 32 for 80px)
            fontWeight: FontWeight.w800,
            color: _primaryPurple,
          ),
        ),
      ),
    );
  }

  /// Quick action cards (Activity, Promotions, My addresses)
  Widget _buildQuickActionCards(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(_spacing16, 20, _spacing16, _spacing24),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionCard(
              context: context,
              icon: Icons.history_outlined,
              label: 'Activity',
              onTap: () => Get.to(() => const ActivityEmptyStateView()),
            ),
          ),
          SizedBox(width: _spacing12),
          Expanded(
            child: _buildQuickActionCard(
              context: context,
              icon: Icons.local_offer_outlined,
              label: 'Promotions',
              onTap: () => Get.to(() => const PromotionsEmptyStateView()),
            ),
          ),
          SizedBox(width: _spacing12),
          Expanded(
            child: _buildQuickActionCard(
              context: context,
              icon: Icons.location_on_outlined,
              label: 'My addresses',
              onTap: () => Get.to(() => const SavedAddressesEmptyStateView()),
            ),
          ),
        ],
      ),
    );
  }

  /// Individual quick action card with micro tap feedback
  Widget _buildQuickActionCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return _AnimatedQuickActionCard(
      icon: icon,
      label: label,
      onTap: onTap,
    );
  }

  /// Main menu card with menu items
  Widget _buildMainMenuCard(
    BuildContext context,
    ProfileScreenController controller,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _spacing16),
      child: Container(
        decoration: BoxDecoration(
          color: _cardBackground,
          borderRadius: BorderRadius.circular(_containerRadius),
          boxShadow: [_subtleShadow],
        ),
        child: Column(
          children: [
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'Personal information',
              badge: 'Missing details',
              badgeColor: _lightOrange,
              badgeTextColor: const Color(0xFFE65100),
              onTap: () => Get.toNamed('/personal-info'),
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.credit_card_outlined,
              title: 'Payment methods',
              onTap: () => Get.toNamed('/wallet'),
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.favorite_border,
              title: 'Favorites',
              onTap: () => Get.to(() => const FavoritesEmptyStateView()),
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.headset_mic_outlined,
              title: 'Support',
              onTap: () => Get.to(() => const SupportScreenView()),
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.business_outlined,
              title: 'Dinevio Business',
              onTap: () {
                Get.snackbar(
                  'Dinevio Business',
                  'Coming soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Menu item widget
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? badge,
    Color? badgeColor,
    Color? badgeTextColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: _rowHeight,
          padding: EdgeInsets.symmetric(horizontal: _spacing16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _lightPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: _iconSize,
                  color: _primaryPurple,
                ),
              ),
              SizedBox(width: _spacing16),
              // Title and badge
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16, // Row text: 15-16 medium (using 16)
                        fontWeight: FontWeight.w500, // Medium
                        color: _darkText,
                        height: 1.2, // Standardized line-height
                      ),
                    ),
                    if (badge != null) ...[
                      SizedBox(height: _spacing8 / 2), // 4px spacing
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10, // Padding 6x10 as specified
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor ?? _lightOrange,
                          borderRadius: BorderRadius.circular(_pillRadius), // Pill radius 999
                        ),
                        child: Text(
                          badge,
                          style: GoogleFonts.inter(
                            fontSize: 12, // Subtext: 12-13 regular
                            fontWeight: FontWeight.w600,
                            color: badgeTextColor ?? const Color(0xFFE65100),
                            height: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Arrow - perfectly aligned to the right
              SizedBox(width: _spacing8),
              const Icon(
                Icons.chevron_right,
                color: _greyText,
                size: _iconSize + 2, // 24px
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Divider between menu items - very light with low opacity
  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _spacing16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey.shade200.withOpacity(0.5), // Very light with low opacity
      ),
    );
  }

  /// Bottom section with app name and version
  Widget _buildBottomSection(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version = snapshot.data?.version ?? '1.0.0';
        return Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Dinevio',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _greyText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Version $version',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: _greyText.withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

