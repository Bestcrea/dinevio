# Dinevio Integration Analysis
## Customer ↔ Driver ↔ Admin Panel Integration

**Date:** 2025-01-XX  
**Project:** Dinevio Multi-App Platform

---

## 📊 Vue d'ensemble

Dinevio est une plateforme multi-apps avec 3 applications distinctes partageant la même base de données Firebase :

1. **Customer App** (`customer/`) - Application client
2. **Driver App** (`driver/`) - Application chauffeur
3. **Admin Panel** (`admin/`) - Panel d'administration web

---

## 🔗 Collections Firestore partagées

### Collections principales (utilisées par les 3 apps)

| Collection | Customer | Driver | Admin | Description |
|------------|----------|--------|-------|-------------|
| `users` | ✅ | ✅ | ✅ | Utilisateurs clients |
| `drivers` | ✅ | ✅ | ✅ | Chauffeurs |
| `bookings` | ✅ | ✅ | ✅ | Réservations de courses (Cab Rides) |
| `intercity_ride` | ✅ | ✅ | ✅ | Courses intercity |
| `parcel_ride` | ✅ | ✅ | ✅ | Livraisons de colis |
| `settings` | ✅ | ✅ | ✅ | Paramètres globaux |
| `languages` | ✅ | ✅ | ✅ | Langues disponibles |
| `currencies` | ✅ | ✅ | ✅ | Devises |
| `vehicle_type` | ✅ | ✅ | ✅ | Types de véhicules |
| `wallet_transaction` | ✅ | ✅ | ✅ | Transactions de portefeuille |
| `support_ticket` | ✅ | ✅ | ✅ | Tickets de support |
| `support_reason` | ✅ | ✅ | ✅ | Raisons de support |
| `review` | ✅ | ✅ | ✅ | Avis clients |
| `notification` | ✅ | ✅ | ✅ | Notifications |
| `chat` | ✅ | ✅ | ❌ | Chat entre client et chauffeur |
| `transaction_log` | ✅ | ✅ | ❌ | Logs de transactions |

### Collections spécifiques

#### Customer uniquement
- `orders` - Commandes marketplace (Food, Grocery, Parapharmacy)
- `para_shops` - Boutiques parapharmacie
- `para_orders` - Commandes parapharmacie
- `Restaurant` - Restaurants (Food marketplace)

#### Driver uniquement
- `verify_driver` - Vérification des documents chauffeur
- `documents` - Documents chauffeur
- `bank_details` - Détails bancaires chauffeur
- `withdrawal_history` - Historique des retraits
- `subscription_plans` - Plans d'abonnement
- `subscription_history` - Historique d'abonnement

#### Admin uniquement
- `admin` - Comptes administrateurs
- `banner` - Bannières promotionnelles
- `coupon` - Codes promo (gestion)
- `country_tax` - Taxes par pays

---

## 🔄 Flux de données principaux

### 1. Cab Rides (Courses de taxi)

```
Customer App                    Driver App                    Admin Panel
     │                              │                              │
     ├─ Crée booking                │                              │
     │  (bookings/{bookingId})      │                              │
     │                              │                              │
     ├─ Status: bookingPlaced ────►│                              │
     │                              │                              │
     │                              ├─ Accepte booking             │
     │                              │  (driverId assigné)          │
     │                              │                              │
     │                              ├─ Status: bookingAccepted ───►│
     │                              │                              │
     │                              ├─ En route (ongoing)          │
     │                              │                              │
     │                              ├─ Status: bookingCompleted ──►│
     │                              │                              │
     └──────────────────────────────┴──────────────────────────────┘
```

**Collection:** `bookings/{bookingId}`

**Champs clés:**
- `customerId` - ID du client
- `driverId` - ID du chauffeur (assigné après acceptation)
- `bookingStatus` - État de la réservation
- `pickUpLocation` / `dropLocation` - Coordonnées GPS
- `paymentType` / `paymentStatus` - Paiement
- `subTotal` - Montant total

### 2. Parcel Rides (Livraisons de colis)

```
Customer App                    Driver App                    Admin Panel
     │                              │                              │
     ├─ Crée parcelRide             │                              │
     │  (parcel_ride/{rideId})      │                              │
     │                              │                              │
     ├─ Status: parcelPlaced ──────►│                              │
     │                              │                              │
     │                              ├─ Accepte parcel              │
     │                              │                              │
     │                              ├─ Status: parcelAccepted ─────►│
     │                              │                              │
     │                              ├─ Livré                       │
     │                              │                              │
     │                              ├─ Status: parcelDelivered ────►│
     │                              │                              │
     └──────────────────────────────┴──────────────────────────────┘
```

**Collection:** `parcel_ride/{rideId}`

### 3. Intercity Rides (Courses intercity)

```
Customer App                    Driver App                    Admin Panel
     │                              │                              │
     ├─ Crée intercityRide          │                              │
     │  (intercity_ride/{rideId})   │                              │
     │                              │                              │
     ├─ Status: intercityPlaced ───►│                              │
     │                              │                              │
     │                              ├─ Accepte intercity           │
     │                              │                              │
     │                              ├─ Status: intercityAccepted ──►│
     │                              │                              │
     └──────────────────────────────┴──────────────────────────────┘
```

**Collection:** `intercity_ride/{rideId}`

### 4. Chat (Communication client-chauffeur)

```
Customer App                    Driver App
     │                              │
     ├─ Envoie message              │
     │  (chat/{chatId}/messages)    │
     │                              │
     │                              ├─ Reçoit notification
     │                              │
     │                              ├─ Répond
     │                              │
     └──────────────────────────────┘
```

**Collection:** `chat/{chatId}/messages/{messageId}`

---

## 🎯 Points d'intégration identifiés

### ✅ Déjà connectés

1. **Bookings (Cab Rides)**
   - ✅ Customer crée `bookings/{bookingId}`
   - ✅ Driver écoute et accepte via `bookings` collection
   - ✅ Admin peut voir tous les bookings

2. **Parcel & Intercity**
   - ✅ Même pattern que bookings
   - ✅ Collections partagées fonctionnelles

3. **Users & Drivers**
   - ✅ Customer utilise `users/{uid}`
   - ✅ Driver utilise `drivers/{uid}`
   - ✅ Admin gère les deux

4. **Settings**
   - ✅ Tous partagent `settings/constant` et `settings/globalValue`
   - ✅ Configuration centralisée

### ⚠️ Points à améliorer

1. **Marketplace Orders (Food, Grocery, Parapharmacy)**
   - ❌ Customer crée `orders/{orderId}` mais Driver/Admin n'y ont pas accès
   - ⚠️ **Action:** Créer un système de notifications pour les drivers de livraison

2. **Real-time Location Updates**
   - ⚠️ Driver met à jour `drivers/{uid}/location` mais Customer ne l'écoute pas toujours
   - ⚠️ **Action:** Vérifier les listeners en temps réel

3. **Notifications Push**
   - ✅ Tous utilisent `notification` collection
   - ⚠️ **Action:** Vérifier que les notifications sont bien synchronisées

4. **Wallet Transactions**
   - ✅ Customer et Driver partagent `wallet_transaction`
   - ✅ Admin peut voir toutes les transactions
   - ✅ **OK**

---

## 🔧 Recommandations d'intégration

### 1. Unifier les modèles de données

**Problème:** Les modèles `BookingModel`, `ParcelModel`, `IntercityModel` peuvent avoir des différences entre apps.

**Solution:**
- Créer un package Dart partagé (`dinevio_shared_models`)
- Ou s'assurer que les modèles sont identiques dans les 3 apps

### 2. Système de notifications unifié

**Problème:** Chaque app gère les notifications différemment.

**Solution:**
- Utiliser Firebase Cloud Messaging (FCM) de manière cohérente
- Créer un service de notifications partagé

### 3. Marketplace Orders → Driver Delivery

**Problème:** Les commandes marketplace (Food, Grocery, Parapharmacy) ne sont pas assignées aux drivers.

**Solution:**
- Créer une collection `delivery_orders/{orderId}`
- Assigner aux drivers disponibles (comme pour `bookings`)
- Driver app doit écouter `delivery_orders` où `driverId == currentDriverId`

### 4. Real-time Sync

**Vérifications nécessaires:**
- ✅ Customer écoute `bookings/{bookingId}` pour les updates
- ✅ Driver écoute `bookings` où `driverId == currentDriverId`
- ⚠️ Vérifier que les updates de location sont en temps réel

### 5. Admin Panel - Gestion complète

**Fonctionnalités Admin à vérifier:**
- ✅ Gestion des drivers (CRUD)
- ✅ Gestion des users (CRUD)
- ✅ Voir tous les bookings
- ✅ Voir tous les parcel_ride
- ✅ Voir tous les intercity_ride
- ⚠️ Gestion des marketplace orders (à ajouter)
- ⚠️ Gestion des para_shops (à ajouter)

---

## 📋 Checklist d'intégration

### Customer → Driver

- [x] Customer crée `bookings` → Driver reçoit notification
- [x] Driver accepte → Customer voit `driverId` assigné
- [x] Driver met à jour status → Customer voit le changement
- [x] Chat fonctionne entre Customer et Driver
- [ ] **Marketplace orders** → Driver delivery (à implémenter)

### Customer → Admin

- [x] Admin peut voir tous les `bookings`
- [x] Admin peut voir tous les `users`
- [x] Admin peut voir tous les `parcel_ride` et `intercity_ride`
- [ ] Admin peut voir les `orders` marketplace (à vérifier)
- [ ] Admin peut gérer les `para_shops` (à vérifier)

### Driver → Admin

- [x] Admin peut voir tous les `drivers`
- [x] Admin peut activer/désactiver drivers
- [x] Admin peut voir les `wallet_transaction` des drivers
- [x] Admin peut gérer les `withdrawal_history`

---

## 🚀 Plan d'action recommandé

### Phase 1: Vérification et alignement (Priorité Haute)

1. **Vérifier les modèles de données**
   - Comparer `BookingModel` dans customer, driver, admin
   - S'assurer que les champs sont identiques
   - Aligner si nécessaire

2. **Vérifier les listeners Firestore**
   - Customer écoute bien les updates de `bookings`
   - Driver écoute bien les nouveaux `bookings`
   - Admin peut voir tous les bookings en temps réel

3. **Tester le flow complet**
   - Customer crée booking → Driver reçoit → Driver accepte → Customer voit update

### Phase 2: Marketplace Integration (Priorité Moyenne)

1. **Créer `delivery_orders` collection**
   - Structure similaire à `bookings`
   - Champs: `orderId`, `customerId`, `driverId`, `shopId`, `items`, `deliveryAddress`, `status`

2. **Driver app - Ajouter écoute `delivery_orders`**
   - Écouter où `driverId == currentDriverId`
   - Afficher les commandes de livraison

3. **Admin panel - Ajouter gestion `delivery_orders`**
   - Voir toutes les commandes marketplace
   - Assigner manuellement si nécessaire

### Phase 3: Améliorations (Priorité Basse)

1. **Real-time location tracking**
   - S'assurer que Customer voit la position du Driver en temps réel

2. **Notifications push améliorées**
   - Notifications pour marketplace orders
   - Notifications pour nouveaux drivers disponibles

3. **Analytics & Reporting**
   - Dashboard Admin avec statistiques
   - Rapports de performance drivers

---

## 📝 Notes techniques

### Firebase Project
- **Project ID:** `dinevio-app`
- **Tous les apps utilisent le même projet Firebase**
- ✅ Configuration déjà partagée

### Collections critiques

```dart
// Customer crée
bookings/{bookingId} {
  customerId: "customer_uid",
  bookingStatus: "bookingPlaced",
  driverId: null, // Assigné par Driver
  ...
}

// Driver accepte
bookings/{bookingId} {
  driverId: "driver_uid", // Assigné
  bookingStatus: "bookingAccepted",
  ...
}

// Admin voit tout
bookings/{bookingId} // Tous les champs
```

### Status Flow

**Bookings:**
```
bookingPlaced → bookingAccepted → bookingOngoing → bookingCompleted
                ↓
          bookingCancelled / bookingRejected
```

**Parcel:**
```
parcelPlaced → parcelAccepted → parcelOngoing → parcelDelivered
                ↓
          parcelCancelled / parcelRejected
```

---

## ✅ Conclusion

**État actuel:** Les 3 apps sont **déjà connectées** via Firebase et partagent les collections principales. Le système de bookings (Cab Rides) fonctionne entre Customer et Driver.

**Actions prioritaires:**
1. ✅ Vérifier que les modèles sont alignés
2. ⚠️ Implémenter marketplace orders → driver delivery
3. ⚠️ Vérifier les listeners en temps réel
4. ⚠️ Ajouter gestion marketplace dans Admin Panel

**Estimation:** 2-3 jours de travail pour finaliser l'intégration complète.

---

**Prochaines étapes:** Voulez-vous que je commence par vérifier l'alignement des modèles ou implémenter le système de delivery pour les marketplace orders ?

