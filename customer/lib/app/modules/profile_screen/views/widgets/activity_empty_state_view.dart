import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityEmptyStateView extends StatefulWidget {
  const ActivityEmptyStateView({super.key});

  @override
  State<ActivityEmptyStateView> createState() => _ActivityEmptyStateViewState();
}

class _ActivityEmptyStateViewState extends State<ActivityEmptyStateView> {
  int _selectedTab = 0; // 0: Food, 1: Market, 2: Shop
  int _selectedFilter = 0; // 0: All, 1: Delivered, 2: Cancelled

  static const Color _primaryPurple = Color(0xFF7E57C2);
  static const Color _darkText = Color(0xFF1A1A1A);
  static const Color _greyText = Color(0xFF757575);
  static const Color _lightPurple = Color(0xFFE1D5F7); // Light purple for illustration

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
          'Activity',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _darkText,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Navigation tabs (Food, Market, Shop)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: Row(
              children: [
                _buildTab('Food', 0),
                const SizedBox(width: 24),
                _buildTab('Market', 1),
                const SizedBox(width: 24),
                _buildTab('Shop', 2),
              ],
            ),
          ),

          // Filter buttons (All, Delivered, Cancelled)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(child: _buildFilterButton('All', 0)),
                const SizedBox(width: 8),
                Expanded(child: _buildFilterButton('Delivered', 1)),
                const SizedBox(width: 8),
                Expanded(child: _buildFilterButton('Cancelled', 2)),
              ],
            ),
          ),

          // Empty state content
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 3D Illustration: Two stacked receipt cards
                    _buildReceiptIllustration(),
                    const SizedBox(height: 32),
                    // Title
                    Text(
                      'You have no order history',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _primaryPurple, // Bold purple text
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    Text(
                      'Would you like to place an order?',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: _greyText, // Dark grey text
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Order now button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          // Navigate to home or order screen
                          Get.toNamed('/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Order now',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? _primaryPurple : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            color: isSelected ? _primaryPurple : _greyText,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? _primaryPurple : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _primaryPurple : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : _darkText,
            ),
          ),
        ),
      ),
    );
  }

  /// Build 3D-style receipt illustration (two stacked cards)
  Widget _buildReceiptIllustration() {
    return SizedBox(
      width: 240,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back card (larger, upright)
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateX(0.05)
              ..rotateY(0.05),
            alignment: FractionalOffset.center,
            child: Container(
              width: 180,
              height: 160,
              decoration: BoxDecoration(
                color: _lightPurple.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _buildReceiptLines(),
            ),
          ),
          // Front card (smaller, tilted forward)
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateX(-0.1)
              ..rotateY(-0.1)
              ..translate(20.0, -10.0),
            alignment: FractionalOffset.center,
            child: Container(
              width: 160,
              height: 140,
              decoration: BoxDecoration(
                color: _lightPurple,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: _buildReceiptLines(),
            ),
          ),
        ],
      ),
    );
  }

  /// Build receipt lines inside the cards
  Widget _buildReceiptLines() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header line
          Container(
            width: double.infinity,
            height: 3,
            decoration: BoxDecoration(
              color: _primaryPurple.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          // Text lines
          ...List.generate(5, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: index == 4 ? 0 : 8),
              child: Container(
                width: double.infinity,
                height: 2,
                decoration: BoxDecoration(
                  color: _primaryPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
