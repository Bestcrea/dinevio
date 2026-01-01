import 'package:intl/intl.dart';

/// Currency formatter for Moroccan Dirham (MAD)
/// Provides consistent formatting across the app
class CurrencyFormatter {
  /// Format amount as MAD currency
  /// Example: formatMoneyMAD(100.5) returns "100.50 MAD"
  static String formatMoneyMAD(double amount) {
    return NumberFormat.currency(
      symbol: 'MAD',
      decimalDigits: 2,
      locale: 'en_US',
    ).format(amount);
  }

  /// Format amount as MAD currency from string
  /// Example: formatMoneyMADFromString("100.5") returns "100.50 MAD"
  static String formatMoneyMADFromString(String? amount) {
    if (amount == null || amount.isEmpty) {
      return '0.00 MAD';
    }
    try {
      final value = double.parse(amount);
      return formatMoneyMAD(value);
    } catch (e) {
      return '0.00 MAD';
    }
  }

  /// Format amount as MAD currency (compact version)
  /// Example: formatMoneyMADCompact(1000) returns "1,000 MAD"
  static String formatMoneyMADCompact(double amount) {
    return NumberFormat.currency(
      symbol: 'MAD',
      decimalDigits: 0,
      locale: 'en_US',
    ).format(amount);
  }

  /// Format amount as MAD currency without symbol (just number)
  /// Example: formatMoneyMADNumber(100.5) returns "100.50"
  static String formatMoneyMADNumber(double amount) {
    return NumberFormat('#,##0.00', 'en_US').format(amount);
  }
}

