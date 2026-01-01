# Grocery & Food Marketplace Implementation Guide

## Overview
This document outlines the complete implementation structure for Grocery and Food marketplaces, similar to the Parapharmacy marketplace, with Admin Panel, Cart, and Checkout functionality.

## Firestore Data Model

### Grocery Marketplace

#### Collections:
1. **grocery_shops/{shopId}**
   - Fields: ownerUid, name, coverImageUrl, logoUrl, category, ratingPercent, ratingCount, deliveryTimeMin, deliveryTimeMax, isOpen, opensAtText, isFreeDelivery, samePriceAsStore, isSponsored, createdAt

2. **grocery_shops/{shopId}/products/{productId}**
   - Fields: shopId, title, description, imageUrl, category, priceMad, discountPercent, badge, stock, isActive, createdAt

3. **users/{uid}/grocery_cart/current**
   - Fields: shopId, shopName, currency, subtotal, deliveryFee, total, updatedAt

4. **users/{uid}/grocery_cart/current/items/{itemId}**
   - Fields: productId, title, imageUrl, unitPriceMad, quantity, lineTotal, createdAt

5. **grocery_orders/{orderId}**
   - Fields: userId, shopId, shopName, status, currency, subtotal, deliveryFee, total, paymentMethod, deliveryAddressText, createdAt

6. **grocery_orders/{orderId}/items/{itemId}**
   - Fields: productId, title, imageUrl, unitPriceMad, quantity, lineTotal

### Food Marketplace

#### Collections:
1. **food_restaurants/{restaurantId}**
   - Fields: ownerUid, name, coverImageUrl, logoUrl, category, ratingPercent, ratingCount, deliveryTimeMin, deliveryTimeMax, isOpen, opensAtText, isFreeDelivery, isSponsored, createdAt

2. **food_restaurants/{restaurantId}/products/{productId}**
   - Fields: restaurantId, title, description, imageUrl, category, priceMad, discountPercent, badge, stock, isActive, createdAt

3. **users/{uid}/food_cart/current**
   - Fields: restaurantId, restaurantName, currency, subtotal, deliveryFee, total, updatedAt

4. **users/{uid}/food_cart/current/items/{itemId}**
   - Fields: productId, title, imageUrl, unitPriceMad, quantity, lineTotal, createdAt

5. **food_orders/{orderId}**
   - Fields: userId, restaurantId, restaurantName, status, currency, subtotal, deliveryFee, total, paymentMethod, deliveryAddressText, createdAt

6. **food_orders/{orderId}/items/{itemId}**
   - Fields: productId, title, imageUrl, unitPriceMad, quantity, lineTotal

## File Structure

### Grocery Marketplace

#### Models (✅ Created)
- `customer/lib/features/grocery/data/models/grocery_shop_model.dart`
- `customer/lib/features/grocery/data/models/grocery_product_model.dart`
- `customer/lib/features/grocery/data/models/grocery_cart_item_model.dart`
- `customer/lib/features/grocery/data/models/grocery_cart_model.dart`
- `customer/lib/features/grocery/data/models/grocery_order_model.dart`

#### Repositories (⏳ To Create)
- `customer/lib/features/grocery/data/repositories/grocery_repository.dart` - Fetch shops and products from Firestore
- `customer/lib/features/grocery/data/repositories/grocery_cart_repository.dart` - Manage cart operations
- `customer/lib/features/grocery/data/repositories/grocery_orders_repository.dart` - Manage orders

#### Controllers (⏳ To Create)
- `customer/lib/features/grocery/state/grocery_marketplace_controller.dart` - Marketplace state management
- `customer/lib/features/grocery/state/grocery_cart_controller.dart` - Cart state management
- `customer/lib/features/grocery/state/grocery_checkout_controller.dart` - Checkout process
- `customer/lib/features/grocery/state/grocery_orders_controller.dart` - Orders management

#### UI Pages (⏳ To Create)
- `customer/lib/features/grocery/presentation/pages/marketplace/grocery_marketplace_page.dart` - Main marketplace (refactor existing GroceryHomePage)
- `customer/lib/features/grocery/presentation/pages/shop/grocery_shop_details_page.dart` - Shop details with products
- `customer/lib/features/grocery/presentation/pages/cart/grocery_cart_page.dart` - Cart page
- `customer/lib/features/grocery/presentation/pages/checkout/grocery_checkout_page.dart` - Checkout page
- `customer/lib/features/grocery/presentation/pages/orders/grocery_orders_page.dart` - Orders list
- `customer/lib/features/grocery/presentation/pages/orders/grocery_order_details_page.dart` - Order details

#### Admin Pages (⏳ To Create)
- `customer/lib/features/grocery/presentation/pages/admin/grocery_admin_home_page.dart` - Admin home
- `customer/lib/features/grocery/presentation/pages/admin/grocery_admin_shop_edit_page.dart` - Create/edit shop
- `customer/lib/features/grocery/presentation/pages/admin/grocery_admin_products_page.dart` - List products
- `customer/lib/features/grocery/presentation/pages/admin/grocery_admin_product_edit_page.dart` - Create/edit product

### Food Marketplace

#### Models (⏳ To Create)
- `customer/lib/features/food/data/models/food_restaurant_model.dart` (✅ Created)
- `customer/lib/features/food/data/models/food_product_model.dart`
- `customer/lib/features/food/data/models/food_cart_item_model.dart`
- `customer/lib/features/food/data/models/food_cart_model.dart`
- `customer/lib/features/food/data/models/food_order_model.dart`

#### Repositories (⏳ To Create)
- `customer/lib/features/food/data/repositories/food_repository.dart`
- `customer/lib/features/food/data/repositories/food_cart_repository.dart`
- `customer/lib/features/food/data/repositories/food_orders_repository.dart`

#### Controllers (⏳ To Create)
- `customer/lib/features/food/state/food_marketplace_controller.dart`
- `customer/lib/features/food/state/food_cart_controller.dart`
- `customer/lib/features/food/state/food_checkout_controller.dart`
- `customer/lib/features/food/state/food_orders_controller.dart`

#### UI Pages (⏳ To Create)
- `customer/lib/features/food/presentation/pages/marketplace/food_marketplace_page.dart` - Main marketplace (refactor existing FoodView)
- `customer/lib/features/food/presentation/pages/restaurant/food_restaurant_details_page.dart` - Restaurant details with menu
- `customer/lib/features/food/presentation/pages/cart/food_cart_page.dart` - Cart page
- `customer/lib/features/food/presentation/pages/checkout/food_checkout_page.dart` - Checkout page
- `customer/lib/features/food/presentation/pages/orders/food_orders_page.dart` - Orders list
- `customer/lib/features/food/presentation/pages/orders/food_order_details_page.dart` - Order details

#### Admin Pages (⏳ To Create)
- `customer/lib/features/food/presentation/pages/admin/food_admin_home_page.dart` - Admin home
- `customer/lib/features/food/presentation/pages/admin/food_admin_restaurant_edit_page.dart` - Create/edit restaurant
- `customer/lib/features/food/presentation/pages/admin/food_admin_products_page.dart` - List menu items
- `customer/lib/features/food/presentation/pages/admin/food_admin_product_edit_page.dart` - Create/edit menu item

## Routes to Add

### Grocery Routes
- `GROCERY_MARKETPLACE` - `/grocery-marketplace`
- `GROCERY_SHOP_DETAILS` - `/grocery-shop-details/:shopId`
- `GROCERY_CART` - `/grocery-cart`
- `GROCERY_CHECKOUT` - `/grocery-checkout`
- `GROCERY_ORDERS` - `/grocery-orders`
- `GROCERY_ORDER_DETAILS` - `/grocery-order-details/:orderId`

### Food Routes
- `FOOD_MARKETPLACE` - `/food-marketplace`
- `FOOD_RESTAURANT_DETAILS` - `/food-restaurant-details/:restaurantId`
- `FOOD_CART` - `/food-cart`
- `FOOD_CHECKOUT` - `/food-checkout`
- `FOOD_ORDERS` - `/food-orders`
- `FOOD_ORDER_DETAILS` - `/food-order-details/:orderId`

## Key Features to Implement

1. **Single-Shop/Restaurant Cart Enforcement**: Similar to Parapharmacy, users can only have items from one shop/restaurant at a time
2. **Admin Panel Access Control**: Check `ownerUid` matches current user
3. **Firebase Storage**: Upload cover images, logos, and product images
4. **Real-time Updates**: Use Firestore streams for live data
5. **Error Handling**: Defensive coding with null checks and try-catch blocks
6. **Loading States**: Skeleton loaders instead of spinners
7. **Empty States**: Professional empty state UIs with illustrations
8. **Currency**: All prices in MAD only

## Reference Implementation
See `customer/lib/features/para/` for complete reference implementation of:
- Models structure
- Repository patterns
- Controller patterns
- UI components
- Admin pages
- Cart and checkout flows

## Next Steps
1. Complete Food models (product, cart, order)
2. Create repositories for both Grocery and Food
3. Create controllers for both marketplaces
4. Refactor existing GroceryHomePage and FoodView to marketplace pages
5. Create cart, checkout, and orders pages
6. Create admin pages
7. Add routes
8. Test complete flow

