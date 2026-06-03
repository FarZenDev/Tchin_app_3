# Configuration de la Monétisation - Tchin App

## ⚠️ Actions Requises Avant Publication

Le code de monétisation est implémenté, mais vous devez configurer vos propres identifiants avant de publier l'application.

---

## 1. Configuration AdMob (Publicités)

### Créer un compte AdMob
1. Allez sur [AdMob](https://admob.google.com/)
2. Créez une application "Tchin"
3. Créez une **unité publicitaire Interstitielle**

### Remplacer les IDs de test
Ouvrez `lib/services/ad_service.dart` et remplacez :

```dart
// AVANT (IDs de test)
static const String _androidAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
static const String _iosAdUnitId = 'ca-app-pub-3940256099942544/4411468910';

// APRÈS (vos vrais IDs)
static const String _androidAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY';
static const String _iosAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ';
```

### Configuration Android
Ajoutez votre App ID dans `android/app/src/main/AndroidManifest.xml` :

```xml
<manifest>
    <application>
        <!-- Ajoutez cette ligne -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY"/>
    </application>
</manifest>
```

### Configuration iOS
Ajoutez votre App ID dans `ios/Runner/Info.plist` :

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY</string>
```

---

## 2. Configuration In-App Purchase (Abonnement Premium)

### Google Play Console (Android)
1. Créez un produit d'abonnement dans la console
2. Notez l'ID du produit (ex: `tchin_premium_monthly`)

### App Store Connect (iOS)
1. Créez un abonnement auto-renouvelable
2. Notez l'ID du produit (doit être identique à Android)

### Remplacer l'ID produit
Ouvrez `lib/providers/premium_provider.dart` et remplacez :

```dart
// AVANT
static const String premiumProductId = 'tchin_premium_subscription';

// APRÈS (votre vrai ID)
static const String premiumProductId = 'tchin_premium_monthly';
```

### Configuration Android
Ajoutez la permission dans `android/app/src/main/AndroidManifest.xml` :

```xml
<uses-permission android:name="com.android.vending.BILLING" />
```

---

## 3. Tests

### Tester les Pubs (Mode Test)
Les IDs de test actuels affichent des pubs de démonstration. Elles fonctionnent immédiatement.

### Tester les Achats
- **Android** : Ajoutez des comptes testeurs dans Google Play Console
- **iOS** : Utilisez un compte Sandbox dans App Store Connect

---

## 4. Checklist Avant Publication

- [ ] Remplacer les Ad Unit IDs de test par les vrais
- [ ] Ajouter l'App ID AdMob dans AndroidManifest.xml et Info.plist
- [ ] Créer le produit d'abonnement dans les stores
- [ ] Remplacer le Product ID dans `premium_provider.dart`
- [ ] Tester l'achat avec un compte sandbox
- [ ] Vérifier que les pubs s'affichent correctement
- [ ] Vérifier que les modes se débloquent après achat

---

## 📝 Notes Importantes

- Les pubs ne s'affichent PAS en mode debug/développement sur certains appareils
- Testez toujours sur un appareil physique, pas l'émulateur
- Les revenus AdMob prennent 24-48h pour apparaître dans le dashboard
