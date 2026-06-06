import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/question_model.dart';
import '../theme/app_theme.dart';
import '../widgets/beer_background.dart';
import '../widgets/clean_scroll_behavior.dart';
import '../widgets/game_layout.dart';
import '../widgets/question_playing_card.dart';

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
        child: _MiniCardBack(accent: AppTheme.primary),
      ),
      _AssetKitItem(
        label: 'Ticket',
        child: _ReceiptAssetIcon(),
      ),
      _AssetKitItem(
        label: 'Gorgees',
        child: _CounterAssetChip(value: '02'),
      ),
      _AssetKitItem(
        label: 'Diable',
        child: _DevilSealAsset(),
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

class _MiniCardBack extends StatelessWidget {
  final Color accent;

  const _MiniCardBack({required this.accent});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.68,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFF25100B), Color(0xFF6C2E12), Color(0xFF160907)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: accent.withValues(alpha: 0.4), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.18),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: CustomPaint(
          painter: _MiniBackPatternPainter(accent: accent),
          child: Icon(
            Icons.sports_bar_rounded,
            color: accent.withValues(alpha: 0.9),
            size: 32,
          ),
        ),
      ),
    );
  }
}

class _MiniBackPatternPainter extends CustomPainter {
  final Color accent;

  const _MiniBackPatternPainter({required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final stripe = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 4;
    for (var x = -size.height; x < size.width; x += 16) {
      canvas.drawLine(
          Offset(x, 0), Offset(x + size.height, size.height), stripe);
    }

    final border = Paint()
      ..color = accent.withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(9, 9, size.width - 18, size.height - 18),
        const Radius.circular(10),
      ),
      border,
    );
  }

  @override
  bool shouldRepaint(covariant _MiniBackPatternPainter oldDelegate) {
    return oldDelegate.accent != accent;
  }
}

class _ReceiptAssetIcon extends StatelessWidget {
  const _ReceiptAssetIcon();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      size: Size(72, 92),
      painter: _ReceiptAssetPainter(),
    );
  }
}

class _ReceiptAssetPainter extends CustomPainter {
  const _ReceiptAssetPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paper = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFF8E6), Color(0xFFF0E4C8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size);
    final body = Path()
      ..moveTo(8, 0)
      ..lineTo(size.width - 8, 0)
      ..lineTo(size.width - 8, size.height - 10);
    for (var x = size.width - 8; x >= 8; x -= 10) {
      body
        ..lineTo(x - 5, size.height)
        ..lineTo(x - 10, size.height - 10);
    }
    body
      ..lineTo(8, 0)
      ..close();
    canvas.drawPath(body, paper);

    final ink = Paint()
      ..color = Colors.black.withValues(alpha: 0.72)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(20, 24), Offset(size.width - 20, 24), ink);
    canvas.drawLine(const Offset(18, 42), Offset(size.width - 16, 42), ink);
    canvas.drawLine(const Offset(18, 57), Offset(size.width - 24, 57), ink);
    canvas.drawLine(const Offset(18, 72), Offset(size.width - 18, 72), ink);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CounterAssetChip extends StatelessWidget {
  final String value;

  const _CounterAssetChip({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFC46B), Color(0xFFFF7A2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7A2F).withValues(alpha: 0.26),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sports_bar_rounded,
              color: Color(0xFF23100A), size: 18),
          const SizedBox(width: 7),
          Text(
            value,
            style: GoogleFonts.robotoMono(
              color: const Color(0xFF23100A),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _DevilSealAsset extends StatelessWidget {
  const _DevilSealAsset();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      size: Size(86, 86),
      painter: _DevilSealPainter(),
    );
  }
}

class _DevilSealPainter extends CustomPainter {
  const _DevilSealPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.38;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFFD15D), Color(0xFFFF5C2E), Color(0xFF5C0D12)],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    final face = Paint()..color = const Color(0xFF2B070A);
    canvas.drawCircle(center, radius * 0.52, face);

    final horn = Paint()..color = const Color(0xFFFFD15D);
    final leftHorn = Path()
      ..moveTo(center.dx - 18, center.dy - 15)
      ..quadraticBezierTo(
          center.dx - 27, center.dy - 32, center.dx - 7, center.dy - 22);
    final rightHorn = Path()
      ..moveTo(center.dx + 18, center.dy - 15)
      ..quadraticBezierTo(
          center.dx + 27, center.dy - 32, center.dx + 7, center.dy - 22);
    canvas.drawPath(
        leftHorn,
        horn
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5);
    canvas.drawPath(rightHorn, horn);

    final eye = Paint()..color = const Color(0xFFFFF3D0);
    canvas.drawCircle(center.translate(-11, -2), 4.2, eye);
    canvas.drawCircle(center.translate(11, -2), 4.2, eye);
    final pupil = Paint()..color = const Color(0xFF2B070A);
    canvas.drawCircle(center.translate(-10, -1), 1.8, pupil);
    canvas.drawCircle(center.translate(10, -1), 1.8, pupil);

    final mouth = Paint()
      ..color = const Color(0xFFFFD15D)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: center.translate(0, 8), width: 28, height: 18),
      0.15,
      math.pi - 0.3,
      false,
      mouth,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
