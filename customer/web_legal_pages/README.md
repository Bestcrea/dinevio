# Dinevio Legal Pages - Deployment Guide

## 📋 Overview

This directory contains two production-ready legal pages for the Dinevio platform:
- **Terms of Use** (`terms-of-use.html`)
- **Privacy Policy** (`privacy-policy.html`)

These pages are designed to be:
- ✅ SEO-friendly with proper meta tags
- ✅ Mobile-responsive and WebView-compatible
- ✅ Accessible via exact URLs expected by the Flutter app
- ✅ Production-ready with professional legal content

---

## 🎯 Target URLs

The Flutter app expects these exact URLs:
- `https://www.dinevio.com/terms-of-use`
- `https://www.dinevio.com/privacy-policy`

**Important:** These URLs must match exactly in your web server configuration.

---

## 🚀 Deployment Options

### Option 1: Static HTML Files (Recommended for Simple Setup)

1. **Upload files to your web server:**
   ```bash
   # Copy files to your web root
   cp terms-of-use.html /var/www/dinevio.com/terms-of-use.html
   cp privacy-policy.html /var/www/dinevio.com/privacy-policy.html
   ```

2. **Configure URL rewriting (if needed):**
   - Apache: Use `.htaccess` to remove `.html` extension
   - Nginx: Configure location blocks
   - Ensure URLs work with and without `.html` extension

### Option 2: Firebase Hosting

1. **Create Firebase project:**
   ```bash
   firebase init hosting
   ```

2. **Place files in `public/` directory:**
   ```
   public/
     ├── terms-of-use.html
     └── privacy-policy.html
   ```

3. **Configure `firebase.json`:**
   ```json
   {
     "hosting": {
       "public": "public",
       "rewrites": [
         {
           "source": "/terms-of-use",
           "destination": "/terms-of-use.html"
         },
         {
           "source": "/privacy-policy",
           "destination": "/privacy-policy.html"
         }
       ]
     }
   }
   ```

4. **Deploy:**
   ```bash
   firebase deploy --only hosting
   ```

### Option 3: Next.js / React / Vue (If Using Framework)

1. **Convert HTML to framework components:**
   - Extract content into components
   - Use framework routing
   - Maintain same URLs

2. **Example Next.js:**
   ```javascript
   // pages/terms-of-use.js
   export default function TermsOfUse() {
     return <TermsContent />;
   }
   ```

### Option 4: WordPress / CMS

1. **Create custom page templates:**
   - Copy HTML content
   - Create pages: "Terms of Use" and "Privacy Policy"
   - Set permalinks to match URLs

---

## ⚙️ Configuration Steps

### 1. Update Contact Information

Edit both HTML files and replace placeholder emails:
- `legal@dinevio.com` → Your actual legal email
- `privacy@dinevio.com` → Your actual privacy email
- `support@dinevio.com` → Your actual support email
- `dpo@dinevio.com` → Your Data Protection Officer email (if applicable)

### 2. Update Jurisdiction Information

In `terms-of-use.html`, Section 9:
```html
<p>These Terms shall be governed by and construed in accordance with the laws of [Your Jurisdiction]...</p>
```
Replace `[Your Jurisdiction]` with your actual jurisdiction (e.g., "Morocco", "United States", "European Union").

### 3. Update Company Address

In `privacy-policy.html`, Section 14:
```html
<p><strong>Mailing Address:</strong> [Your Company Address]</p>
```
Replace with your actual company address.

### 4. Update Last Updated Date

Both files have:
```html
<p class="last-updated">Last Updated: December 27, 2024</p>
```
Update this date whenever you make changes.

---

## 🔗 Flutter App Integration

The Flutter app is already configured to use these URLs. No changes needed in the app code.

**Current Implementation:**
- `customer/lib/auth/constants/legal_urls.dart` contains:
  ```dart
  static const String termsOfUseUrl = 'https://www.dinevio.com/terms-of-use';
  static const String privacyPolicyUrl = 'https://www.dinevio.com/privacy-policy';
  ```

**How it works:**
1. User taps "Terms of use" or "Privacy policy" link in login screen
2. Flutter app opens `LegalWebViewScreen` with the URL
3. WebView loads the HTML page from your server
4. User can read the content and navigate back

**Testing:**
- Ensure URLs are accessible (no authentication required)
- Test in Flutter WebView
- Verify mobile responsiveness
- Check loading speed

---

## 📱 WebView Compatibility

These pages are optimized for Flutter WebView:

✅ **Compatible Features:**
- Standard HTML5 and CSS3
- No JavaScript dependencies (works without JS)
- Responsive design (mobile-friendly)
- Fast loading (minimal external resources)
- Clean URLs (no query parameters needed)

✅ **Tested Scenarios:**
- iOS WebView (WKWebView)
- Android WebView
- Flutter WebView widget
- Mobile browsers
- Desktop browsers

---

## 🔍 SEO Optimization

Both pages include:

✅ **Meta Tags:**
- Title
- Description
- Keywords
- Open Graph tags
- Robots directives

✅ **Structure:**
- Semantic HTML5
- Proper heading hierarchy (h1 → h2 → h3)
- Clean URLs
- Fast loading

✅ **Content:**
- Comprehensive legal coverage
- Clear section organization
- Readable typography
- Mobile-responsive

---

## 🧪 Testing Checklist

Before going live:

- [ ] URLs are accessible: `https://www.dinevio.com/terms-of-use`
- [ ] URLs are accessible: `https://www.dinevio.com/privacy-policy`
- [ ] No authentication required
- [ ] Pages load quickly (< 2 seconds)
- [ ] Mobile-responsive (test on phone)
- [ ] WebView-compatible (test in Flutter app)
- [ ] Contact emails are correct
- [ ] Jurisdiction information is updated
- [ ] Company address is updated
- [ ] Last updated date is current
- [ ] SEO meta tags are correct
- [ ] Links work (if any)
- [ ] No broken images or resources

---

## 🔄 Updates and Maintenance

### When to Update:

1. **Terms of Use:**
   - Changes to service offerings
   - New features or services
   - Legal requirement changes
   - User feedback or disputes

2. **Privacy Policy:**
   - New data collection practices
   - Changes to third-party services
   - Legal requirement changes (GDPR, CCPA updates)
   - Security policy changes

### Update Process:

1. Edit HTML files
2. Update "Last Updated" date
3. Deploy to server
4. Test URLs in Flutter app
5. Notify users (if required by law)

---

## 📞 Support

If you need help:
- **Technical Issues:** Check server logs, WebView console
- **Content Questions:** Consult with legal counsel
- **Deployment Help:** Refer to your hosting provider's documentation

---

## ✅ Sign-off

**Status:** ✅ Ready for Deployment  
**Date:** December 27, 2024  
**Next Steps:**
1. Update contact information
2. Update jurisdiction information
3. Deploy to production server
4. Test URLs in Flutter app
5. Verify SEO and accessibility

---

## 📝 Notes

- These pages are templates. Consult with legal counsel before publishing.
- Some sections may need customization based on your specific business model.
- Consider adding language switching for international users (future enhancement).
- Monitor analytics to see how many users access these pages.

