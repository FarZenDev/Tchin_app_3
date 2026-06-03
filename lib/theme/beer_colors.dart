import 'package:flutter/material.dart';
import '../models/question_model.dart';

/// Palette de couleurs premium pour chaque mode de jeu.
/// Optimisée pour le fond navy sombre du nouveau thème.
class BeerColors {
  // Lager / Blonde (Classic) — doré chaud
  static const Color lager = Color(0xFFF5A623);

  // Kriek / Cerise (Duo) — rose-rouge vif
  static const Color kriek = Color(0xFFE91E8C);

  // Stout / Dark (Bar) — violet profond
  static const Color stout = Color(0xFF9B59B6);

  // Blanche / White (Chill) — cyan doux
  static const Color blanche = Color(0xFF00BCD4);

  // Amber / Rousse (Hot) — orange intense
  static const Color amber = Color(0xFFFF5722);

  // IPA / Copper (Express) — vert électrique
  static const Color ipa = Color(0xFF00E676);

  // Tripel (Borderline) — rouge sang
  static const Color tripel = Color(0xFFFF1744);

  static Color getForMode(GameMode mode) {
    switch (mode) {
      case GameMode.classic:   return lager;
      case GameMode.duo:       return kriek;
      case GameMode.bar:       return stout;
      case GameMode.chill:     return blanche;
      case GameMode.hot:       return amber;
      case GameMode.express:   return ipa;
      case GameMode.borderline: return tripel;
      default:                 return lager;
    }
  }

  static String getNameForMode(GameMode mode) {
    switch (mode) {
      case GameMode.classic:   return 'Mode Classique';
      case GameMode.duo:       return 'Mode Duo';
      case GameMode.bar:       return 'Mode Bar';
      case GameMode.chill:     return 'Mode Chill';
      case GameMode.hot:       return 'Mode Hot 🔥';
      case GameMode.express:   return 'Mode Express';
      case GameMode.borderline: return 'Borderline 💀';
      default:                 return 'Bière Mystère';
    }
  }
}
