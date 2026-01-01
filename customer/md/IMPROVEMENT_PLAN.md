# Dinevio App Improvement Plan

## Overview
This document outlines 8 critical improvements needed to finalize the Dinevio application.

---

## 1. Header Logo Fix
**Current Issue:** Logo is too small in header
**Solution:** Replace small PNG logo with bold "Dinevio" text
**Files to Modify:**
- `customer/lib/app/modules/home/views/home_view.dart` - Replace `_AnimatedLogo` widget with text

**Implementation:**
- Remove Image.asset for logo
- Use Text widget with "Dinevio" in bold
- Keep animation if needed, or simplify
- Font: Inter, size: 20-24px, weight: bold (700)

---

## 2. Food Bottom Navigation Bar
**Current Issues:**
- HOME button doesn't navigate to homepage
- LOCATION shows "Nearby" instead of "location"
- LOCATION should open Google Maps GPS
- SEARCH doesn't work
- CART should navigate to Cart Shop
- PROFILE should navigate to Profile Screen
- Needs professional styling with purple active state

**Files to Modify:**
- `customer/lib/app/modules/food/views/food_view.dart` - `_buildBottomNav()` method
- `customer/lib/app/modules/food/controllers/food_controller.dart` - Add navigation methods

**Implementation:**
- Fix HOME: Navigate to Routes.HOME
- Fix LOCATION: Change label to "location", add GPS functionality using `url_launcher` or `location` package
- Fix SEARCH: Implement search functionality or navigate to search screen
- Fix CART: Navigate to cart/shop screen
- Fix PROFILE: Navigate to Routes.PROFILE_SCREEN
- Add purple color (#7E57C2 or similar) for active state
- Improve styling: better spacing, shadows, animations

---

## 3. Parcel Screen Improvements
**Current Issues:**
- Box design needs improvement
- Currency shows Dollar instead of MAD

**Files to Modify:**
- `customer/lib/app/modules/book_parcel/views/book_parcel_view.dart` - Improve box styling
- `customer/lib/app/modules/parcel_ride_details/views/parcel_ride_details_view.dart` - Change currency display
- Search for currency references in parcel-related files

**Implementation:**
- Redesign boxes: Better borders, shadows, spacing, rounded corners
- Replace USD icon with MAD currency symbol/text
- Update all currency displays from Dollar to MAD
- Check `Constant.amountToShow()` for currency formatting

---

## 4. Intercity Screen (Coming Soon)
**Current State:** Simple "coming soon" placeholder
**Required:** Rides MAP Google Play Store style

**Files to Modify:**
- `customer/lib/app/intercity/intercity_flow_page.dart` - Complete redesign
- May need to create new controller/view files

**Implementation:**
- Show Google Maps view
- Two location boxes:
  - "Current Location" (with GPS detection)
  - "Destination Location" (with search/autocomplete)
- "Find Rides" button that links to Select Location section
- Similar to Uber/InDrive style interface

---

## 5. Parapharmacy Screen (Coming Soon)
**Current State:** Simple "coming soon" placeholder
**Required:** Glovo-style design

**Files to Modify:**
- `customer/lib/features/para/presentation/pages/para_marketplace_page.dart` - Complete redesign

**Implementation:**
- Research Glovo app design patterns
- Implement similar layout:
  - Category grid at top
  - Product cards with images
  - Search functionality
  - Cart integration
  - Store/Pharmacy selection

---

## 6. Grocery Screen
**Current Issues:**
- Categories not linked to images
- Brands sections need logos

**Files to Modify:**
- `customer/lib/features/grocery/presentation/widgets/grocery_widgets.dart` - CategoryScroller
- `customer/lib/features/grocery/data/services/mock_grocery_service.dart` - Add image paths
- `customer/lib/features/grocery/domain/entities/category_entity.dart` - Ensure image field exists

**Implementation:**
- Link each category to appropriate image asset
- Add brand logos to Brands section
- Ensure images load correctly with error handling

---

## 7. Profile/Account Screen
**Current State:** Recently implemented with YASSIR-inspired design
**Required:** Multiple improvements (specifics to be clarified)

**Files to Review:**
- `customer/lib/app/modules/profile_screen/views/profile_screen_view.dart`
- `customer/lib/app/modules/profile_screen/controllers/profile_screen_controller.dart`

**Implementation:**
- Review current implementation
- Identify specific issues
- Apply improvements based on user feedback

---

## 8. Login Screen and OTP Screen
**Current Issues:** Need fixing (specifics to be identified)

**Files to Review:**
- `customer/lib/app/modules/login/views/login_view.dart`
- `customer/lib/auth/phone_login_screen.dart`
- `customer/lib/auth/otp_verification_screen.dart`

**Implementation:**
- Review current implementation
- Identify bugs/issues
- Fix navigation, validation, UI issues

---

## Implementation Priority

1. **High Priority (Core Functionality):**
   - Point 2: Food Bottom Navigation Bar (affects user navigation)
   - Point 8: Login/OTP Screens (affects user access)

2. **Medium Priority (User Experience):**
   - Point 1: Header Logo
   - Point 3: Parcel Screen
   - Point 6: Grocery Screen

3. **Lower Priority (New Features):**
   - Point 4: Intercity Screen
   - Point 5: Parapharmacy Screen
   - Point 7: Profile Screen improvements

---

## Notes
- All changes should maintain existing functionality
- Test each change before moving to next
- Keep consistent with app's design language (purple theme)
- Ensure responsive design for all screen sizes

