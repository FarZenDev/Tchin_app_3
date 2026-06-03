
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Palette principale ─────────────────────────────────────────────────────
  /// Ambre chaud — couleur signature
  static const Color primary    = Color(0xFFF5A623);
  /// Or lumineux — accents secondaires
  static const Color secondary  = Color(0xFFFFD700);
  /// Orange vif — CTA et alertes
  static const Color accent     = Color(0xFFFF6B35);

  // ── Textes ────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8BCC8);
  static const Color textMuted     = Color(0xFF6B7280);

  // ── Statuts ───────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0xFFEF4444);

  // ── Fond (dark premium) ───────────────────────────────────────────────────
  /// Fond principal : navy profond
  static const Color background   = Color(0xFF090C14);
  /// Fond secondaire : slate sombre
  static const Color bgSurface    = Color(0xFF0F1420);
  /// Fond des cartes en verre
  static const Color glassCardBg  = Color(0x1AFFFFFF); // blanc 10 %
  static const Color glassFrameBg = Color(0x26FFFFFF); // blanc 15 %

  // ── Gradients du fond global ──────────────────────────────────────────────
  static const Color bgGradientTop    = Color(0xFF0D1117);
  static const Color bgGradientMid    = Color(0xFF12182A);
  static const Color bgGradientBottom = Color(0xFF0A0E18);

  // ── Helpers ───────────────────────────────────────────────────────────────
  static BoxDecoration get appBackgroundDecoration => const BoxDecoration(
    gradient: RadialGradient(
      center: Alignment(0, -0.4),
      radius: 1.2,
      colors: [Color(0xFF1C2340), Color(0xFF090C14)],
    ),
  );

  /// Lueur ambrée utilisée derrière les cartes / héros
  static BoxDecoration glowDecoration(Color color, {double radius = 80}) =>
      BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.28),
            blurRadius: radius,
            spreadRadius: radius * 0.25,
          ),
        ],
      );

  // ── ThemeData ─────────────────────────────────────────────────────────────
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.transparent,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        tertiary: accent,
        surface: bgSurface,
        error: error,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.bubblegumSans(
          fontSize: 42,
          color: textPrimary,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: primary.withOpacity(0.4), blurRadius: 16)],
        ),
        displayMedium: GoogleFonts.bubblegumSans(
          fontSize: 32,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: textSecondary,
          height: 1.4,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: textPrimary,
          shadowColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.2,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0x1AFFFFFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0x33FFFFFF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0x33FFFFFF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(color: textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
