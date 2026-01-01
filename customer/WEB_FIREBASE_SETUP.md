# Firebase Web Setup - Dinevio

## Configuration Firebase pour le Web

### ✅ Configuration complétée

La configuration Firebase pour le web a été intégrée dans l'application Flutter.

### Fichiers modifiés

1. **`customer/web/index.html`**
   - Ajout des scripts Firebase SDK (version 10.13.2)
   - Initialisation de Firebase avec la configuration web
   - Services Firebase initialisés : Auth, Firestore, Storage, Messaging, Functions

2. **`customer/lib/firebase_options.dart`**
   - Configuration web déjà présente et correcte :
     ```dart
     static const FirebaseOptions web = FirebaseOptions(
       apiKey: 'AIzaSyDTM14vfTpBZ7SwmFiKbhhEyjrBv24D3fY',
       appId: '1:773514102852:web:2f0f581fac87e126de1411',
       messagingSenderId: '773514102852',
       projectId: 'dinevio-app',
       authDomain: 'dinevio-app.firebaseapp.com',
       storageBucket: 'dinevio-app.firebasestorage.app',
     );
     ```

3. **`customer/lib/main.dart`**
   - Initialisation Firebase déjà configurée avec `DefaultFirebaseOptions.currentPlatform`
   - Support automatique du web via `kIsWeb`

---

## Services Firebase disponibles pour le Web

### ✅ Auth (Firebase Authentication)
- Phone Authentication
- Google Sign-In
- Email/Password (si configuré)

### ✅ Firestore (Cloud Firestore)
- Base de données NoSQL
- Collections : `users`, `orders`, `para_shops`, etc.

### ✅ Storage (Firebase Storage)
- Upload d'images (avatars, produits, etc.)
- Paths : `users/{uid}/avatar.jpg`, `para_shops/{shopId}/cover.jpg`

### ✅ Messaging (Cloud Messaging)
- Notifications push
- Web push notifications (si configuré)

### ✅ Functions (Cloud Functions)
- `createPaymentIntent` pour Stripe
- Autres fonctions backend

---

## Comment ça fonctionne

### 1. Initialisation automatique

Flutter initialise Firebase automatiquement via `main.dart` :

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

Pour le web, `DefaultFirebaseOptions.currentPlatform` retourne automatiquement `web`.

### 2. Scripts Firebase dans index.html

Les scripts Firebase SDK sont chargés dans `index.html` avant le chargement de Flutter :

```html
<script type="module">
  import { initializeApp } from "https://www.gstatic.com/firebasejs/10.13.2/firebase-app.js";
  // ... autres imports
  
  const app = initializeApp(firebaseConfig);
  // Services initialisés et disponibles globalement
</script>
```

### 3. Utilisation dans Flutter

Les packages Flutter Firebase utilisent automatiquement la configuration :

```dart
// Exemple : Firebase Auth
FirebaseAuth.instance.signInWithPhoneNumber(...)

// Exemple : Firestore
FirebaseFirestore.instance.collection('users').doc(uid).get()

// Exemple : Storage
FirebaseStorage.instance.ref('users/$uid/avatar.jpg').putFile(file)
```

---

## Test de la configuration

### 1. Build pour le web

```bash
cd customer
flutter build web
```

### 2. Serveur local de test

```bash
cd customer
flutter run -d chrome
```

### 3. Vérifier l'initialisation

Ouvrez la console du navigateur (F12) et vérifiez :
- `Firebase initialized for web` dans les logs
- Aucune erreur Firebase dans la console

---

## Configuration Firebase Console

### Vérifications requises

1. **Authentication**
   - ✅ Phone Auth activé
   - ✅ Google Sign-In activé
   - ✅ Domaines autorisés : `localhost`, `dinevio-app.firebaseapp.com`

2. **Firestore**
   - ✅ Règles de sécurité configurées
   - ✅ Collections créées

3. **Storage**
   - ✅ Règles de sécurité configurées
   - ✅ Bucket : `dinevio-app.firebasestorage.app`

4. **Hosting (optionnel)**
   - Si vous déployez sur Firebase Hosting :
     ```bash
     firebase init hosting
     firebase deploy --only hosting
     ```

---

## Domaines autorisés pour Authentication

Dans Firebase Console → Authentication → Settings → Authorized domains :

- ✅ `localhost` (développement)
- ✅ `dinevio-app.firebaseapp.com` (Firebase Hosting)
- ✅ Votre domaine personnalisé (si vous en avez un)

---

## Dépannage

### Erreur : "Firebase: Error (auth/unauthorized-domain)"

**Solution :** Ajouter votre domaine dans Firebase Console → Authentication → Settings → Authorized domains

### Erreur : "Firebase: Error (auth/operation-not-allowed)"

**Solution :** Activer la méthode d'authentification dans Firebase Console → Authentication → Sign-in method

### Erreur : "Firebase: Error (firestore/permission-denied)"

**Solution :** Vérifier les règles Firestore dans Firebase Console → Firestore Database → Rules

---

## Notes importantes

- ⚠️ Les scripts Firebase SDK sont chargés depuis CDN Google (`gstatic.com`)
- ⚠️ Version utilisée : `10.13.2` (dernière version stable)
- ⚠️ Pour la production, considérez utiliser des versions spécifiques ou un bundler
- ⚠️ Les services Firebase sont disponibles globalement via `window.firebase*` (pour debug uniquement)

---

## Prochaines étapes

1. ✅ Configuration complétée
2. Tester Phone Auth sur le web
3. Tester Google Sign-In sur le web
4. Tester Firestore operations
5. Tester Storage uploads
6. Configurer Firebase Hosting (optionnel)

---

**Date:** 2025-01-XX  
**Statut:** ✅ Configuration complétée et prête pour tests

