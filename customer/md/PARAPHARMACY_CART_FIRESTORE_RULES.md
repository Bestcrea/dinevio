# Firestore Security Rules for Parapharmacy Cart & Orders

## Required Firestore Rules

Add these rules to your Firebase Console > Firestore > Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Helper function to check if user owns the resource
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    // ========== USER CARTS ==========
    // Users can only read/write their own cart
    match /users/{userId}/para_cart/current {
      allow read, write: if isOwner(userId);
      
      // Cart items subcollection
      match /items/{itemId} {
        allow read, write: if isOwner(userId);
      }
    }
    
    // ========== ORDERS ==========
    match /para_orders/{orderId} {
      // Users can create their own orders
      allow create: if isAuthenticated() 
        && request.resource.data.userId == request.auth.uid;
      
      // Users can read their own orders
      allow read: if isAuthenticated() 
        && resource.data.userId == request.auth.uid;
      
      // Only server/admin can update order status
      // For now, allow users to update (can restrict later with admin role)
      allow update: if isAuthenticated() 
        && resource.data.userId == request.auth.uid;
      
      // Order items subcollection
      match /items/{itemId} {
        allow read: if isAuthenticated() 
          && get(/databases/$(database)/documents/para_orders/$(orderId)).data.userId == request.auth.uid;
        
        allow create: if isAuthenticated() 
          && get(/databases/$(database)/documents/para_orders/$(orderId)).data.userId == request.auth.uid;
      }
    }
    
    // ========== SHOPS (Read-only for customers) ==========
    match /para_shops/{shopId} {
      allow read: if true; // Public read access
      allow write: if false; // Only admin/owners can write (handled separately)
      
      // Products (read-only for customers)
      match /products/{productId} {
        allow read: if true;
        allow write: if false;
      }
    }
  }
}
```

## Notes

1. **Cart Security**: Users can only access their own cart (`users/{uid}/para_cart/current`).

2. **Orders Security**:
   - Users can create orders where `userId` matches their `auth.uid`.
   - Users can read their own orders.
   - Order status updates should ideally be restricted to admin/server, but for now allow users to update (can be restricted later).

3. **Shops & Products**: Public read access for marketplace browsing. Write access should be restricted to shop owners (handled via admin panel with `ownerUid` checks).

4. **Testing**: After deploying these rules, test with:
   - Authenticated user creating/reading their cart
   - Authenticated user creating/reading their orders
   - Unauthenticated user trying to access cart (should fail)
   - User trying to access another user's cart (should fail)

