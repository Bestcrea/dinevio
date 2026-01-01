# Firebase Android Setup Guide

## Configuration Firebase pour Android

### 1. Vérification des fichiers de configuration

#### ✅ Fichiers requis
- `android/app/google-services.json` - **DOIT être présent**
- `android/app/build.gradle` - **DOIT inclure le plugin google-services**

#### ✅ Vérification du plugin google-services

**Root `android/build.gradle` (ou `settings.gradle`):**
```gradle
plugins {
    id "com.google.gms.google-services" version "4.4.4" apply false
}
```

**Module `android/app/build.gradle`:**
```gradle
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    id "com.google.gms.google-services"  // ← DOIT être présent
}

dependencies {
    // Firebase BoM
    implementation platform('com.google.firebase:firebase-bom:34.7.0')
    implementation 'com.google.firebase:firebase-analytics'
    implementation 'com.google.firebase:firebase-auth'
    implementation 'com.google.firebase:firebase-firestore'
}
```

#### ✅ Vérification de l'applicationId

**Dans `android/app/build.gradle`:**
```gradle
android {
    namespace "com.dinevio.customer"
    
    defaultConfig {
        applicationId "com.dinevio.customer"  // ← DOIT correspondre à Firebase Console
    }
}
```

**IMPORTANT:** L'`applicationId` dans `build.gradle` **DOIT** correspondre exactement au `package name` de l'application Android dans Firebase Console.

---

## 2. Obtenir SHA-1 et SHA-256 (OBLIGATOIRE pour Phone Auth et Google Sign-In)

### Méthode 1: Via Gradle (Recommandé)

```bash
cd customer/android
./gradlew signingReport
```

**OU** (si vous êtes dans le dossier customer):
```bash
cd android
./gradlew signingReport
```

**Sortie attendue:**
```
Variant: debug
Config: debug
Store: ~/.android/debug.keystore
Alias: AndroidDebugKey
MD5: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA-256: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
Valid until: ...
```

### Méthode 2: Via keytool (Debug keystore)

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### Méthode 3: Via keytool (Release keystore)

Si vous avez un keystore de release:
```bash
keytool -list -v -keystore /path/to/your/keystore.jks -alias your-key-alias
```

---

## 3. Ajouter SHA-1 et SHA-256 dans Firebase Console

1. Allez sur [Firebase Console](https://console.firebase.google.com/)
2. Sélectionnez votre projet **Dinevio**
3. Cliquez sur l'icône ⚙️ (Settings) → **Project settings**
4. Allez dans l'onglet **Your apps**
5. Trouvez votre application Android (`com.dinevio.customer`)
6. Cliquez sur **Add fingerprint**
7. Collez votre **SHA-1** (copiez depuis la sortie de `signingReport`)
8. Cliquez sur **Add fingerprint** à nouveau
9. Collez votre **SHA-256** (copiez depuis la sortie de `signingReport`)
10. **SAUVEZ** (les changements peuvent prendre quelques minutes à se propager)

---

## 4. Vérification de la configuration

### Vérifier que google-services.json est correct

**Emplacement:** `customer/android/app/google-services.json`

**Contenu attendu:**
```json
{
  "project_info": {
    "project_number": "...",
    "project_id": "...",
    "storage_bucket": "..."
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "...",
        "android_client_info": {
          "package_name": "com.dinevio.customer"  // ← DOIT correspondre
        }
      },
      "oauth_client": [...],
      "api_key": [...],
      "services": {
        "appinvite_service": {...}
      }
    }
  ]
}
```

**Vérification:**
- Le `package_name` dans `google-services.json` **DOIT** être `com.dinevio.customer`
- Si différent, téléchargez un nouveau `google-services.json` depuis Firebase Console

---

## 5. Résolution de l'erreur CONFIGURATION_NOT_FOUND

### Causes possibles:

1. **google-services.json manquant ou au mauvais endroit**
   - ✅ DOIT être dans `android/app/google-services.json`
   - ❌ PAS dans `android/google-services.json`

2. **Plugin google-services non appliqué**
   - ✅ Vérifiez que `id "com.google.gms.google-services"` est dans `android/app/build.gradle`

3. **applicationId ne correspond pas**
   - ✅ Vérifiez que `applicationId "com.dinevio.customer"` correspond à Firebase Console

4. **SHA-1/SHA-256 manquants**
   - ✅ Ajoutez-les dans Firebase Console (voir section 3)

5. **Firebase non initialisé**
   - ✅ Vérifiez que `Firebase.initializeApp()` est appelé dans `main.dart`

### Après correction:

1. **Nettoyez le build:**
```bash
cd customer/android
./gradlew clean
```

2. **Rebuild:**
```bash
cd customer
flutter clean
flutter pub get
flutter run
```

---

## 6. Test de la configuration

### Vérifier que Firebase est initialisé

Dans les logs Flutter, vous devriez voir:
```
Firebase initialized successfully with DefaultFirebaseOptions
```

### Tester Phone Auth

1. Lancez l'app
2. Allez sur l'écran de login
3. Cliquez sur "Continue With Phone"
4. Entrez un numéro de téléphone
5. Cliquez sur "Next"
6. **Si CONFIGURATION_NOT_FOUND apparaît:**
   - Vérifiez SHA-1/SHA-256 dans Firebase Console
   - Vérifiez que `google-services.json` est au bon endroit
   - Vérifiez que le plugin est appliqué

---

## 7. Support

Si l'erreur persiste après avoir suivi ces étapes:

1. Vérifiez les logs Android:
```bash
adb logcat | grep -i firebase
```

2. Vérifiez les logs Flutter:
```bash
flutter run --verbose
```

3. Vérifiez que tous les fichiers sont corrects:
   - `android/app/google-services.json` existe
   - `android/app/build.gradle` a le plugin
   - `applicationId` correspond à Firebase Console
   - SHA-1/SHA-256 sont ajoutés dans Firebase Console

---

## Notes importantes

- ⚠️ **SHA-1/SHA-256 sont OBLIGATOIRES** pour Phone Auth et Google Sign-In
- ⚠️ Les changements dans Firebase Console peuvent prendre **2-5 minutes** à se propager
- ⚠️ Après avoir ajouté SHA-1/SHA-256, **redémarrez l'app** complètement
- ⚠️ Pour la release, vous devrez ajouter le SHA-1/SHA-256 de votre **release keystore**

