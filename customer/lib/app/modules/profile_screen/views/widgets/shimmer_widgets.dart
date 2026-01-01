import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer effect widget for loading states
class ShimmerEffect extends StatelessWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(milliseconds: 1200),
      child: child,
    );
  }
}

/// Shimmer box for placeholder
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? color;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      baseColor: color ?? const Color(0xFFE0E0E0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? Colors.grey.shade300,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Shimmer header skeleton
class ShimmerHeader extends StatelessWidget {
  const ShimmerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF7E57C2),
            const Color(0xFF7E57C2).withOpacity(0.85),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24), // Keep original spacing for shimmer
        child: Column(
          children: [
            // Settings icon placeholder
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ShimmerBox(
                  width: 40,
                  height: 40,
                  borderRadius: 20,
                  color: Colors.white.withOpacity(0.3),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Profile section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar shimmer
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ShimmerBox(
                      width: 80,
                      height: 80,
                      borderRadius: 40,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    // Badge shimmer
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: ShimmerBox(
                        width: 50,
                        height: 24,
                        borderRadius: 12,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Name and phone shimmer
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ShimmerBox(
                              width: double.infinity,
                              height: 24,
                              borderRadius: 8,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ShimmerBox(
                            width: 60,
                            height: 24,
                            borderRadius: 8,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ShimmerBox(
                        width: 150,
                        height: 16,
                        borderRadius: 8,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer quick action cards
class ShimmerQuickActionCards extends StatelessWidget {
  const ShimmerQuickActionCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24), // Keep original spacing for shimmer
      child: Row(
        children: [
          Expanded(
            child: _ShimmerQuickActionCard(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ShimmerQuickActionCard(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ShimmerQuickActionCard(),
          ),
        ],
      ),
    );
  }
}

class _ShimmerQuickActionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(18), // Match card radius
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShimmerBox(
            width: 32,
            height: 32,
            borderRadius: 16,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 8),
          ShimmerBox(
            width: 60,
            height: 14,
            borderRadius: 4,
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}

/// Shimmer menu card
class ShimmerMenuCard extends StatelessWidget {
  const ShimmerMenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(22), // Match container radius
        ),
        child: Column(
          children: List.generate(
            5,
            (index) => Column(
              children: [
                Container(
                  height: 54, // Match row height
                  child: Row(
                    children: [
                      ShimmerBox(
                        width: 40,
                        height: 40,
                        borderRadius: 10,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ShimmerBox(
                          width: double.infinity,
                          height: 16,
                          borderRadius: 4,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ShimmerBox(
                        width: 24,
                        height: 24,
                        borderRadius: 12,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),
                if (index < 4) ...[
                  const SizedBox(height: 16),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

