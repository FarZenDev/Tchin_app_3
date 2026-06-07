import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum TchinCardDesignVariant {
  comptoir,
  club,
  ticket,
}

const _tchinCardFrontAsset = 'assets/cards/tchin_card_front.png';
const _tchinCardBackAsset = 'assets/cards/tchin_card_back.png';

class TchinCardDesignPair extends StatelessWidget {
  final String modeName;
  final Color accent;
  final IconData icon;
  final TchinCardDesignVariant variant;
  final bool isBorderline;

  const TchinCardDesignPair({
    super.key,
    required this.modeName,
    required this.accent,
    required this.icon,
    required this.variant,
    this.isBorderline = false,
  });

  @override
  Widget build(BuildContext context) {
    final variantName = switch (variant) {
      TchinCardDesignVariant.comptoir => 'Signature',
      TchinCardDesignVariant.club => 'Nocturne',
      TchinCardDesignVariant.ticket => 'Ticket',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                variantName.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.9,
                ),
              ),
            ),
            Text(
              'RECTO / VERSO',
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.48),
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.7,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 230,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TchinModeCardDesign(
                modeName: modeName,
                accent: accent,
                icon: icon,
                variant: variant,
                isBack: false,
                isBorderline: isBorderline,
              ),
              const SizedBox(width: 12),
              TchinModeCardDesign(
                modeName: modeName,
                accent: accent,
                icon: icon,
                variant: variant,
                isBack: true,
                isBorderline: isBorderline,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TchinModeCardDesign extends StatelessWidget {
  final String modeName;
  final Color accent;
  final IconData icon;
  final TchinCardDesignVariant variant;
  final bool isBack;
  final bool isBorderline;

  const TchinModeCardDesign({
    super.key,
    required this.modeName,
    required this.accent,
    required this.icon,
    required this.variant,
    required this.isBack,
    this.isBorderline = false,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.68,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.42),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: accent.withValues(alpha: isBorderline ? 0.18 : 0.1),
              blurRadius: 18,
            ),
          ],
        ),
        child: TchinModeCardSurface(
          modeName: modeName,
          accent: accent,
          icon: icon,
          variant: variant,
          isBack: isBack,
          isBorderline: isBorderline,
          borderRadius: 18,
          topPadding: 76,
          horizontalPadding: 34,
          bottomPadding: 62,
          child: isBack
              ? null
              : _TchinCardAssetPreviewContent(
                  modeName: modeName,
                  accent: accent,
                  icon: icon,
                  isBorderline: isBorderline,
                ),
        ),
      ),
    );
  }
}

class TchinModeCardSurface extends StatelessWidget {
  final String modeName;
  final Color accent;
  final IconData icon;
  final TchinCardDesignVariant variant;
  final bool isBack;
  final bool isBorderline;
  final double borderRadius;
  final double topPadding;
  final double horizontalPadding;
  final double bottomPadding;
  final Widget? child;

  const TchinModeCardSurface({
    super.key,
    required this.modeName,
    required this.accent,
    required this.icon,
    required this.variant,
    this.isBack = false,
    this.isBorderline = false,
    this.borderRadius = 24,
    this.topPadding = 76,
    this.horizontalPadding = 42,
    this.bottomPadding = 66,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              isBack ? _tchinCardBackAsset : _tchinCardFrontAsset,
              fit: BoxFit.fill,
            ),
          ),
          if (!isBack)
            Positioned.fill(
              child: _TchinCardFaceInk(
                modeName: modeName,
                accent: accent,
                icon: icon,
                isBorderline: isBorderline,
              ),
            ),
          if (!isBack)
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  topPadding,
                  horizontalPadding,
                  bottomPadding,
                ),
                child: child ?? const SizedBox.shrink(),
              ),
            ),
        ],
      ),
    );
  }
}

class _TchinCardFaceInk extends StatelessWidget {
  final String modeName;
  final Color accent;
  final IconData icon;
  final bool isBorderline;

  const _TchinCardFaceInk({
    required this.modeName,
    required this.accent,
    required this.icon,
    required this.isBorderline,
  });

  @override
  Widget build(BuildContext context) {
    final ink =
        isBorderline ? const Color(0xFF35100D) : const Color(0xFF2C211B);
    final markColor = isBorderline ? const Color(0xFFCF372A) : accent;

    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _TchinCardFaceInkPainter(
                    accent: markColor,
                    ink: ink,
                    isBorderline: isBorderline,
                  ),
                ),
              ),
              Positioned(
                top: height * 0.205,
                left: width * 0.18,
                right: width * 0.18,
                child: _TchinFaceLabel(
                  text: 'DÉFI DU SOIR',
                  accent: markColor,
                  ink: ink,
                  strong: true,
                ),
              ),
              Positioned(
                bottom: height * 0.172,
                left: width * 0.18,
                right: width * 0.18,
                child: _TchinFaceLabel(
                  text: modeName.toUpperCase(),
                  accent: markColor,
                  ink: ink,
                ),
              ),
              Positioned(
                left: width * 0.052,
                top: height * 0.42,
                child: _TchinSideStamp(
                  text: 'TCHIN',
                  accent: markColor,
                  ink: ink,
                ),
              ),
              Positioned(
                right: width * 0.052,
                top: height * 0.42,
                child: _TchinSideStamp(
                  text: 'BAR',
                  accent: markColor,
                  ink: ink,
                  flipped: true,
                ),
              ),
              Positioned(
                left: width * 0.107,
                top: height * 0.245,
                child: _TchinFacePip(icon: icon, color: markColor),
              ),
              Positioned(
                right: width * 0.107,
                bottom: height * 0.232,
                child: Transform.rotate(
                  angle: math.pi,
                  child: _TchinFacePip(icon: icon, color: markColor),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TchinFaceLabel extends StatelessWidget {
  final String text;
  final Color accent;
  final Color ink;
  final bool strong;

  const _TchinFaceLabel({
    required this.text,
    required this.accent,
    required this.ink,
    this.strong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: strong ? 2 : 1.5,
            color: accent.withValues(alpha: strong ? 0.34 : 0.24),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: ink.withValues(alpha: strong ? 0.24 : 0.18),
              fontSize: strong ? 9.5 : 8.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: strong ? 2 : 1.5,
            color: accent.withValues(alpha: strong ? 0.34 : 0.24),
          ),
        ),
      ],
    );
  }
}

class _TchinSideStamp extends StatelessWidget {
  final String text;
  final Color accent;
  final Color ink;
  final bool flipped;

  const _TchinSideStamp({
    required this.text,
    required this.accent,
    required this.ink,
    this.flipped = false,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: flipped ? math.pi / 2 : -math.pi / 2,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 1.5,
            color: accent.withValues(alpha: 0.28),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.inter(
              color: ink.withValues(alpha: 0.15),
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 18,
            height: 1.5,
            color: accent.withValues(alpha: 0.28),
          ),
        ],
      ),
    );
  }
}

class _TchinFacePip extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _TchinFacePip({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.075),
        border: Border.all(color: color.withValues(alpha: 0.26), width: 1),
      ),
      child: Icon(
        icon,
        color: color.withValues(alpha: 0.28),
        size: 17,
      ),
    );
  }
}

class _TchinCardFaceInkPainter extends CustomPainter {
  final Color accent;
  final Color ink;
  final bool isBorderline;

  const _TchinCardFaceInkPainter({
    required this.accent,
    required this.ink,
    required this.isBorderline,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final panel = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.18,
        size.height * 0.26,
        size.width * 0.64,
        size.height * 0.42,
      ),
      Radius.circular(size.width * 0.035),
    );

    canvas.drawRRect(
      panel,
      Paint()
        ..color = Colors.white.withValues(alpha: isBorderline ? 0.05 : 0.035)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      panel,
      Paint()
        ..color = accent.withValues(alpha: isBorderline ? 0.22 : 0.16)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1,
    );

    final rulePaint = Paint()
      ..color = ink.withValues(alpha: 0.07)
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 6; i++) {
      final y = size.height * (0.31 + (i * 0.062));
      final path = Path()
        ..moveTo(size.width * 0.26, y)
        ..cubicTo(
          size.width * 0.39,
          y - 5,
          size.width * 0.48,
          y + 4,
          size.width * 0.74,
          y - 2,
        );
      canvas.drawPath(path, rulePaint);
    }

    final dotPaint = Paint()
      ..color = accent.withValues(alpha: isBorderline ? 0.22 : 0.16);
    for (var side = 0; side < 2; side++) {
      final x = side == 0 ? size.width * 0.135 : size.width * 0.865;
      for (var i = 0; i < 11; i++) {
        final y = size.height * (0.265 + (i * 0.046));
        canvas.drawCircle(Offset(x, y), 1.25, dotPaint);
      }
    }

    final slashPaint = Paint()
      ..color = accent.withValues(alpha: 0.075)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 5; i++) {
      final start =
          Offset(size.width * (0.25 + i * 0.075), size.height * 0.705);
      canvas.drawLine(
        start,
        start.translate(size.width * 0.08, -size.height * 0.036),
        slashPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TchinCardFaceInkPainter oldDelegate) {
    return oldDelegate.accent != accent ||
        oldDelegate.ink != ink ||
        oldDelegate.isBorderline != isBorderline;
  }
}

class _TchinCardAssetPreviewContent extends StatelessWidget {
  final String modeName;
  final Color accent;
  final IconData icon;
  final bool isBorderline;

  const _TchinCardAssetPreviewContent({
    required this.modeName,
    required this.accent,
    required this.icon,
    required this.isBorderline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: accent.withValues(alpha: 0.1),
              border: Border.all(color: accent.withValues(alpha: 0.34)),
            ),
            child: Text(
              'QUESTION',
              style: GoogleFonts.inter(
                color: accent,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.7,
              ),
            ),
          ),
          const SizedBox(height: 16),
          isBorderline
              ? const TchinDevilSeal(size: 44)
              : Icon(icon, color: const Color(0xFF30241E), size: 34),
          const SizedBox(height: 14),
          Container(
            width: 64,
            height: 2,
            color: accent.withValues(alpha: 0.38),
          ),
          const SizedBox(height: 12),
          for (final width in const [112.0, 82.0, 98.0])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Container(
                width: width,
                height: 2.4,
                decoration: BoxDecoration(
                  color: const Color(0xFF30241E).withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          const SizedBox(height: 14),
          Text(
            modeName.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: const Color(0xFF30241E).withValues(alpha: 0.62),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }
}

class TchinCardBackAsset extends StatelessWidget {
  final Color accent;
  final bool isBorderline;
  final double borderRadius;
  final double markSize;

  const TchinCardBackAsset({
    super.key,
    required this.accent,
    this.isBorderline = false,
    this.borderRadius = 14,
    this.markSize = 56,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.68,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            colors: isBorderline
                ? const [
                    Color(0xFF180506),
                    Color(0xFF671414),
                    Color(0xFF100404),
                  ]
                : const [
                    Color(0xFF25100B),
                    Color(0xFF6C2E12),
                    Color(0xFF160907),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: accent.withValues(alpha: 0.4), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: isBorderline ? 0.24 : 0.18),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: CustomPaint(
          painter: _CardBackPatternPainter(
            accent: accent,
            isBorderline: isBorderline,
          ),
          child: Center(
            child: TchinCardBackMark(
              accent: accent,
              isBorderline: isBorderline,
              size: markSize,
            ),
          ),
        ),
      ),
    );
  }
}

class TchinCardBackMark extends StatelessWidget {
  final Color accent;
  final bool isBorderline;
  final double size;

  const TchinCardBackMark({
    super.key,
    required this.accent,
    this.isBorderline = false,
    this.size = 86,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: isBorderline ? 0.24 : 0.16),
          border: Border.all(
            color: accent.withValues(alpha: isBorderline ? 0.72 : 0.62),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: isBorderline ? 0.2 : 0.12),
              blurRadius: 18,
            ),
          ],
        ),
        child: Icon(
          Icons.sports_bar_rounded,
          color: accent.withValues(alpha: 0.9),
          size: size * 0.46,
        ),
      ),
    );
  }
}

class TchinReceiptGlyph extends StatelessWidget {
  final double width;
  final double height;
  final bool darkInk;

  const TchinReceiptGlyph({
    super.key,
    this.width = 72,
    this.height = 92,
    this.darkInk = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _ReceiptGlyphPainter(darkInk: darkInk),
    );
  }
}

class TchinCounterChip extends StatelessWidget {
  final String value;
  final String? label;
  final IconData icon;
  final bool compact;

  const TchinCounterChip({
    super.key,
    required this.value,
    this.label,
    this.icon = Icons.sports_bar_rounded,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 14,
        vertical: compact ? 7 : 10,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFC46B), Color(0xFFFF7A2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(compact ? 11 : 14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7A2F).withValues(alpha: 0.26),
            blurRadius: compact ? 12 : 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF23100A), size: compact ? 15 : 18),
          SizedBox(width: compact ? 5 : 7),
          Text(
            value,
            style: GoogleFonts.robotoMono(
              color: const Color(0xFF23100A),
              fontSize: compact ? 13 : 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (label != null) ...[
            const SizedBox(width: 5),
            Text(
              label!.toUpperCase(),
              style: GoogleFonts.inter(
                color: const Color(0xFF23100A).withValues(alpha: 0.82),
                fontSize: compact ? 9 : 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class TchinDevilSeal extends StatelessWidget {
  final double size;

  const TchinDevilSeal({
    super.key,
    this.size = 86,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: const _DevilSealPainter(),
    );
  }
}

class _CardBackPatternPainter extends CustomPainter {
  final Color accent;
  final bool isBorderline;

  const _CardBackPatternPainter({
    required this.accent,
    required this.isBorderline,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stripe = Paint()
      ..color = Colors.white.withValues(alpha: isBorderline ? 0.055 : 0.04)
      ..strokeWidth = isBorderline ? 5.5 : 4;
    for (var x = -size.height; x < size.width; x += 16) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        stripe,
      );
    }

    final border = Paint()
      ..color = accent.withValues(alpha: isBorderline ? 0.55 : 0.42)
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
  bool shouldRepaint(covariant _CardBackPatternPainter oldDelegate) {
    return oldDelegate.accent != accent ||
        oldDelegate.isBorderline != isBorderline;
  }
}

class _ReceiptGlyphPainter extends CustomPainter {
  final bool darkInk;

  const _ReceiptGlyphPainter({required this.darkInk});

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
      ..color = darkInk
          ? Colors.black.withValues(alpha: 0.72)
          : const Color(0xFFFFC46B).withValues(alpha: 0.86)
      ..strokeWidth = math.max(1.4, size.width * 0.028)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.28, size.height * 0.26),
      Offset(size.width * 0.72, size.height * 0.26),
      ink,
    );
    canvas.drawLine(
      Offset(size.width * 0.24, size.height * 0.46),
      Offset(size.width * 0.78, size.height * 0.46),
      ink,
    );
    canvas.drawLine(
      Offset(size.width * 0.24, size.height * 0.62),
      Offset(size.width * 0.68, size.height * 0.62),
      ink,
    );
    canvas.drawLine(
      Offset(size.width * 0.24, size.height * 0.78),
      Offset(size.width * 0.76, size.height * 0.78),
      ink,
    );
  }

  @override
  bool shouldRepaint(covariant _ReceiptGlyphPainter oldDelegate) {
    return oldDelegate.darkInk != darkInk;
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

    final horn = Paint()
      ..color = const Color(0xFFFFD15D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.058
      ..strokeCap = StrokeCap.round;
    final leftHorn = Path()
      ..moveTo(center.dx - size.width * 0.21, center.dy - size.height * 0.17)
      ..quadraticBezierTo(
        center.dx - size.width * 0.31,
        center.dy - size.height * 0.38,
        center.dx - size.width * 0.08,
        center.dy - size.height * 0.25,
      );
    final rightHorn = Path()
      ..moveTo(center.dx + size.width * 0.21, center.dy - size.height * 0.17)
      ..quadraticBezierTo(
        center.dx + size.width * 0.31,
        center.dy - size.height * 0.38,
        center.dx + size.width * 0.08,
        center.dy - size.height * 0.25,
      );
    canvas.drawPath(leftHorn, horn);
    canvas.drawPath(rightHorn, horn);

    final eye = Paint()..color = const Color(0xFFFFF3D0);
    canvas.drawCircle(center.translate(-size.width * 0.13, -size.height * 0.02),
        size.width * 0.049, eye);
    canvas.drawCircle(center.translate(size.width * 0.13, -size.height * 0.02),
        size.width * 0.049, eye);
    final pupil = Paint()..color = const Color(0xFF2B070A);
    canvas.drawCircle(center.translate(-size.width * 0.12, -size.height * 0.01),
        size.width * 0.021, pupil);
    canvas.drawCircle(center.translate(size.width * 0.12, -size.height * 0.01),
        size.width * 0.021, pupil);

    final mouth = Paint()
      ..color = const Color(0xFFFFD15D)
      ..strokeWidth = size.width * 0.035
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(
        center: center.translate(0, size.height * 0.09),
        width: size.width * 0.33,
        height: size.height * 0.21,
      ),
      0.15,
      math.pi - 0.3,
      false,
      mouth,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
