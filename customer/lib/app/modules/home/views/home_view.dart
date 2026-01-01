// ignore_for_file: must_be_immutable, deprecated_member_use, use_build_context_synchronously
import 'package:customer/app/modules/book_parcel/views/book_parcel_view.dart';
import 'package:customer/app/modules/cab_rides/views/cab_ride_view.dart';
// Drawer removed - using ProfileScreen instead
import 'package:customer/app/routes/app_pages.dart';
import 'package:customer/app/modules/html_view_screen/views/html_view_screen_view.dart';
import 'package:customer/app/modules/intercity_rides/views/intercity_rides_view.dart';
import 'package:customer/app/modules/language/views/language_view.dart';
import 'package:customer/app/modules/my_wallet/views/my_wallet_view.dart';
import 'package:customer/app/modules/parcel_rides/views/parcel_rides_view.dart';
import 'package:customer/app/modules/select_location/views/select_location_view.dart';
import 'package:customer/app/modules/statement_screen/views/statement_view.dart';
import 'package:customer/app/modules/support_screen/views/support_screen_view.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/features/grocery/presentation/pages/grocery_home_page.dart';
import 'package:customer/features/para/presentation/pages/para_marketplace_page.dart';
import 'package:customer/app/intercity/intercity_flow_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/home_controller.dart';

/// Animated logo widget with fade and slide animation
/// Animates once when the widget appears
class _AnimatedLogo extends StatefulWidget {
  const _AnimatedLogo();

  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    // Duration: 280ms, runs once
    _controller = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );

    // Fade animation: 0 → 1
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // Slide animation: -8px up → 0
    // Using a relative offset that approximates -8px for typical logo sizes
    // For a 28px logo, -8px ≈ -0.29 relative offset
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.29), // Approximately -8px for typical logo sizes
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // Start animation when widget appears
    // Using post-frame callback to ensure layout is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textScaleFactor = MediaQuery.textScaleFactorOf(context);
    
    // Responsive logo height: 24-32px based on screen size
    // For small screens (< 360px): 24px
    // For medium screens (360-480px): 28px
    // For large screens (> 480px): 32px
    double baseHeight;
    if (screenWidth < 360) {
      baseHeight = 24.0; // Small phones
    } else if (screenWidth <= 480) {
      baseHeight = 28.0; // Medium phones
    } else {
      baseHeight = 32.0; // Large phones/tablets
    }
    
    // Adjust for text scaling to prevent overflow on small screens
    if (textScaleFactor > 1.2 && screenWidth < 360) {
      baseHeight = (baseHeight / textScaleFactor).clamp(22.0, 32.0);
    }
    
    final logoHeight = baseHeight;
    
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Text(
            'Dinevio',
            style: GoogleFonts.inter(
              fontSize: 22, // Fixed size for consistency
              fontWeight: FontWeight.w700, // Bold
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated menu icon widget with premium tap feedback
/// Provides scale + opacity animation on tap
class _AnimatedMenuIcon extends StatefulWidget {
  final VoidCallback onTap;

  const _AnimatedMenuIcon({required this.onTap});

  @override
  State<_AnimatedMenuIcon> createState() => _AnimatedMenuIconState();
}

class _AnimatedMenuIconState extends State<_AnimatedMenuIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    // Duration: 140ms for quick, responsive feedback
    _controller = AnimationController(
      duration: const Duration(milliseconds: 140),
      vsync: this,
    );

    // Scale animation: 1 → 0.92 → 1
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.92),
        weight: 50, // First half: scale down
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.92, end: 1.0),
        weight: 50, // Second half: scale back up
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Opacity animation: 1 → 0.85 → 1
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.85),
        weight: 50, // First half: fade out
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 1.0),
        weight: 50, // Second half: fade back in
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Start animation from beginning
    _controller.forward(from: 0.0);
    
    // Open drawer after animation completes
    // Using a one-time listener for precise timing
    void statusListener(AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _controller.removeStatusListener(statusListener);
        widget.onTap();
      }
    }
    
    _controller.addStatusListener(statusListener);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          // Combine AnimatedScale and AnimatedOpacity for smooth effect
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: themeChange.isDarkTheme()
                  ? Color(0xff1D1D21)
                  : AppThemData.grey50,
              extendBody: true,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(110),
                child: SafeArea(
                  top: true,
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: AppThemData.black,
                    elevation: 0,
                    toolbarHeight: 110,
                    // Minimum height for AppBar: 56-64px (toolbarHeight handles this)
                    titleSpacing: 0, // Remove default spacing to control manually
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Header row: Logo + Menu
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Logo section - Left side with premium animation
                            const _AnimatedLogo(),
                            // Menu button - Right side with premium tap animation
                            // Navigates to ProfileScreen (full page menu)
                            _AnimatedMenuIcon(
                              onTap: () => Get.toNamed(Routes.PROFILE_SCREEN),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Location row
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Row(
                            children: [
                              const Icon(Icons.place_outlined,
                                  color: Colors.white70, size: 18),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Current location is not .....',
                                  style: GoogleFonts.inter(
                                    color: AppThemData.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    shape: Border(
                        bottom: BorderSide(color: AppThemData.grey900, width: 1)),
                  ),
                ),
              ),
              // Drawer removed - menu icon navigates to ProfileScreen
              body: Obx(() => controller.drawerIndex.value == 1
                  ? const CabRideView()
                  : controller.drawerIndex.value == 2
                      ? const MyWalletView()
                      : controller.drawerIndex.value == 3
                          ? const SupportScreenView()
                          : controller.drawerIndex.value == 4
                              ? HtmlViewScreenView(
                                  title: "Privacy & Policy".tr,
                                  htmlData: Constant.privacyPolicy)
                              : controller.drawerIndex.value == 5
                                  ? HtmlViewScreenView(
                                      title: "Terms & Condition".tr,
                                      htmlData: Constant.termsAndConditions)
                                  : controller.drawerIndex.value == 6
                                      ? const LanguageView()
                                      : controller.drawerIndex.value == 0
                                          ? HomeScreenView()
                                          : controller.drawerIndex.value == 7
                                              ? InterCityRidesView()
                                              : controller.drawerIndex.value ==
                                                      8
                                                  ? ParcelRidesView()
                                                  : StatementView()));
        });
  }
}

class ServicesSection extends StatelessWidget {
  ServicesSection({super.key, required this.themeChange});

  final DarkThemeProvider themeChange;

  final List<_ServiceCardItem> services = const [
    _ServiceCardItem(
      title: "Rides",
      icon: Icons.local_taxi_rounded,
      imagePath: null,
      colors: [Color(0xFFFCE1C9), Color(0xFFF9D2BA)],
    ),
    _ServiceCardItem(
      title: "Food",
      icon: Icons.restaurant_menu_rounded,
      imagePath: null,
      colors: [Color(0xFFE7F2FF), Color(0xFFD8E9FF)],
    ),
    _ServiceCardItem(
      title: "Grocery",
      icon: Icons.shopping_basket_rounded,
      imagePath: "assets/service/grocery_service.png",
      colors: [Color(0xFFFFF6E5), Color(0xFFFEEBD8)],
    ),
    _ServiceCardItem(
      title: "Intercity",
      icon: Icons.alt_route_rounded,
      imagePath: null,
      colors: [Color(0xFFE7FFF3), Color(0xFFDCF7EA)],
    ),
    _ServiceCardItem(
      title: "Parcel",
      icon: Icons.local_shipping_rounded,
      imagePath: null,
      colors: [Color(0xFFF8E7FF), Color(0xFFEFD9FF)],
    ),
    _ServiceCardItem(
      title: "Parapharmacie",
      icon: Icons.medical_services_rounded,
      imagePath: "assets/service/para_service.png",
      colors: [Color(0xFFEFF4FF), Color(0xFFE0E9FF)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore Our Services'.tr,
          style: GoogleFonts.inter(
            color: themeChange.isDarkTheme()
                ? AppThemData.grey25
                : AppThemData.grey950,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.92,
          ),
          itemBuilder: (context, index) {
            final item = services[index];
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: item.colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.35,
                    child: item.imagePath != null
                        ? Image.asset(
                            item.imagePath!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                            color: (themeChange.isDarkTheme()
                                    ? AppThemData.grey200
                                    : AppThemData.grey900)
                                .withOpacity(0.9),
                            colorBlendMode: BlendMode.srcIn,
                          )
                        : Icon(
                            item.icon,
                            size: 56,
                            color: themeChange.isDarkTheme()
                                ? AppThemData.grey200
                                : AppThemData.grey900,
                          ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        item.title.tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: themeChange.isDarkTheme()
                              ? AppThemData.grey25
                              : AppThemData.grey950,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _OfferItem {
  final String title;
  final String subtitle;
  final String imagePath;
  final String? badge;

  const _OfferItem({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.badge,
  });
}

class _ServiceCardItem {
  final String title;
  final IconData icon;
  final String? imagePath;
  final List<Color> colors;

  const _ServiceCardItem({
    required this.title,
    required this.icon,
    this.imagePath,
    required this.colors,
  });
}

class HomeScreenView extends StatelessWidget {
  HomeScreenView({
    super.key,
  });

  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Obx(
      () => controller.isLoading.value
          ? Constant.loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // HEADER → OUR SERVICES → BANNERS → OUR BEST SPOTS
                    ServicesSectionNew(themeChange: themeChange),
                    const SizedBox(height: 20),
                    BannerCarousel(),
                    const SizedBox(height: 20),
                    BestSpotsSection(),
                  ],
                ),
              ),
            ),
    );
  }
}

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _controller = PageController();
  int _current = 0;

  final List<_BannerItem> banners = const [
    _BannerItem(imagePath: "assets/banner/food.jpg", tag: "Food"),
    _BannerItem(imagePath: "assets/banner/taxi.jpg", tag: "Rides"),
    _BannerItem(imagePath: "assets/banner/parcel.jpg", tag: "Parcel"),
  ];

  void _handleTap(String tag) {
    switch (tag) {
      case "Rides":
        Get.to(const SelectLocationView());
        break;
      case "Food":
        Get.toNamed(Routes.FOOD);
        break;
      case "Parcel":
        Get.to(const BookParcelView());
        break;
      default:
        Get.snackbar('Coming soon', '$tag service will open here');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _controller,
            itemCount: banners.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, index) {
              final banner = banners[index];
              return GestureDetector(
                onTap: () => _handleTap(banner.tag),
                child: Material(
                  type: MaterialType.transparency,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        banner.imagePath,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 220,
                            color: Colors.grey.shade300,
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 48,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _current == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _current == index
                    ? AppThemData.primary500
                    : AppThemData.grey200,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BannerItem {
  final String imagePath;
  final String tag;

  const _BannerItem({required this.imagePath, required this.tag});
}

class ServicesSectionNew extends StatelessWidget {
  ServicesSectionNew({super.key, required this.themeChange});

  final DarkThemeProvider themeChange;

  final List<_ServiceCardItemNew> services = [
    _ServiceCardItemNew(
      title: "Rides",
      imagePath: "assets/service/rides_service.png",
      gradient: const [Color(0xFFe0d4ff), Color(0xFFc2b2ff)],
      onTap: () => Get.to(const SelectLocationView()),
    ),
    _ServiceCardItemNew(
      title: "Food",
      imagePath: "assets/service/food_service.png",
      gradient: const [Color(0xFFffe0c5), Color(0xFFffcaa1)],
      onTap: () => Get.toNamed(Routes.FOOD),
    ),
    _ServiceCardItemNew(
      title: "Grocery",
      imagePath: "assets/service/grocery_service.png",
      gradient: const [Color(0xFFcdffd8), Color(0xFF94b9ff)],
      onTap: () => Get.to(const GroceryHomePage()),
    ),
    _ServiceCardItemNew(
      title: "Parcel",
      imagePath: "assets/service/parcel_service.png",
      gradient: const [Color(0xFFffe6cc), Color(0xFFffd4a3)],
      onTap: () => Get.to(const BookParcelView()),
    ),
    _ServiceCardItemNew(
      title: "Intercity",
      imagePath: "assets/service/intercity_service.png",
      gradient: const [Color(0xFFd6f4eb), Color(0xFFbce8da)],
      onTap: () => Get.to(const IntercityFlowPage()),
    ),
    _ServiceCardItemNew(
      title: "Para",
      imagePath: "assets/service/para_service.png",
      gradient: const [Color(0xFFff3131), Color(0xFFff914d)],
      onTap: () => Get.to(const ParaMarketplacePage()),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Services'.tr,
          style: GoogleFonts.inter(
            color: themeChange.isDarkTheme()
                ? AppThemData.grey25
                : AppThemData.grey950,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final item = services[index];
            return InkWell(
              onTap: item.onTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: item.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 12,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          item.title.tr,
                          style: GoogleFonts.inter(
                            color: AppThemData.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Image.asset(
                        item.imagePath,
                        height: 72,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ServiceCardItemNew {
  final String title;
  final String imagePath;
  final List<Color> gradient;
  final VoidCallback onTap;

  _ServiceCardItemNew({
    required this.title,
    required this.imagePath,
    required this.gradient,
    required this.onTap,
  });
}

class BestSpotsSection extends StatefulWidget {
  const BestSpotsSection({super.key});

  @override
  State<BestSpotsSection> createState() => _BestSpotsSectionState();
}

class _BestSpotsSectionState extends State<BestSpotsSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> spots = const [
    "assets/purple/burgerking.jpg",
    "assets/purple/dominos.jpg",
    "assets/purple/kfc.jpg",
    "assets/purple/pasticio.jpg",
    "assets/purple/starbucks.jpg",
    "assets/purple/tacosdenice.jpg",
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - 32; // Full width minus padding (16*2)

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our best offers',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.1,
            color: AppThemData.grey950,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: spots.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final img = spots[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () =>
                      Get.snackbar('Restaurant', 'Opens registered restaurant'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      img,
                      width: cardWidth,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: cardWidth,
                          height: 180,
                          color: Colors.grey.shade300,
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            spots.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppThemData.primary500
                    : AppThemData.grey200,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SuggestionWidget extends StatelessWidget {
  const SuggestionWidget({
    super.key,
    required this.themeChange,
    required this.title,
    required this.gifPath,
    required this.onClick,
  });

  final DarkThemeProvider themeChange;
  final String title;
  final String gifPath;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: (Responsive.width(100, context) - 52) / 3,
        // width: 100,
        height: ((Responsive.width(100, context) - 21) / 3) - 4,
        // margin: EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(8),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color:
              themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1,
                color: themeChange.isDarkTheme()
                    ? AppThemData.grey900
                    : AppThemData.grey50),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(gifPath),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: themeChange.isDarkTheme()
                    ? AppThemData.grey25
                    : AppThemData.grey950,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BannerView extends StatelessWidget {
  BannerView({
    super.key,
  });

  HomeController controller = Get.put(HomeController());
  final List<_OfferItem> offers = const [
    _OfferItem(
      title: "Food",
      subtitle: "Vos plats préférés livrés simplement.",
      imagePath: "assets/banner/food.jpg",
      badge: "New",
    ),
    _OfferItem(
      title: "Rides",
      subtitle: "Déplacez-vous avec Dinevio en toute sérénité.",
      imagePath: "assets/banner/taxi.jpg",
    ),
    _OfferItem(
      title: "Parcel",
      subtitle: "Envoyez vos colis rapidement et facilement.",
      imagePath: "assets/banner/parcel.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Responsive.height(22, context),
            child: PageView.builder(
              itemCount: offers.length,
              controller: controller.pageController,
              onPageChanged: (value) {
                controller.curPage.value = value;
              },
              itemBuilder: (context, index) {
                final offer = offers[index];
                return Container(
                  width: Responsive.width(100, context),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                        image: AssetImage(offer.imagePath), fit: BoxFit.cover),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Container(
                    width: Responsive.width(100, context),
                    padding: const EdgeInsets.fromLTRB(16, 16, 20, 16),
                    decoration: ShapeDecoration(
                      color: AppThemData.black.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.title,
                          style: GoogleFonts.inter(
                            color: AppThemData.grey50,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          width: Responsive.width(100, context),
                          margin: const EdgeInsets.only(top: 6, bottom: 6),
                          child: Text(
                            offer.subtitle,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: AppThemData.grey50,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (offer.badge != null)
                          Text(
                            offer.badge!,
                            style: GoogleFonts.inter(
                              color: AppThemData.primary500,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: SizedBox(
              height: 8,
              child: ListView.builder(
                itemCount: offers.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Obx(
                    () => Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == controller.curPage.value
                            ? AppThemData.primary500
                            : AppThemData.grey200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
