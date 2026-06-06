import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../theme/beer_colors.dart';
import '../widgets/beer_background.dart';
import '../widgets/clean_scroll_behavior.dart';
import '../widgets/game_layout.dart';
import '../widgets/tchin_assets.dart';

class AssetPreviewScreen extends StatelessWidget {
  const AssetPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameLayout(
      customBackground: const BeerBackground(),
      maxFrameWidth: 620,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Retour',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Colors.white,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.07),
                  fixedSize: const Size(40, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side:
                        BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Cartes test',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Signature, Nocturne, Ticket - recto verso par mode',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppTheme.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: ScrollConfiguration(
              behavior: CleanScrollBehavior(),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: _CardDesignGallery(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardDesignGallery extends StatelessWidget {
  const _CardDesignGallery();

  static const _variants = [
    TchinCardDesignVariant.comptoir,
    TchinCardDesignVariant.club,
    TchinCardDesignVariant.ticket,
  ];

  static const _modes = [
    _CardModePreview(
      name: 'Classique',
      subtitle: 'doré, propre, table de soirée',
      accent: BeerColors.lager,
      icon: Icons.sports_bar_rounded,
    ),
    _CardModePreview(
      name: 'Duo',
      subtitle: 'symétrique, deux joueurs, kriek',
      accent: BeerColors.kriek,
      icon: Icons.groups_rounded,
    ),
    _CardModePreview(
      name: 'Bar',
      subtitle: 'comptoir, cocktails, absurde',
      accent: BeerColors.stout,
      icon: Icons.local_bar_rounded,
    ),
    _CardModePreview(
      name: 'Chill',
      subtitle: 'calme, cyan, lounge',
      accent: BeerColors.blanche,
      icon: Icons.spa_rounded,
    ),
    _CardModePreview(
      name: 'Hot',
      subtitle: 'ambre, chaleur, coquin propre',
      accent: BeerColors.amber,
      icon: Icons.local_fire_department_rounded,
    ),
    _CardModePreview(
      name: 'Express',
      subtitle: 'rapide, nerveux, vert flash',
      accent: BeerColors.ipa,
      icon: Icons.bolt_rounded,
    ),
    _CardModePreview(
      name: 'Borderline',
      subtitle: 'bar infernal, rouge, hard',
      accent: BeerColors.tripel,
      icon: Icons.local_fire_department_rounded,
      isBorderline: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final mode in _modes) ...[
          _ModeDesignSection(mode: mode, variants: _variants),
          const SizedBox(height: 14),
        ],
        const SizedBox(height: 14),
      ],
    );
  }
}

class _ModeDesignSection extends StatelessWidget {
  final _CardModePreview mode;
  final List<TchinCardDesignVariant> variants;

  const _ModeDesignSection({
    required this.mode,
    required this.variants,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: mode.accent.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: mode.accent.withValues(alpha: 0.36),
                  ),
                ),
                child: Icon(mode.icon, color: mode.accent, size: 18),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mode.name.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      mode.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: mode.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: mode.accent.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '3 DESIGNS',
                  style: GoogleFonts.inter(
                    color: mode.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          for (final variant in variants) ...[
            TchinCardDesignPair(
              modeName: mode.name,
              accent: mode.accent,
              icon: mode.icon,
              variant: variant,
              isBorderline: mode.isBorderline,
            ),
            if (variant != variants.last) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _CardModePreview {
  final String name;
  final String subtitle;
  final Color accent;
  final IconData icon;
  final bool isBorderline;

  const _CardModePreview({
    required this.name,
    required this.subtitle,
    required this.accent,
    required this.icon,
    this.isBorderline = false,
  });
}
