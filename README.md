# Tchin App 3

Tchin est une application Flutter de jeu festif autour de modes de questions, mini-jeux et experiences premium. Cette version contient l'application multiplateforme complete pour Android, iOS, Web, Windows, macOS et Linux.

## Fonctionnalites

- Modes de jeu festifs avec questions par categories.
- Gestion des joueurs et progression de partie.
- Mini-jeux integres, dont tic-tac-toe, roue, des et machine a sous.
- Theme visuel premium avec animations, sons et arriere-plans.
- Preparation monetisation avec achats integres, publicites et preferences locales.

## Stack

- Flutter / Dart
- Provider pour la gestion d'etat
- Google Fonts
- In-app purchases
- Google Mobile Ads
- Shared Preferences

## Demarrage

Installe Flutter, puis lance les commandes suivantes depuis la racine du projet :

```bash
flutter pub get
flutter run
```

## Tests

```bash
flutter test
```

## Builds utiles

```bash
flutter build apk
flutter build web
flutter build windows
```

Les dossiers generes comme `build/`, `.dart_tool/` et les logs Flutter ne sont pas versionnes.

## Structure

- `lib/` : code Dart principal de l'application.
- `assets/` : icones et ressources graphiques.
- `docs/` : listes de questions et documentation fonctionnelle.
- `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/` : projets plateformes Flutter.

## Release

La version publiee dans `pubspec.yaml` est `2.0.0+1`. Les notes de release sont disponibles dans [CHANGELOG.md](CHANGELOG.md) et dans `.github/release-notes/`.

## Licence

Aucune licence publique n'est fournie pour le moment. Le code reste reserve a son proprietaire.
