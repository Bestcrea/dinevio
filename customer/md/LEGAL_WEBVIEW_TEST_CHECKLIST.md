# Legal WebView Screen - Test Checklist

## ✅ Implementation Summary

**Files Created:**
- `customer/lib/auth/screens/legal_webview_screen.dart` - Reusable WebView screen
- `customer/lib/auth/constants/legal_urls.dart` - URL constants

**Files Modified:**
- `customer/lib/auth/widgets/terms_text.dart` - Updated with working navigation

**Key Features:**
- ✅ AppBar with back arrow and title
- ✅ WebView loading URLs
- ✅ Loading indicator while page loads
- ✅ Error state handling (no internet)
- ✅ Retry button on error
- ✅ Clean white background
- ✅ SafeArea support
- ✅ Smooth back navigation

---

## 🧪 Test Checklist

### 1. Navigation from Login Screen
- [ ] Tap "Terms of use" link in TermsText widget
- [ ] LegalWebViewScreen opens with title "Terms of Use"
- [ ] Tap "Privacy policy" link in TermsText widget
- [ ] LegalWebViewScreen opens with title "Privacy Policy"
- [ ] Back arrow returns to previous screen
- [ ] Navigation is smooth (no blocking)

### 2. WebView Loading
- [ ] Loading indicator appears when screen opens
- [ ] Loading indicator shows while page is loading
- [ ] Loading indicator disappears when page finishes loading
- [ ] WebView displays the loaded content correctly
- [ ] Page is scrollable
- [ ] Text is readable (fontSize 14-16, lineHeight ~1.5)

### 3. Error Handling (Offline Case)
- [ ] Turn off internet/WiFi
- [ ] Open Terms or Privacy link
- [ ] Error state appears after timeout
- [ ] Error message displays: "Unable to load page"
- [ ] Error description shows: "Please check your internet connection..."
- [ ] Error icon is visible
- [ ] "Retry" button is visible and clickable

### 4. Retry Functionality
- [ ] Tap "Retry" button while offline
- [ ] Loading indicator appears
- [ ] Error state remains (expected, still offline)
- [ ] Turn internet back on
- [ ] Tap "Retry" button
- [ ] Page loads successfully
- [ ] WebView displays content

### 5. UI/UX
- [ ] Background is white
- [ ] AppBar has back arrow on left
- [ ] AppBar title matches screen ("Terms of Use" or "Privacy Policy")
- [ ] SafeArea is respected (no content under status bar)
- [ ] Text is readable and properly sized
- [ ] No overflow warnings
- [ ] Smooth scrolling in WebView

### 6. Edge Cases
- [ ] Invalid URL: Update `LegalUrls.termsOfUseUrl` to invalid URL
  - [ ] Error state appears
  - [ ] Retry button works
- [ ] Very long loading time:
  - [ ] Loading indicator stays visible
  - [ ] No crashes or freezes
- [ ] Rapid back/forward navigation:
  - [ ] No memory leaks
  - [ ] Navigation remains smooth

### 7. Integration
- [ ] Login flow is not blocked if user doesn't open links
- [ ] User can continue login without opening Terms/Privacy
- [ ] Links are clearly tappable (underlined, black color)
- [ ] Links work from both onboarding and phone login screens

---

## 🚀 How to Test

### Step 1: Test Normal Flow
```bash
# 1. Launch app
flutter run

# 2. Navigate to login screen
# 3. Tap "Terms of use" link
# Expected: LegalWebViewScreen opens, loads Terms URL

# 4. Tap back arrow
# Expected: Returns to login screen

# 5. Tap "Privacy policy" link
# Expected: LegalWebViewScreen opens, loads Privacy URL
```

### Step 2: Test Offline Case
```bash
# 1. Turn off device internet/WiFi
# 2. Open Terms or Privacy link
# Expected: 
#   - Loading indicator appears
#   - After timeout, error state appears
#   - Error message and retry button visible

# 3. Turn internet back on
# 4. Tap "Retry" button
# Expected: Page loads successfully
```

### Step 3: Test URL Configuration
```bash
# Edit customer/lib/auth/constants/legal_urls.dart
# Update URLs to your actual hosted pages:
# - termsOfUseUrl
# - privacyPolicyUrl

# Test with:
# - Valid URLs (should load)
# - Invalid URLs (should show error)
# - Empty URLs (should show error)
```

### Step 4: Test Integration
```bash
# 1. On login screen, don't tap any links
# 2. Continue with phone login
# Expected: Login flow continues normally

# 3. On login screen, tap Terms link
# 4. View Terms, then go back
# 5. Continue with phone login
# Expected: Login flow continues normally
```

---

## 📝 Configuration

### Update URLs

Edit `customer/lib/auth/constants/legal_urls.dart`:

```dart
static const String termsOfUseUrl = 'https://your-domain.com/terms';
static const String privacyPolicyUrl = 'https://your-domain.com/privacy';
```

### Using HTML Data Instead of URLs

If you want to use HTML content from Firestore instead of URLs:

```dart
static String getTermsUrl() {
  if (Constant.termsAndConditions.isNotEmpty) {
    // Convert HTML to data URL
    return 'data:text/html;charset=utf-8,${Uri.encodeComponent(Constant.termsAndConditions)}';
  }
  return termsOfUseUrl;
}
```

---

## 🐛 Known Issues / Notes

- **URLs Required:** You need to host your Terms and Privacy pages somewhere accessible (your website, Firebase Hosting, etc.)
- **Fallback:** If URLs are not available, you can modify `LegalUrls` to use HTML data URLs from Firestore
- **Loading Time:** First load may take a few seconds depending on internet speed
- **Caching:** WebView may cache pages for faster subsequent loads

---

## ✅ Sign-off

**Developer:** [Your Name]  
**Date:** 2024-12-27  
**Status:** ✅ Ready for Testing

**Next Steps:**
1. Update URLs in `legal_urls.dart` with actual hosted pages
2. Test on real device with internet
3. Test offline scenario
4. Verify content displays correctly

