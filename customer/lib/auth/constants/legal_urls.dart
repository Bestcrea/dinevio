/// Legal document URLs for Terms of Use and Privacy Policy
class LegalUrls {
  LegalUrls._();

  // TODO: Replace with your actual URLs
  // These can be hosted on your website, Firebase Hosting, or any static hosting
  static const String termsOfUseUrl = 'https://www.dinevio.com/terms-of-use';
  static const String privacyPolicyUrl = 'https://www.dinevio.com/privacy-policy';

  // Fallback: If URLs are not available, you can use HTML data URLs
  // Example: 'data:text/html;charset=utf-8,${Uri.encodeComponent(htmlContent)}'
  
  /// Get Terms of Use URL (with fallback to HTML data if needed)
  static String getTermsUrl() {
    // You can add logic here to check if Constant.termsAndConditions has HTML
    // and convert it to data URL if URL is not available
    return termsOfUseUrl;
  }

  /// Get Privacy Policy URL (with fallback to HTML data if needed)
  static String getPrivacyUrl() {
    // You can add logic here to check if Constant.privacyPolicy has HTML
    // and convert it to data URL if URL is not available
    return privacyPolicyUrl;
  }
}

