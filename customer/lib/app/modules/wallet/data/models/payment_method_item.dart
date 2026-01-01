/// Model for payment method item
class PaymentMethodItem {
  final String id;
  final String name;
  final String type; // 'apple_pay' | 'google_pay' | 'cash' | 'card'
  final String iconAsset; // Optional asset path
  final bool isAvailable; // Platform availability
  final bool isEnabled; // User can select this

  PaymentMethodItem({
    required this.id,
    required this.name,
    required this.type,
    this.iconAsset = '',
    required this.isAvailable,
    this.isEnabled = true,
  });

  /// Check if method is available on current platform
  static bool isPlatformAvailable(String type) {
    // This will be checked in controller based on Platform
    return true; // Placeholder
  }
}

