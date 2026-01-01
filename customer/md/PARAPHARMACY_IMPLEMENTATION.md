# Parapharmacy Marketplace Implementation

## Overview
Upgraded `ParaMarketplacePage` to a premium marketplace UI with Firebase integration and admin panel for shop/product management.

## Files Created/Modified

### Models
- `customer/lib/features/para/data/models/para_shop_model.dart` - Firestore shop model
- `customer/lib/features/para/data/models/para_product_model.dart` - Firestore product model

### Repository
- `customer/lib/features/para/data/repositories/para_repository.dart` - Firestore operations for shops and products

### Controllers
- `customer/lib/features/para/state/para_marketplace_controller.dart` - GetX controller for marketplace

### UI Pages
- `customer/lib/features/para/presentation/pages/para_marketplace_page.dart` - Main marketplace UI (upgraded)
- `customer/lib/features/para/presentation/pages/admin/para_admin_home_page.dart` - Admin home (list shops)
- `customer/lib/features/para/presentation/pages/admin/para_admin_shop_edit_page.dart` - Create/edit shop
- `customer/lib/features/para/presentation/pages/admin/para_admin_products_page.dart` - List products for shop
- `customer/lib/features/para/presentation/pages/admin/para_admin_product_edit_page.dart` - Create/edit product

## Firebase Collections

### `para_shops/{shopId}`
```json
{
  "ownerUid": "string",
  "name": "string",
  "coverImageUrl": "string",
  "logoUrl": "string (optional)",
  "category": "Promotion | Parapharmacy | Beauty",
  "ratingPercent": 0-100,
  "ratingCount": 0,
  "deliveryTimeMin": 20,
  "deliveryTimeMax": 30,
  "isOpen": true,
  "opensAtText": "Opens tomorrow at 09:00",
  "createdAt": "timestamp"
}
```

### `para_shops/{shopId}/products/{productId}`
```json
{
  "shopId": "string",
  "title": "string",
  "description": "string",
  "imageUrl": "string",
  "category": "string",
  "priceMad": 0.0,
  "stock": 0,
  "isActive": true,
  "createdAt": "timestamp"
}
```

### Firebase Storage Paths
- `para_shops/{shopId}/cover.jpg`
- `para_shops/{shopId}/logo.png`
- `para_shops/{shopId}/products/{productId}.jpg`

## Features Implemented

### Marketplace UI
✅ Search bar (opens dialog)
✅ Horizontal categories row (Promotions, Parapharmacy, Beauty)
✅ Filter chips (Promotions, Category, Sort by)
✅ Shop cards with:
  - Cover image
  - Closed overlay with "Opens tomorrow" text
  - Rating and delivery time
  - Free delivery badge
  - Favorite icon (animated)
✅ Skeleton loading states
✅ Empty state UI
✅ Responsive design

### Admin Panel
✅ Shop CRUD (create, read, update, delete)
✅ Product CRUD
✅ Image uploads (cover, logo, product images)
✅ Role guard (ownerUid check)
✅ Access denied handling

## How to Test

### 1. Seed Sample Data in Firestore

#### Create a Shop:
```javascript
// In Firebase Console > Firestore
// Collection: para_shops
// Document ID: (auto-generated)
{
  "ownerUid": "YOUR_USER_UID",
  "name": "Beauty Market",
  "coverImageUrl": "https://example.com/cover.jpg",
  "category": "Beauty",
  "ratingPercent": 94,
  "ratingCount": 86,
  "deliveryTimeMin": 20,
  "deliveryTimeMax": 30,
  "isOpen": true,
  "opensAtText": "",
  "createdAt": Timestamp.now()
}
```

#### Create a Product:
```javascript
// Collection: para_shops/{shopId}/products
// Document ID: (auto-generated)
{
  "shopId": "SHOP_ID",
  "title": "Face Serum",
  "description": "Premium face serum",
  "imageUrl": "https://example.com/product.jpg",
  "category": "Skincare",
  "priceMad": 129.0,
  "stock": 50,
  "isActive": true,
  "createdAt": Timestamp.now()
}
```

### 2. Test Marketplace
1. Run the app
2. Navigate to Parapharmacy from home screen
3. Verify:
   - ✅ Categories display with icons
   - ✅ Tapping category filters shops
   - ✅ Search bar opens dialog
   - ✅ Shop cards display correctly
   - ✅ Closed shops show overlay
   - ✅ Favorite icon toggles
   - ✅ Loading skeleton appears
   - ✅ Empty state shows when no shops

### 3. Test Admin Panel
1. Navigate to admin (add route or button)
2. Create a shop:
   - ✅ Upload cover image
   - ✅ Upload logo
   - ✅ Fill form fields
   - ✅ Save shop
3. Edit shop:
   - ✅ Update fields
   - ✅ Change images
   - ✅ Toggle open/closed
4. Manage products:
   - ✅ Add product
   - ✅ Edit product
   - ✅ Delete product
   - ✅ Toggle active/inactive
5. Test access control:
   - ✅ Try accessing shop with different UID
   - ✅ Should show "Access denied"

## Visual QA Checklist

- [ ] Search bar height 48-52px, radius 24+
- [ ] Categories row scrollable, icons circular
- [ ] Active category has purple highlight
- [ ] Filter chips rounded pills, light grey
- [ ] Shop cards radius 18-22px, subtle shadow
- [ ] Closed overlay dark with white text
- [ ] Rating format: "94% (86)"
- [ ] Delivery time: "20-30 min"
- [ ] Free badge yellow pill
- [ ] Favorite icon animates on tap
- [ ] Skeleton loaders (not spinners)
- [ ] Empty state centered with icon
- [ ] No overflow with textScaleFactor 1.5
- [ ] Admin forms validate correctly
- [ ] Image uploads work
- [ ] Role guard prevents unauthorized access

## Routes to Add

Add these routes to `app_routes.dart` and `app_pages.dart`:

```dart
// In app_routes.dart
static const PARA_ADMIN_HOME = _Paths.PARA_ADMIN_HOME;
static const PARA_ADMIN_SHOP_EDIT = _Paths.PARA_ADMIN_SHOP_EDIT;
static const PARA_ADMIN_PRODUCTS = _Paths.PARA_ADMIN_PRODUCTS;
static const PARA_ADMIN_PRODUCT_EDIT = _Paths.PARA_ADMIN_PRODUCT_EDIT;

// In _Paths
static const PARA_ADMIN_HOME = '/para-admin-home';
static const PARA_ADMIN_SHOP_EDIT = '/para-admin-shop-edit';
static const PARA_ADMIN_PRODUCTS = '/para-admin-products';
static const PARA_ADMIN_PRODUCT_EDIT = '/para-admin-product-edit';
```

## Notes

- Currency is MAD only (no USD)
- Primary color: #7E57C2 (purple)
- No mentions of "Glovo" or "Yassir" in UI
- Uses GetX for state management (consistent with app)
- Firebase Storage for image uploads
- Role-based access control via ownerUid

