# 📱 Dinevio - Applications Séparées

## Question : Le chauffeur doit-il télécharger la même application que le client ?

### ❌ **NON** - Ce sont **2 applications distinctes** !

---

## 🎯 Applications Dinevio

Dinevio est composé de **3 applications distinctes** :

### 1. 📱 **Dinevio Customer** (Application Client)
- **Nom de l'app :** `Dinevio`
- **Package Android :** `com.mytaxi.customers`
- **Bundle iOS :** `com.mytaxi.customers`
- **Description :** "Dinevio Customer - Book your rides easily."
- **Dossier :** `customer/`

**Fonctionnalités :**
- ✅ Réserver des courses (Cab Rides)
- ✅ Réserver des courses intercity
- ✅ Commander des livraisons de colis (Parcel)
- ✅ Commander de la nourriture (Food Marketplace)
- ✅ Commander des produits d'épicerie (Grocery Marketplace)
- ✅ Commander des produits de parapharmacie (Parapharmacy Marketplace)
- ✅ Payer avec Stripe (Apple Pay, Google Pay, Cash)
- ✅ Suivre les courses en temps réel
- ✅ Chat avec les chauffeurs
- ✅ Gérer le profil et le portefeuille

---

### 2. 🚗 **Dinevio Driver** (Application Chauffeur)
- **Nom de l'app :** `Dinevio Driver`
- **Package Android :** `com.mytaxi.driver` (probablement)
- **Bundle iOS :** `com.mytaxi.driver` (probablement)
- **Description :** "Dinevio Driver - Manage your rides and earnings."
- **Dossier :** `driver/`

**Fonctionnalités :**
- ✅ Recevoir des demandes de courses
- ✅ Accepter/Rejeter des courses
- ✅ Suivre la navigation vers le pickup
- ✅ Gérer les courses (Cab, Intercity, Parcel)
- ✅ Demander et vérifier les OTP
- ✅ Chat avec les clients
- ✅ Gérer le portefeuille et les retraits
- ✅ Voir les statistiques et relevés
- ✅ Gérer l'abonnement
- ✅ Upload de documents

---

### 3. 💻 **Dinevio Admin** (Panel d'Administration)
- **Nom :** `Dinevio Admin`
- **Type :** Application Web Flutter
- **Description :** "Dinevio Admin - Taxi service management platform."
- **Dossier :** `admin/`

**Fonctionnalités :**
- ✅ Gérer les chauffeurs
- ✅ Gérer les clients
- ✅ Voir toutes les courses
- ✅ Gérer les paiements
- ✅ Configurer les paramètres
- ✅ Gérer les véhicules et tarifs

---

## 📊 Comparaison des Applications

| Caractéristique | Customer App | Driver App |
|----------------|--------------|------------|
| **Nom affiché** | Dinevio | Dinevio Driver |
| **Package ID** | `com.mytaxi.customers` | `com.mytaxi.driver` |
| **Collection Firestore** | `users/{uid}` | `drivers/{uid}` |
| **Écran principal** | Home avec services | Home avec courses disponibles |
| **Fonction principale** | Réserver des courses | Accepter des courses |
| **Navigation** | Vers destinations | Vers pickups |
| **Paiements** | Payer les courses | Recevoir les paiements |
| **Notifications** | "Votre course est acceptée" | "Nouvelle course disponible" |

---

## 🔄 Comment les applications communiquent

### Même base de données Firebase

Les 3 applications utilisent **le même projet Firebase** mais accèdent à des collections différentes :

```
Firebase Project: dinevio-app
├── customers/ (Customer App)
│   ├── users/{uid}
│   ├── bookings/{bookingId} (créés par customer)
│   └── orders/{orderId} (marketplace)
│
├── drivers/ (Driver App)
│   ├── drivers/{uid}
│   ├── bookings/{bookingId} (acceptés par driver)
│   └── wallet_transaction/{id}
│
└── admin/ (Admin Panel)
    ├── Accès à TOUTES les collections
    └── Gestion complète
```

### Communication via Firestore

**Exemple : Customer crée une course → Driver la reçoit**

```
1. Customer App
   └─> Crée booking dans Firestore
       bookings/{bookingId} {
         customerId: "customer_123",
         driverId: null,
         bookingStatus: "booking_placed",
         pickUpLocation: {...},
         ...
       }

2. Driver App
   └─> Écoute les nouveaux bookings
       .where('bookingStatus', isEqualTo: 'booking_placed')
       .where('driverId', isNull: true)
       └─> Reçoit la notification en temps réel
           └─> Affiche la nouvelle course disponible

3. Driver accepte
   └─> Met à jour le booking
       bookings/{bookingId} {
         driverId: "driver_456",
         bookingStatus: "booking_accepted"
       }

4. Customer App
   └─> Écoute les updates du booking
       └─> Voit que driverId est assigné
           └─> Affiche "Votre course est acceptée"
```

---

## 📥 Téléchargement des Applications

### Sur Google Play Store

**Customer App :**
- Rechercher : "Dinevio"
- Package : `com.mytaxi.customers`
- Icône : Logo Dinevio (violet)

**Driver App :**
- Rechercher : "Dinevio Driver"
- Package : `com.mytaxi.driver`
- Icône : Logo Dinevio Driver (différent)

### Sur Apple App Store

**Customer App :**
- Rechercher : "Dinevio"
- Bundle ID : `com.mytaxi.customers`

**Driver App :**
- Rechercher : "Dinevio Driver"
- Bundle ID : `com.mytaxi.driver`

---

## 🔐 Authentification

### Collections Firestore séparées

**Customer App :**
- Collection : `users/{uid}`
- Type : `UserModel`
- Champs : `customerId`, `fullName`, `phoneNumber`, etc.

**Driver App :**
- Collection : `drivers/{uid}`
- Type : `DriverUserModel`
- Champs : `driverId`, `fullName`, `isOnline`, `isActive`, `vehicleDetails`, etc.

### Même Firebase Auth

Les deux apps utilisent **Firebase Authentication** mais :
- Les clients s'inscrivent via Customer App → Créent un compte dans `users`
- Les chauffeurs s'inscrivent via Driver App → Créent un compte dans `drivers`

---

## 🎨 Interface Utilisateur

### Customer App
```
┌─────────────────────────────┐
│  Dinevio                     │
├─────────────────────────────┤
│  🏠 Home                     │
│  🚗 Rides                    │
│  📦 Parcel                   │
│  🍔 Food                     │
│  🛒 Grocery                  │
│  💊 Parapharmacy             │
│  👤 Profile                  │
└─────────────────────────────┘
```

### Driver App
```
┌─────────────────────────────┐
│  Dinevio Driver              │
├─────────────────────────────┤
│  🏠 Home                     │
│  🚕 New Ride Available       │
│  📋 Cab Rides                │
│  🚌 Intercity Rides          │
│  📦 Parcel Rides             │
│  💰 My Wallet                │
│  👤 Profile                  │
└─────────────────────────────┘
```

---

## ✅ Avantages de la séparation

### 1. **Sécurité**
- ✅ Collections séparées (`users` vs `drivers`)
- ✅ Permissions différentes
- ✅ Pas d'accès croisé aux données sensibles

### 2. **Expérience Utilisateur**
- ✅ Interface optimisée pour chaque rôle
- ✅ Fonctionnalités spécifiques à chaque app
- ✅ Pas de confusion entre client et chauffeur

### 3. **Développement**
- ✅ Code séparé et maintenable
- ✅ Déploiements indépendants
- ✅ Versions différentes possibles

### 4. **Performance**
- ✅ Apps plus légères (seulement les fonctionnalités nécessaires)
- ✅ Moins de code à charger
- ✅ Meilleure optimisation

---

## 🔍 Vérification dans le code

### Customer App (`customer/pubspec.yaml`)
```yaml
name: customer
description: Dinevio Customer - Book your rides easily.
```

### Driver App (`driver/pubspec.yaml`)
```yaml
name: dinevio_driver
description: Dinevio Driver - Manage your rides and earnings.
```

### Info.plist (iOS)

**Customer :**
```xml
<key>CFBundleDisplayName</key>
<string>Dinevio</string>
<key>CFBundleName</key>
<string>dinevio_customer</string>
```

**Driver :**
```xml
<key>CFBundleDisplayName</key>
<string>Dinevio Driver</string>
<key>CFBundleName</key>
<string>dinevio_driver</string>
```

---

## 📝 Résumé

### ❌ **NON**, le chauffeur ne télécharge **PAS** la même application que le client.

### ✅ **OUI**, il y a **2 applications distinctes** :

1. **Dinevio** (Customer App)
   - Pour les clients
   - Package : `com.mytaxi.customers`
   - Fonction : Réserver des courses

2. **Dinevio Driver** (Driver App)
   - Pour les chauffeurs
   - Package : `com.mytaxi.driver`
   - Fonction : Accepter et gérer des courses

### 🔗 **Communication :**
- Les deux apps communiquent via **Firebase Firestore**
- Même projet Firebase, collections différentes
- Temps réel via listeners Firestore

---

## 🚀 Déploiement

### Build séparé

**Customer App :**
```bash
cd customer
flutter build apk --release
# Génère : customer.apk (com.mytaxi.customers)
```

**Driver App :**
```bash
cd driver
flutter build apk --release
# Génère : driver.apk (com.mytaxi.driver)
```

### Stores séparés

- **Google Play Store :** 2 listings différents
- **Apple App Store :** 2 listings différents

---

**Document créé le :** 2025-01-XX  
**Version :** 1.0.0

