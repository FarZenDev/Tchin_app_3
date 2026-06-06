import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/question_model.dart';
import '../theme/app_theme.dart';
import '../widgets/beer_background.dart';
import '../widgets/clean_scroll_behavior.dart';
import '../widgets/game_layout.dart';
import '../widgets/question_playing_card.dart';
import '../widgets/tchin_assets.dart';

class AssetPreviewScreen extends StatelessWidget {
  const AssetPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameLayout(
      customBackground: const BeerBackground(),
      maxFrameWidth: 580,
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
                    'Test design',
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
            'Cartes, ticket et petits assets UI',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _PreviewSection(
                      title: 'Carte question',
                      child: SizedBox(
                        height: 520,
                        child: QuestionPlayingCard(
                          accentColor: Color(0xFFF5A623),
                          modeLabel: 'Bar',
                          animationKey: 'preview-classic',
                          child: _PreviewQuestionContent(
                            eyebrow: 'DEFI DU COMPTOIR',
                            question:
                                'Le dernier qui a envoye un message boit 2 gorgees.',
                            footer: 'Carte test - ambiance bar',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    _PreviewSection(
                      title: 'Carte Borderline',
                      child: SizedBox(
                        height: 520,
                        child: QuestionPlayingCard(
                          accentColor: Color(0xFFD7263D),
                          modeLabel: 'Borderline',
                          animationKey: 'preview-borderline',
                          isSpecial: true,
                          isBorderline: true,
                          intensity: BorderlineIntensity.tresSale,
                          child: _PreviewQuestionContent(
                            eyebrow: 'PACTE SALE',
                            question:
                                "Choisis quelqu'un qui ment trop bien. Il boit 3 ou raconte le dernier mytho.",
                            footer: 'Rouge, sombre, lisible',
                            isBorderline: true,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    _PreviewSection(
                      title: 'Kit UI',
                      child: _AssetKitGrid(),
                    ),
                    SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _PreviewSection({
    required this.title,
    required this.child,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              title.toUpperCase(),
              style: GoogleFonts.inter(
                color: const Color(0xFFFFC46B),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _PreviewQuestionContent extends StatelessWidget {
  final String eyebrow;
  final String question;
  final String footer;
  final bool isBorderline;

  const _PreviewQuestionContent({
    required this.eyebrow,
    required this.question,
    required this.footer,
    this.isBorderline = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isBorderline ? const Color(0xFF8B1515) : AppTheme.primary;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: accent.withValues(alpha: 0.3)),
          ),
          child: Text(
            eyebrow,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: accent,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          question,
          textAlign: TextAlign.center,
          maxLines: 6,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.bebasNeue(
            color: isBorderline ? const Color(0xFF230708) : Colors.black87,
            fontSize: 34,
            height: 1.04,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          footer,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: Colors.black.withValues(alpha: 0.46),
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _AssetKitGrid extends StatelessWidget {
  const _AssetKitGrid();

  @override
  Widget build(BuildContext context) {
    const items = [
      _AssetKitItem(
        label: 'Dos carte',
        child: TchinCardBackAsset(accent: AppTheme.primary),
      ),
      _AssetKitItem(
        label: 'Ticket',
        child: TchinReceiptGlyph(),
      ),
      _AssetKitItem(
        label: 'Gorgees',
        child: TchinCounterChip(value: '02'),
      ),
      _AssetKitItem(
        label: 'Diable',
        child: TchinDevilSeal(),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 420;
        return GridView.count(
          crossAxisCount: isWide ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: isWide ? 0.82 : 1.05,
          children: items,
        );
      },
    );
  }
}

class _AssetKitItem extends StatelessWidget {
  final String label;
  final Widget child;

  const _AssetKitItem({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Expanded(child: Center(child: child)),
          const SizedBox(height: 9),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
