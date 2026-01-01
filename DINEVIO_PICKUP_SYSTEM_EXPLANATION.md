# 🚗 Système de Pickup - Dinevio

## Comment le chauffeur sait où venir chercher le client ?

---

## 📍 Vue d'ensemble

Quand un client réserve une course via l'application Dinevio, le système enregistre **deux informations essentielles** :

1. **Les coordonnées GPS** (latitude/longitude) du point de pickup
2. **L'adresse textuelle** du point de pickup

Ces informations sont stockées dans Firestore et transmises au chauffeur en temps réel.

---

## 🔄 Flux complet : De la réservation au pickup

### Étape 1 : Le client sélectionne son point de pickup

#### Options disponibles pour le client :

**A. Localisation actuelle (GPS)**
- Le client peut utiliser sa position GPS actuelle
- Par défaut : `"Current Location"` dans le champ pickup
- Les coordonnées sont automatiquement récupérées via `Utils.getCurrentLocation()`

**B. Recherche d'adresse**
- Le client peut rechercher une adresse via Google Places API
- Utilise le widget `PlacePicker` pour sélectionner un lieu
- L'adresse est convertie en coordonnées GPS

**C. Sélection manuelle sur la carte**
- Le client peut déplacer un marqueur sur la carte Google Maps
- Les coordonnées sont mises à jour en temps réel

#### Code (Customer App) :

```dart
// customer/lib/app/modules/select_location/controllers/select_location_controller.dart

void setBookingData(bool isClear) {
  // Enregistrement des coordonnées de pickup
  bookingModel.value.pickUpLocation = LocationLatLng(
    latitude: sourceLocation!.latitude,
    longitude: sourceLocation!.longitude
  );
  
  // Enregistrement de l'adresse textuelle
  bookingModel.value.pickUpLocationAddress = 
    mapModel.value!.originAddresses!.first;
  
  // Position GeoFire pour requêtes géographiques
  GeoFirePoint position = GeoFlutterFire().point(
    latitude: sourceLocation!.latitude,
    longitude: sourceLocation!.longitude
  );
  bookingModel.value.position = Positions(
    geoPoint: position.geoPoint,
    geohash: position.hash
  );
}
```

---

### Étape 2 : Création du booking dans Firestore

Quand le client confirme la réservation, un document est créé dans Firestore :

**Collection:** `bookings/{bookingId}`

**Structure du document :**
```json
{
  "id": "booking_123456",
  "customerId": "customer_uid",
  "driverId": null,  // Assigné après acceptation
  "bookingStatus": "booking_placed",
  
  // ⭐ COORDONNÉES DE PICKUP
  "pickUpLocation": {
    "latitude": 33.5731,
    "longitude": -7.5898
  },
  
  // ⭐ ADRESSE TEXTUELLE DE PICKUP
  "pickUpLocationAddress": "123 Avenue Mohammed V, Casablanca, Maroc",
  
  // Position GeoFire (pour recherche géographique)
  "position": {
    "geohash": "sf3x...",
    "geoPoint": {
      "latitude": 33.5731,
      "longitude": -7.5898
    }
  },
  
  // Coordonnées de destination
  "dropLocation": {
    "latitude": 33.5845,
    "longitude": -7.6123
  },
  "dropLocationAddress": "456 Boulevard Zerktouni, Casablanca, Maroc",
  
  "createAt": "2025-01-XX...",
  "updateAt": "2025-01-XX...",
  ...
}
```

---

### Étape 3 : Le chauffeur reçoit la notification

#### A. Notification Push (FCM)
- Le système envoie une notification push au chauffeur
- Contient le `bookingId` dans le payload

#### B. Affichage sur l'écran Home
- Le chauffeur voit la nouvelle course sur son écran d'accueil
- Écoute en temps réel : `bookings` où `bookingStatus == "booking_placed"` et `driverId == null`

#### Code (Driver App) :

```dart
// driver/lib/app/modules/home/views/widgets/new_ride_view.dart

// Écoute des nouvelles courses
FireStoreUtils.fireStore
  .collection(CollectionName.bookings)
  .where('bookingStatus', isEqualTo: BookingStatus.bookingPlaced)
  .where('driverId', isNull: true)  // Pas encore assigné
  .snapshots()
  .listen((snapshot) {
    // Affiche les nouvelles courses disponibles
  });
```

---

### Étape 4 : Le chauffeur accepte la course

Quand le chauffeur accepte :

1. **Le `driverId` est assigné**
   ```dart
   bookingModel.value.driverId = FireStoreUtils.getCurrentUid();
   bookingModel.value.bookingStatus = BookingStatus.bookingAccepted;
   ```

2. **Le booking est mis à jour dans Firestore**
   ```dart
   FireStoreUtils.setBooking(bookingModel.value);
   ```

3. **Le client reçoit une notification**
   - "Your Ride is Accepted"
   - Le client peut maintenant voir le chauffeur assigné

---

### Étape 5 : Le chauffeur voit les détails du pickup

#### Écran "Booking Details" (`booking_details_view.dart`)

Le chauffeur voit :

**A. Widget PickDropPointView**
```dart
PickDropPointView(
  pickUpAddress: bookingModel.value.pickUpLocationAddress ?? '',
  dropAddress: bookingModel.value.dropLocationAddress ?? '',
  isDirectionIconShown: true,
  onDirectionTap: () {
    // Ouvre la navigation Google Maps
  },
)
```

**B. Informations affichées :**
- 📍 **Adresse de pickup** : `pickUpLocationAddress`
  - Exemple : "123 Avenue Mohammed V, Casablanca, Maroc"
- 📍 **Adresse de destination** : `dropLocationAddress`
- 🗺️ **Bouton "Directions"** : Ouvre Google Maps avec l'itinéraire

**C. Carte interactive**
- Marqueur rouge : Point de pickup
- Marqueur bleu : Point de destination
- Marqueur vert : Position actuelle du chauffeur
- Ligne bleue : Itinéraire calculé

---

### Étape 6 : Navigation vers le pickup

#### Option 1 : Navigation via Google Maps

Quand le chauffeur clique sur "Directions" :

```dart
// Ouvre Google Maps avec l'itinéraire
Constant().launchMap(
  latitude: bookingModel.value.pickUpLocation!.latitude,
  longitude: bookingModel.value.pickUpLocation!.longitude,
);
```

**Résultat :**
- Google Maps s'ouvre
- Itinéraire calculé automatiquement
- Navigation guidée activée

#### Option 2 : Suivi en temps réel dans l'app

Le chauffeur peut utiliser l'écran "Track Ride" (`track_ride_screen`) :

**Fonctionnalités :**
- ✅ Carte Google Maps intégrée
- ✅ Marqueur pickup (rouge)
- ✅ Marqueur destination (bleu)
- ✅ Marqueur chauffeur (vert, mis à jour en temps réel)
- ✅ Itinéraire tracé (polyline bleue)
- ✅ Distance et temps estimés

**Code :**
```dart
// driver/lib/app/modules/track_ride_screen/controllers/track_ride_screen_controller.dart

void getPolyline() {
  // Calcule l'itinéraire entre :
  // - Position actuelle du chauffeur
  // - Point de pickup
  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    googleApiKey: Constant.mapAPIKey,
    request: PolylineRequest(
      origin: PointLatLng(
        driverUserModel.value.location!.latitude,
        driverUserModel.value.location!.longitude
      ),
      destination: PointLatLng(
        bookingModel.value.pickUpLocation!.latitude,
        bookingModel.value.pickUpLocation!.longitude
      ),
      mode: TravelMode.driving,
    ),
  );
  
  // Affiche l'itinéraire sur la carte
  _addPolyLine(polylineCoordinates);
}
```

---

## 📱 Interface du chauffeur

### Écran "Booking Details"

```
┌─────────────────────────────────────┐
│  Ride Detail                        │
├─────────────────────────────────────┤
│                                     │
│  👤 Customer Info                   │
│  Name: John Doe                     │
│  📞 +212 6XX XXX XXX                │
│                                     │
│  📍 Pickup Location                 │
│  ┌─────────────────────────────┐   │
│  │ 🚩 123 Avenue Mohammed V     │   │
│  │    Casablanca, Maroc         │   │
│  │    [Directions →]            │   │
│  └─────────────────────────────┘   │
│                                     │
│  📍 Drop Location                   │
│  ┌─────────────────────────────┐   │
│  │ 🎯 456 Boulevard Zerktouni   │   │
│  │    Casablanca, Maroc         │   │
│  └─────────────────────────────┘   │
│                                     │
│  💰 Price: 45.00 MAD                │
│  🚗 Vehicle: Sedan                  │
│                                     │
│  [Cancel]  [Accept]                 │
└─────────────────────────────────────┘
```

### Écran "Track Ride" (après acceptation)

```
┌─────────────────────────────────────┐
│  Track Ride                         │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │    🚩 (Pickup)              │   │
│  │                             │   │
│  │         ╱╲                  │   │
│  │        ╱  ╲                 │   │
│  │       ╱    ╲                │   │
│  │      ╱      ╲               │   │
│  │     ╱        ╲              │   │
│  │    🚗 (You)   🎯 (Drop)     │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  Distance: 2.5 km                   │
│  ETA: 8 minutes                      │
│                                     │
│  [Open in Google Maps]              │
└─────────────────────────────────────┘
```

---

## 🔍 Recherche géographique des chauffeurs

### Comment les chauffeurs proches sont trouvés ?

Le système utilise **GeoFire** pour trouver les chauffeurs disponibles près du point de pickup :

```dart
// Recherche des chauffeurs dans un rayon de X km
GeoFirePoint center = GeoFlutterFire().point(
  latitude: pickUpLocation.latitude,
  longitude: pickUpLocation.longitude
);

// Requête GeoFire
Stream<List<DocumentSnapshot>> stream = geo
  .collection(collectionRef: driversRef)
  .within(
    center: center,
    radius: radius,  // Ex: 5 km
    field: 'position'
  )
  .where('isOnline', isEqualTo: true)
  .where('isActive', isEqualTo: true)
  .where('bookingId', isEqualTo: '')  // Disponible
  .snapshots();
```

**Résultat :**
- Seuls les chauffeurs dans le rayon sont notifiés
- Optimise les notifications et réduit la latence

---

## 📊 Données stockées dans le booking

### Structure complète (BookingModel)

```dart
class BookingModel {
  // Identifiants
  String? id;
  String? customerId;
  String? driverId;  // Assigné après acceptation
  
  // ⭐ PICKUP - Coordonnées GPS
  LocationLatLng? pickUpLocation;  // {latitude, longitude}
  
  // ⭐ PICKUP - Adresse textuelle
  String? pickUpLocationAddress;  // "123 Avenue Mohammed V..."
  
  // Position GeoFire (pour recherche)
  Positions? position;  // {geoPoint, geohash}
  
  // DESTINATION
  LocationLatLng? dropLocation;
  String? dropLocationAddress;
  
  // Statut
  String? bookingStatus;  // booking_placed, booking_accepted, etc.
  
  // Autres
  VehicleTypeModel? vehicleType;
  String? subTotal;
  Timestamp? createAt;
  Timestamp? updateAt;
  ...
}
```

---

## 🎯 Résumé : Où le chauffeur vient chercher le client ?

### Réponse directe :

**Le chauffeur vient chercher le client à l'adresse et aux coordonnées GPS que le client a sélectionnées lors de la réservation.**

### Informations disponibles pour le chauffeur :

1. ✅ **Coordonnées GPS précises** (`pickUpLocation.latitude/longitude`)
   - Utilisées pour la navigation GPS
   - Précision : ~5-10 mètres

2. ✅ **Adresse textuelle** (`pickUpLocationAddress`)
   - Exemple : "123 Avenue Mohammed V, Casablanca, Maroc"
   - Affichée dans l'interface du chauffeur

3. ✅ **Carte interactive**
   - Marqueur sur Google Maps
   - Itinéraire calculé automatiquement

4. ✅ **Navigation intégrée**
   - Bouton "Directions" → Ouvre Google Maps
   - Navigation guidée jusqu'au point de pickup

### Options du client pour définir le pickup :

- 📍 **Position GPS actuelle** (par défaut)
- 🔍 **Recherche d'adresse** (Google Places)
- 🗺️ **Sélection sur la carte** (drag & drop)

---

## 🔄 Flux visuel complet

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENT (Customer App)                     │
└─────────────────────────────────────────────────────────────┘
                          │
                          │ 1. Sélectionne pickup
                          │    - GPS actuel OU
                          │    - Recherche adresse OU
                          │    - Sélection sur carte
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│              Firestore: bookings/{bookingId}                │
│  {                                                           │
│    pickUpLocation: {lat: 33.5731, lng: -7.5898},           │
│    pickUpLocationAddress: "123 Avenue Mohammed V...",        │
│    bookingStatus: "booking_placed"                            │
│  }                                                           │
└─────────────────────────────────────────────────────────────┘
                          │
                          │ 2. Notification push
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                    CHAUFFEUR (Driver App)                   │
│                                                              │
│  📱 Notification: "Nouvelle course disponible"              │
│  🏠 Home Screen: Affiche la nouvelle course                 │
│  📋 Booking Details:                                          │
│     - Adresse pickup: "123 Avenue Mohammed V..."             │
│     - Coordonnées: 33.5731, -7.5898                          │
│     - [Bouton Directions]                                    │
│                                                              │
│  ✅ Accepte la course                                        │
│     → driverId assigné                                       │
│     → bookingStatus = "booking_accepted"                    │
│                                                              │
│  🗺️ Track Ride Screen:                                       │
│     - Carte avec marqueur pickup                            │
│     - Itinéraire calculé                                    │
│     - Navigation en temps réel                              │
│                                                              │
│  🚗 Se dirige vers le pickup                                │
│     - Google Maps navigation                                │
│     - Suivi en temps réel                                    │
│                                                              │
│  📍 Arrive au point de pickup                               │
│     - Demande OTP au client                                 │
│     - Client confirme OTP                                   │
│     - Course commence                                       │
└─────────────────────────────────────────────────────────────┘
```

---

## ✅ Conclusion

**Le chauffeur sait exactement où venir chercher le client grâce à :**

1. ✅ **Coordonnées GPS précises** stockées dans `pickUpLocation`
2. ✅ **Adresse textuelle** dans `pickUpLocationAddress`
3. ✅ **Carte interactive** avec marqueur et itinéraire
4. ✅ **Navigation intégrée** vers Google Maps
5. ✅ **Suivi en temps réel** de la position du chauffeur

Le système est **robuste, précis et facile à utiliser** pour les deux parties (client et chauffeur).

---

**Document créé le:** 2025-01-XX  
**Version:** 1.0.0

