import 'package:customer/app/models/restaurant_model.dart';
import 'package:customer/app/routes/app_pages.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/food_controller.dart';

class FoodView extends GetView<FoodController> {
  const FoodView({super.key});

  Color get _starColor => const Color(0xFFD6C08A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: _buildHeader(context),
              ),
            ),
            Obx(() {
              if (controller.loading.isTrue) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }),
            SliverToBoxAdapter(
              child: _buildChipRow(_categoryFilters),
            ),
            SliverToBoxAdapter(
              child: _buildCategoryIcons(),
            ),
            SliverToBoxAdapter(
              child: _buildChipRow(_filterChips),
            ),
            SliverToBoxAdapter(child: _sectionDivider()),
            SliverToBoxAdapter(
              child: _buildSection(
                title: 'Featured on Dinevio',
                child: Obx(() {
                  if (controller.featured.isNotEmpty) {
                    return _buildFeaturedSlider(controller.featured);
                  } else {
                    return _buildFeaturedSliderFromStoreItems(_featuredStores);
                  }
                }),
              ),
            ),
            SliverToBoxAdapter(child: _sectionDivider()),
            SliverToBoxAdapter(
              child: _buildSection(
                title: 'Top 10 local spots',
                child: Obx(() => _buildFeaturedSlider(controller.top10)),
              ),
            ),
            SliverToBoxAdapter(child: _sectionDivider()),
            SliverToBoxAdapter(
              child: _buildSection(
                title: 'Stores near you',
                child: Obx(() => _buildStoresSlider(controller.nearby)),
              ),
            ),
            SliverToBoxAdapter(child: _sectionDivider()),
            SliverToBoxAdapter(
              child: _buildSection(
                title: 'Domino’s pizza',
                child: _buildBannerSlider(_dominosBanners),
              ),
            ),
            SliverToBoxAdapter(child: _sectionDivider()),
            SliverToBoxAdapter(
              child: _buildSection(
                title: 'Top offers on items',
                child: _buildTopItemsSlider(_sampleMenu),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Get.toNamed(Routes.SELECT_LOCATION),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.place_outlined,
                              size: 18, color: Colors.black87),
                          const SizedBox(width: 6),
                          Text(
                            'Khémisset',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down,
                              size: 18, color: Colors.black87),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded,
                  color: Colors.black87, size: 26),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart_outlined,
                  color: Colors.black87, size: 26),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChipRow(List<_ChipItem> chips) {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final chip = chips[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: chip.isActive ? const Color(0xFFEFF3F8) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (chip.icon != null) ...[
                  Icon(chip.icon, size: 18, color: Colors.black87),
                  const SizedBox(width: 8),
                ],
                Text(
                  chip.label,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                if (chip.hasDropdown) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 18, color: Colors.black54),
                ],
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: chips.length,
      ),
    );
  }

  Widget _buildCategoryIcons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final textScaleFactor = MediaQuery.textScaleFactorOf(context);
        final itemWidth = (screenWidth * 0.22).clamp(70.0, 95.0);
        final iconSize = (screenWidth * 0.08).clamp(28.0, 40.0);
        
        // Measure actual text height using TextPainter
        final textStyle = GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
          height: 1.2,
        );
        final textPainter = TextPainter(
          text: TextSpan(
            text: 'Supermarket', // Longest expected label
            style: textStyle,
          ),
          textDirection: TextDirection.ltr,
          textScaleFactor: textScaleFactor,
          maxLines: 1,
        );
        textPainter.layout(maxWidth: itemWidth);
        final measuredTextHeight = textPainter.size.height;
        
        // Calculate item height with safety margins
        // Icon + spacing + text (measured) + extra padding for safety
        var baseHeight = iconSize + 12 + measuredTextHeight + 8;
        
        // Adjust for text scaling: add extra space if scaleFactor > 1.2
        if (textScaleFactor > 1.2) {
          final scaleAdjustment = ((textScaleFactor - 1.2) * 14).clamp(8.0, 20.0);
          baseHeight += scaleAdjustment;
        }
        
        final itemHeight = baseHeight.clamp(90.0, 130.0);
        
        return SizedBox(
          height: itemHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final item = _categories[index];
              return SizedBox(
                width: itemWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.hardEdge, // Prevent overflow
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          width: iconSize,
                          height: iconSize,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(iconSize * 0.14),
                            child: Image.asset(
                              item.imagePath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        if (item.badge != null)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: item.badgeColor ?? const Color(0xFF0DB473),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 18,
                              ),
                              child: Text(
                                item.badge!,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                                textScaleFactor: 1.0, // Prevent badge text scaling
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: Text(
                        item.title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: textStyle,
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemCount: _categories.length,
          ),
        );
      },
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade100,
                ),
                child: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildFeaturedSlider(List<RestaurantModel> items) {
    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => controller.openRestaurant(item),
            child: Container(
              width: 260,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(18)),
                    child: Stack(
                      children: [
                        Image.network(
                          item.coverImage,
                          width: 260,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.favorite_border,
                                color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                    child: Text(
                      item.name,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text(
                          '${item.etaMin}-${item.etaMax} min',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('•',
                            style: TextStyle(color: Colors.black45)),
                        const SizedBox(width: 6),
                        Icon(Icons.star_rounded, size: 18, color: _starColor),
                        const SizedBox(width: 4),
                        Text(
                          item.rating.toString(),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        padding: const EdgeInsets.only(left: 4, right: 4),
      ),
    );
  }

  Widget _buildFeaturedSliderFromStoreItems(List<_StoreItem> items) {
    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              Get.snackbar('Restaurant', '${item.title} details');
            },
            child: Container(
              width: 260,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(18)),
                    child: Stack(
                      children: [
                        Image.asset(
                          item.imagePath,
                          width: 260,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 260,
                              height: 150,
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
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.favorite_border,
                                color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                    child: Text(
                      item.title,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text(
                          item.meta.split('•')[1].trim(),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('•',
                            style: TextStyle(color: Colors.black45)),
                        const SizedBox(width: 6),
                        Icon(Icons.star_rounded, size: 18, color: _starColor),
                        const SizedBox(width: 4),
                        Text(
                          item.rating,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        padding: const EdgeInsets.only(left: 4, right: 4),
      ),
    );
  }

  Widget _buildStoresSlider(List<RestaurantModel> stores) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 4, right: 4),
        itemBuilder: (context, index) {
          final item = stores[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                    child: Image.network(item.brandLogo, fit: BoxFit.cover)),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 100,
                child: Text(
                  item.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${item.etaMin}-${item.etaMax} min',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemCount: stores.length,
      ),
    );
  }

  Widget _buildBannerSlider(List<_BannerCard> banners) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(banner.imagePath, fit: BoxFit.cover),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        banner.title,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopItemsSlider(List<_MenuItem> items) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        padding: const EdgeInsets.only(left: 4, right: 4),
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                  child: Stack(
                    children: [
                      Image.asset(
                        item.imagePath,
                        width: 220,
                        height: 140,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 220,
                            height: 140,
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(Icons.star_rounded, size: 18, color: _starColor),
                      const SizedBox(width: 4),
                      Text(
                        item.price,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNav() {
    // Track current active tab (Food screen is active by default)
    final currentRoute = Get.currentRoute;
    final isFoodActive = currentRoute == Routes.FOOD;
    
    final items = [
      _NavItem(
          icon: Icons.home_filled,
          label: 'Home',
          isActive: false, // Home is not active when on Food screen
          badge: null,
          onTap: () => Get.offAllNamed(Routes.HOME)), // Navigate to home and clear stack
      _NavItem(
          icon: Icons.location_on_outlined,
          label: 'location', // Changed from 'Nearby' to 'location'
          isActive: false,
          badge: null,
          onTap: () => _openLocationGPS()),
      _NavItem(
          icon: Icons.search,
          label: 'Search',
          isActive: false,
          badge: null,
          onTap: () => _openSearch()),
      _NavItem(
        icon: Icons.shopping_bag_outlined,
        label: 'Cart',
        isActive: false,
        badge: controller.cart.isEmpty ? null : '${controller.cart.length}',
        onTap: () => _openCart(),
      ),
      _NavItem(
          icon: Icons.person_outline,
          label: 'Profile',
          isActive: false,
          badge: null,
          onTap: () => Get.toNamed(Routes.PROFILE_SCREEN)),
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items
            .map(
              (item) => Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(32),
                  onTap: item.onTap,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: item.isActive
                                  ? const Color(0xFF7E57C2) // Purple background for active
                                  : const Color(0xFFF5F5F5),
                              shape: BoxShape.circle,
                              border: item.isActive
                                  ? Border.all(color: const Color(0xFF7E57C2), width: 2)
                                  : null,
                            ),
                            child: Icon(
                              item.icon,
                              color: item.isActive
                                  ? Colors.white // White icon for active purple background
                                  : Colors.black87,
                              size: 26,
                            ),
                          ),
                          if (item.badge != null)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade700,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  item.badge!,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.label,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: item.isActive
                              ? const Color(0xFF7E57C2) // Purple text for active
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _sectionDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: AppThemData.grey200,
        thickness: 1,
        height: 12,
      ),
    );
  }
}

class _ChipItem {
  final String label;
  final IconData? icon;
  final bool hasDropdown;
  final bool isActive;

  const _ChipItem({
    required this.label,
    this.icon,
    this.hasDropdown = false,
    this.isActive = false,
  });
}

class _CategoryIcon {
  final String imagePath;
  final String title;
  final String? badge;
  final Color? badgeColor;

  const _CategoryIcon({
    required this.imagePath,
    required this.title,
    this.badge,
    this.badgeColor,
  });
}

class _StoreItem {
  final String imagePath;
  final String title;
  final String meta;
  final String rating;

  const _StoreItem({
    required this.imagePath,
    required this.title,
    required this.meta,
    required this.rating,
  });
}

class _StoreLogoItem {
  final String imagePath;
  final String title;
  final String meta;

  const _StoreLogoItem({
    required this.imagePath,
    required this.title,
    required this.meta,
  });
}

class _BannerCard {
  final String imagePath;
  final String title;

  const _BannerCard({
    required this.imagePath,
    required this.title,
  });
}

class _NavItem {
  final IconData icon;
  final String label;
  final bool isActive;
  final String? badge;
  final VoidCallback? onTap;

  _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    this.badge,
    this.onTap,
  });
}

void _openRestaurant(_StoreItem store) {
  Get.to(
    () => _RestaurantDetailPage(
      store: store,
      menu: _sampleMenu,
    ),
    transition: Transition.rightToLeft,
  );
}

void _openCart() {
  Get.to(() => _CartPage());
}

/// Open Google Maps with GPS location
Future<void> _openLocationGPS() async {
  try {
    // Request location permission
    final status = await Permission.location.request();
    if (!status.isGranted) {
      Get.snackbar(
        'Permission Required',
        'Location permission is needed to open GPS',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Get current location
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Open Google Maps with current location
    final url = 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Could not open Google Maps',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to get location: ${e.toString()}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

/// Open search functionality
void _openSearch() {
  // For now, show a search dialog or navigate to search screen
  // You can implement a full search screen later
  showDialog(
    context: Get.context!,
    builder: (context) => AlertDialog(
      title: Text('Search', style: GoogleFonts.inter()),
      content: TextField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search restaurants, food...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onSubmitted: (value) {
          // Implement search logic here
          Get.back();
          Get.snackbar(
            'Search',
            'Searching for: $value',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Implement search
            Get.back();
          },
          child: Text('Search'),
        ),
      ],
    ),
  );
}

class _RestaurantDetailPage extends GetView<FoodController> {
  final _StoreItem store;
  final List<_MenuItem> menu;

  const _RestaurantDetailPage({required this.store, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, color: Colors.black87)),
              IconButton(
                  onPressed: () {},
                  icon:
                      const Icon(Icons.favorite_border, color: Colors.black87)),
              IconButton(
                  onPressed: () => _openCart(),
                  icon: const Icon(Icons.more_vert, color: Colors.black87)),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(store.imagePath, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        store.title,
                        style: GoogleFonts.inter(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _pill(
                          text: '-50% some items',
                          icon: Icons.local_offer_outlined),
                      const SizedBox(width: 8),
                      _pill(
                          text: '${store.rating} (1k+)',
                          icon: Icons.thumb_up_alt_outlined),
                      const SizedBox(width: 8),
                      _pill(text: '10-20\'', icon: Icons.access_time),
                      const SizedBox(width: 8),
                      _pill(text: 'Free', icon: Icons.delivery_dining_rounded),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DefaultTabController(
                    length: 4,
                    child: Column(
                      children: [
                        const TabBar(
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.black54,
                          indicatorColor: Colors.black,
                          tabs: [
                            Tab(text: 'Promotions'),
                            Tab(text: 'Reviews'),
                            Tab(text: 'Top sellers'),
                            Tab(text: 'Promos'),
                          ],
                        ),
                        SizedBox(
                          height: 520,
                          child: TabBarView(
                            children: [
                              _menuList(context),
                              _menuList(context),
                              _menuList(context),
                              _menuList(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill({required String text, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5C04C).withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.black87),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w700, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _menuList(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 18),
      itemBuilder: (_, index) {
        final item = menu[index % menu.length];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(item.imagePath,
                width: 80, height: 80, fit: BoxFit.cover),
          ),
          title: Text(
            item.title,
            style: GoogleFonts.inter(
                fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.strikedPrice != null)
                  Text(
                    item.strikedPrice!,
                    style: GoogleFonts.inter(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                Text(
                  item.price,
                  style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          trailing: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.black),
          ),
          onTap: () => _showProductSheet(context, item),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: menu.length,
    );
  }

  void _showProductSheet(BuildContext context, _MenuItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => _ProductSheet(
        restaurant: store.title,
        item: item,
      ),
    );
  }
}

class _ProductSheet extends StatefulWidget {
  final String restaurant;
  final _MenuItem item;

  const _ProductSheet({required this.restaurant, required this.item});

  @override
  State<_ProductSheet> createState() => _ProductSheetState();
}

class _ProductSheetState extends State<_ProductSheet> {
  final drinks = const [
    'Pepsi',
    'Coca-Cola',
    'Coca-Cola Zero',
    'Fanta',
    'Hawaii',
    'Sprite',
    'Eau Sidi Ali',
  ];

  final customizations = const [
    'Sans sauce',
    'Sans oignons',
    'Sans salade',
    'Sans fromage',
    'Sans tomate',
  ];

  String? selectedDrink;
  final Set<String> selectedCustom = {};
  int qty = 1;

  @override
  void initState() {
    super.initState();
    selectedDrink = drinks.first;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FoodController>();
    final priceDouble = double.tryParse(
            widget.item.price.split(' ').first.replaceAll(',', '.')) ??
        0;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.item.title,
                      style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.black),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.black87),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(widget.item.imagePath,
                  height: 220, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                widget.item.price,
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
            ),
            _sectionTitle('Choisissez votre boisson',
                requiredLabel: 'Required'),
            ...drinks.map(
              (d) => RadioListTile<String>(
                activeColor: Colors.teal,
                value: d,
                groupValue: selectedDrink,
                onChanged: (val) => setState(() => selectedDrink = val),
                title: Text(d,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700, color: Colors.black)),
              ),
            ),
            _sectionTitle('Personnalisez', requiredLabel: 'Optional'),
            ...customizations.map(
              (c) => CheckboxListTile(
                value: selectedCustom.contains(c),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      selectedCustom.add(c);
                    } else {
                      selectedCustom.remove(c);
                    }
                  });
                },
                title: Text(c,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700, color: Colors.black)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () =>
                              setState(() => qty = qty > 1 ? qty - 1 : 1),
                          icon: const Icon(Icons.remove),
                        ),
                        Text('$qty',
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.w800)),
                        IconButton(
                          onPressed: () => setState(() => qty += 1),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: () {
                      controller.addToCart(
                        CartItem(
                          restaurant: widget.restaurant,
                          name: widget.item.title,
                          price: priceDouble,
                          quantity: qty,
                          options: [
                            if (selectedDrink != null)
                              'Boisson: $selectedDrink',
                            ...selectedCustom.map((e) => e),
                          ],
                        ),
                      );
                      Get.back();
                      _openCart();
                    },
                    child: Text(
                      'Add $qty for ${widget.item.price}',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, {String? requiredLabel}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
          ),
          if (requiredLabel != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF5C04C).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                requiredLabel,
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class _CartPage extends GetView<FoodController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text('Cart',
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.cart.isEmpty) {
          return Center(
            child: Text('Your cart is empty',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700, color: Colors.black54)),
          );
        }
        final delivery = 12.0;
        final service = 4.36;
        final total = controller.cartSubtotal + delivery + service;
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (_, index) {
                  final item = controller.cart[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                              const Icon(Icons.fastfood, color: Colors.black87),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name,
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black)),
                              const SizedBox(height: 4),
                              Text(item.options.join(', '),
                                  style:
                                      GoogleFonts.inter(color: Colors.black54)),
                              const SizedBox(height: 6),
                              Text('${item.price.toStringAsFixed(2)} MAD',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.remove, size: 18),
                              const SizedBox(width: 8),
                              Text('${item.quantity}',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(width: 8),
                              const Icon(Icons.add, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: controller.cart.length,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _summaryRow('Products',
                      '${controller.cartSubtotal.toStringAsFixed(2)} MAD'),
                  _summaryRow('Delivery', '${delivery.toStringAsFixed(2)} MAD'),
                  _summaryRow('Services', '${service.toStringAsFixed(2)} MAD'),
                  const Divider(height: 18),
                  _summaryRow('TOTAL', '${total.toStringAsFixed(2)} MAD',
                      isBold: true),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () =>
                          Get.to(() => _CheckoutPage(total: total)),
                      child: Text('Pay to order',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _summaryRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(title,
              style: GoogleFonts.inter(
                  fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                  color: Colors.black)),
          const Spacer(),
          Text(value,
              style: GoogleFonts.inter(
                  fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
                  color: Colors.black)),
        ],
      ),
    );
  }
}

class _CheckoutPage extends StatelessWidget {
  final double total;

  const _CheckoutPage({required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text('Checkout',
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Delivery address',
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.place_outlined, color: Colors.black87),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Auto-detected via GPS',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700, color: Colors.black87)),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Delivery options',
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black)),
          const SizedBox(height: 10),
          _radioTile('Standard 15-25 min', 'delivery_time', true),
          _radioTile('Schedule (select time)', 'delivery_time', false),
          const SizedBox(height: 16),
          Text('Payment method',
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black)),
          const SizedBox(height: 10),
          _radioTile('Cash on delivery', 'payment', true),
          _radioTile('Bank card', 'payment', false),
          _radioTile('Paypal / Stripe / Razorpay / Payfast', 'payment', false),
          const SizedBox(height: 16),
          const Divider(),
          _summaryRow('Products', '${(total - 16.36).toStringAsFixed(2)} MAD'),
          _summaryRow('Delivery', '12.00 MAD'),
          _summaryRow('Services', '4.36 MAD'),
          const Divider(),
          _summaryRow('TOTAL', '${total.toStringAsFixed(2)} MAD', isBold: true),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {},
              child: Text('Pay to order',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _radioTile(String text, String group, bool selected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: RadioListTile<bool>(
        value: true,
        groupValue: selected,
        onChanged: (_) {},
        activeColor: Colors.black,
        title: Text(text,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w700, color: Colors.black)),
      ),
    );
  }

  Widget _summaryRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(title,
              style: GoogleFonts.inter(
                  fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
                  color: Colors.black)),
          const Spacer(),
          Text(value,
              style: GoogleFonts.inter(
                  fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
                  color: Colors.black)),
        ],
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final String price;
  final String? strikedPrice;
  final String imagePath;

  const _MenuItem({
    required this.title,
    required this.price,
    required this.imagePath,
    this.strikedPrice,
  });
}

const List<_MenuItem> _sampleMenu = [
  _MenuItem(
    title: 'Best of big tasty',
    price: '81.00 MAD',
    strikedPrice: '103.44 MAD',
    imagePath: "assets/top_items/burger_mcdonalds.jpg",
  ),
  _MenuItem(
    title: 'Margarita small pizza',
    price: '43.00 MAD',
    imagePath: "assets/top_items/dominos_pizza.jpg",
  ),
  _MenuItem(
    title: 'Tacos only compound',
    price: '65.00 MAD',
    imagePath: "assets/top_items/tacos_de_nice.jpg",
  ),
  _MenuItem(
    title: 'Perfect Pizza Dough',
    price: '72.00 MAD',
    imagePath: "assets/top_items/pizza_hut.jpg",
  ),
];

const List<_ChipItem> _categoryFilters = [
  _ChipItem(label: 'All', isActive: true),
  _ChipItem(label: 'Grocery', icon: Icons.local_grocery_store_outlined),
  _ChipItem(label: 'Convenience', icon: Icons.local_mall_outlined),
  _ChipItem(label: 'Alcohol', icon: Icons.local_bar_outlined),
];

const List<_CategoryIcon> _categories = [
  _CategoryIcon(imagePath: "assets/food/pizza.png", title: "Pizza"),
  _CategoryIcon(imagePath: "assets/food/burger.png", title: "Explore"),
  _CategoryIcon(imagePath: "assets/food/roast_chicken.png", title: "Chicken"),
  _CategoryIcon(imagePath: "assets/food/carrefour.png", title: "Supermarket"),
  _CategoryIcon(imagePath: "assets/food/kfc.png", title: "KFC"),
  _CategoryIcon(imagePath: "assets/food/mcdonalds.png", title: "McDonald's"),
  _CategoryIcon(imagePath: "assets/food/pizza_hut.png", title: "Pizza Hut"),
  _CategoryIcon(imagePath: "assets/food/sushi.png", title: "Sushi"),
  _CategoryIcon(imagePath: "assets/food/tacos.png", title: "Tacos"),
  _CategoryIcon(imagePath: "assets/food/juice.png", title: "Juice"),
  _CategoryIcon(imagePath: "assets/food/starbucks.png", title: "Starbucks"),
];

const List<_ChipItem> _filterChips = [
  _ChipItem(label: 'Pickup', icon: Icons.directions_walk),
  _ChipItem(label: 'Offers', icon: Icons.local_offer_outlined),
  _ChipItem(
      label: 'Delivery fee', icon: Icons.delivery_dining, hasDropdown: true),
  _ChipItem(label: 'Under 25 min', icon: Icons.access_time),
];

const List<_StoreItem> _featuredStores = [
  _StoreItem(
    imagePath: "assets/purple/burgerking.jpg",
    title: "Burger King",
    meta: "0 MAD Delivery Fee • 20-30 min",
    rating: "4.8",
  ),
  _StoreItem(
    imagePath: "assets/purple/kfc.jpg",
    title: "KFC",
    meta: "0 MAD Delivery Fee • 15-25 min",
    rating: "4.7",
  ),
  _StoreItem(
    imagePath: "assets/purple/dominos.jpg",
    title: "Domino's",
    meta: "10 MAD Delivery Fee • 25-35 min",
    rating: "4.6",
  ),
];

const List<_StoreItem> _localSpots = [
  _StoreItem(
    imagePath: "assets/purple/tacosdenice.jpg",
    title: "Tacos de Nice",
    meta: "0 MAD Delivery Fee • 18-28 min",
    rating: "4.8",
  ),
  _StoreItem(
    imagePath: "assets/purple/starbucks.jpg",
    title: "Starbucks",
    meta: "0 MAD Delivery Fee • 15-25 min",
    rating: "4.6",
  ),
  _StoreItem(
    imagePath: "assets/purple/pasticio.jpg",
    title: "Pasticio",
    meta: "0 MAD Delivery Fee • 20-30 min",
    rating: "4.5",
  ),
];

const List<_StoreLogoItem> _nearbyStores = [
  _StoreLogoItem(
    imagePath: "assets/brands/mcdonalds.png",
    title: "McDonald's",
    meta: "20 min",
  ),
  _StoreLogoItem(
    imagePath: "assets/brands/kfc.png",
    title: "KFC",
    meta: "18 min",
  ),
  _StoreLogoItem(
    imagePath: "assets/brands/burgerking.png",
    title: "Burger King",
    meta: "22 min",
  ),
  _StoreLogoItem(
    imagePath: "assets/brands/pizza hut.png",
    title: "Pizza Hut",
    meta: "25 min",
  ),
  _StoreLogoItem(
    imagePath: "assets/brands/tacos de nice.png",
    title: "Tacos de Nice",
    meta: "23 min",
  ),
  _StoreLogoItem(
    imagePath: "assets/brands/dominos pizza .png",
    title: "Domino's Pizza",
    meta: "24 min",
  ),
];

const List<_BannerCard> _dominosBanners = [
  _BannerCard(
      imagePath: "assets/dominos_pizza/dominos_pizza1.jpeg",
      title: "Domino's Pizza"),
  _BannerCard(
      imagePath: "assets/dominos_pizza/dominos_pizza2.jpeg",
      title: "Domino's Pizza"),
];
