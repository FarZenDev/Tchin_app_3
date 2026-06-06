import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum TchinCardDesignVariant {
  comptoir,
  club,
  ticket,
}

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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: CustomPaint(
            painter: _TchinModeCardPainter(
              accent: accent,
              variant: variant,
              isBack: isBack,
              isBorderline: isBorderline,
            ),
            child: isBack
                ? _TchinModeCardBackContent(
                    modeName: modeName,
                    accent: accent,
                    icon: icon,
                    isBorderline: isBorderline,
                  )
                : _TchinModeCardFrontContent(
                    modeName: modeName,
                    accent: accent,
                    icon: icon,
                    variant: variant,
                    isBorderline: isBorderline,
                  ),
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
      child: CustomPaint(
        painter: _TchinModeCardPainter(
          accent: accent,
          variant: variant,
          isBack: isBack,
          isBorderline: isBorderline,
        ),
        child: isBack ? _buildBack() : _buildFront(),
      ),
    );
  }

  Widget _buildBack() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.22),
              border: Border.all(
                color: accent.withValues(alpha: 0.66),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: isBorderline ? 0.22 : 0.14),
                  blurRadius: 20,
                ),
              ],
            ),
            child: isBorderline
                ? const TchinDevilSeal(size: 70)
                : Icon(
                    icon,
                    color: accent.withValues(alpha: 0.94),
                    size: 43,
                  ),
          ),
          const SizedBox(height: 12),
          Text(
            modeName.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.74),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _frontQuestionPanel() {
    final panelColor = switch (variant) {
      TchinCardDesignVariant.comptoir => const Color(0xFFFFF3D8),
      TchinCardDesignVariant.club => const Color(0xFFFFEED1),
      TchinCardDesignVariant.ticket => const Color(0xFFFFF8E8),
    };

    return Positioned(
      left: math.max(18, horizontalPadding - 16),
      right: math.max(18, horizontalPadding - 16),
      top: math.max(46, topPadding - 20),
      bottom: math.max(42, bottomPadding - 22),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: panelColor.withValues(
              alpha: variant == TchinCardDesignVariant.club ? 0.96 : 0.76),
          borderRadius: BorderRadius.circular(borderRadius * 0.58),
          border: Border.all(
            color: accent.withValues(alpha: isBorderline ? 0.26 : 0.18),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFront() {
    final ink =
        isBorderline ? const Color(0xFF2A0608) : const Color(0xFF25140C);
    return Stack(
      children: [
        if (child != null) _frontQuestionPanel(),
        Positioned(
          left: 16,
          top: 16,
          child: _TchinCornerMark(accent: accent, icon: icon, small: true),
        ),
        if (isBorderline)
          const Positioned(
            left: 0,
            right: 0,
            top: 18,
            child: Center(child: TchinDevilSeal(size: 34)),
          ),
        Positioned(
          right: 16,
          bottom: 16,
          child: Transform.rotate(
            angle: math.pi,
            child: _TchinCornerMark(accent: accent, icon: icon, small: true),
          ),
        ),
        Positioned(
          left: 28,
          right: 28,
          bottom: 19,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: accent.withValues(alpha: 0.35),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  modeName.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: ink.withValues(alpha: 0.56),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: accent.withValues(alpha: 0.35),
                ),
              ),
            ],
          ),
        ),
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
    );
  }
}

class _TchinModeCardFrontContent extends StatelessWidget {
  final String modeName;
  final Color accent;
  final IconData icon;
  final TchinCardDesignVariant variant;
  final bool isBorderline;

  const _TchinModeCardFrontContent({
    required this.modeName,
    required this.accent,
    required this.icon,
    required this.variant,
    required this.isBorderline,
  });

  @override
  Widget build(BuildContext context) {
    final ink =
        isBorderline ? const Color(0xFF2A0608) : const Color(0xFF25140C);
    final modeLabel = modeName.toUpperCase();
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              _TchinCornerMark(accent: accent, icon: icon, small: true),
              const Spacer(),
              if (isBorderline) const TchinDevilSeal(size: 28),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                decoration: BoxDecoration(
                  color: _paperColor(variant),
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: accent.withValues(alpha: 0.28),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: accent.withValues(alpha: 0.12),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.34),
                        ),
                      ),
                      child: Text(
                        'QUESTION',
                        style: GoogleFonts.inter(
                          color: accent,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Icon(
                      icon,
                      color: ink.withValues(alpha: 0.72),
                      size: 32,
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: 52,
                      height: 1,
                      color: accent.withValues(alpha: 0.36),
                    ),
                    const SizedBox(height: 11),
                    for (final width in const [0.86, 0.66, 0.78])
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: FractionallySizedBox(
                          widthFactor: width,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: ink.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            modeLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.bebasNeue(
              color: ink.withValues(alpha: 0.82),
              fontSize: 18,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _TchinModeCardBackContent extends StatelessWidget {
  final String modeName;
  final Color accent;
  final IconData icon;
  final bool isBorderline;

  const _TchinModeCardBackContent({
    required this.modeName,
    required this.accent,
    required this.icon,
    required this.isBorderline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 78,
        height: 78,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.2),
          border: Border.all(color: accent.withValues(alpha: 0.62), width: 1.4),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.18),
              blurRadius: 18,
            ),
          ],
        ),
        child: isBorderline
            ? const TchinDevilSeal(size: 60)
            : Icon(
                icon,
                color: accent.withValues(alpha: 0.92),
                size: 36,
              ),
      ),
    );
  }
}

class _TchinCornerMark extends StatelessWidget {
  final Color accent;
  final IconData icon;
  final bool small;

  const _TchinCornerMark({
    required this.accent,
    required this.icon,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = small ? 36.0 : 46.0;
    final iconSize = small ? 17.0 : 22.0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _TchinCornerMarkPainter(accent: accent),
            ),
          ),
          Icon(icon, color: accent, size: iconSize),
        ],
      ),
    );
  }
}

class _TchinCornerMarkPainter extends CustomPainter {
  final Color accent;

  const _TchinCornerMarkPainter({required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accent.withValues(alpha: 0.7)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    final soft = Paint()
      ..color = accent.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(size.width * 0.25),
      ),
      soft,
    );
    canvas.drawLine(
      Offset(size.width * 0.18, size.height * 0.16),
      Offset(size.width * 0.52, size.height * 0.16),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.18, size.height * 0.16),
      Offset(size.width * 0.18, size.height * 0.5),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.48, size.height * 0.84),
      Offset(size.width * 0.82, size.height * 0.84),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.82, size.height * 0.5),
      Offset(size.width * 0.82, size.height * 0.84),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _TchinCornerMarkPainter oldDelegate) {
    return oldDelegate.accent != accent;
  }
}

Color _paperColor(TchinCardDesignVariant variant) {
  return switch (variant) {
    TchinCardDesignVariant.comptoir => const Color(0xFFFFF4DB),
    TchinCardDesignVariant.club => const Color(0xFFFFE9C6),
    TchinCardDesignVariant.ticket => const Color(0xFFFFFAED),
  };
}

class _TchinModeCardPainter extends CustomPainter {
  final Color accent;
  final TchinCardDesignVariant variant;
  final bool isBack;
  final bool isBorderline;

  const _TchinModeCardPainter({
    required this.accent,
    required this.variant,
    required this.isBack,
    required this.isBorderline,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final baseColors = _baseGradientColors();
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: baseColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(rect),
    );

    _drawVariantTexture(canvas, size);
    _drawSoftVignette(canvas, size);
    _drawFrame(canvas, size);

    if (!isBack) {
      _drawFrontSafeArea(canvas, size);
    }
  }

  List<Color> _baseGradientColors() {
    if (isBack) {
      return switch (variant) {
        TchinCardDesignVariant.comptoir => [
            const Color(0xFF17100E),
            Color.lerp(const Color(0xFF2A1710), accent, 0.2)!,
            const Color(0xFF090709),
          ],
        TchinCardDesignVariant.club => [
            const Color(0xFF0E0B12),
            Color.lerp(const Color(0xFF241019), accent, 0.25)!,
            const Color(0xFF07060A),
          ],
        TchinCardDesignVariant.ticket => [
            const Color(0xFF1D100B),
            Color.lerp(const Color(0xFF3A1C11), accent, 0.18)!,
            const Color(0xFF0A0606),
          ],
      };
    }

    return switch (variant) {
      TchinCardDesignVariant.comptoir => [
          const Color(0xFFFFF7E5),
          const Color(0xFFEAC67D),
          const Color(0xFFFFEFCB),
        ],
      TchinCardDesignVariant.club => [
          const Color(0xFF151015),
          Color.lerp(const Color(0xFF301319), accent, 0.26)!,
          const Color(0xFF0B090D),
        ],
      TchinCardDesignVariant.ticket => [
          const Color(0xFFFFFAEC),
          const Color(0xFFEED8B4),
          const Color(0xFFFFF1D5),
        ],
    };
  }

  void _drawSoftVignette(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, -0.12),
          radius: 0.88,
          colors: [
            Colors.white.withValues(alpha: isBack ? 0.04 : 0.11),
            Colors.transparent,
            Colors.black.withValues(alpha: isBack ? 0.28 : 0.12),
          ],
          stops: const [0, 0.64, 1],
        ).createShader(rect),
    );
  }

  void _drawVariantTexture(Canvas canvas, Size size) {
    switch (variant) {
      case TchinCardDesignVariant.comptoir:
        _drawComptoirTexture(canvas, size);
      case TchinCardDesignVariant.club:
        _drawClubTexture(canvas, size);
      case TchinCardDesignVariant.ticket:
        _drawTicketTexture(canvas, size);
    }
  }

  void _drawComptoirTexture(Canvas canvas, Size size) {
    final line = Paint()
      ..color = (isBack ? Colors.white : const Color(0xFF25140C))
          .withValues(alpha: isBack ? 0.055 : 0.045)
      ..strokeWidth = isBack ? 4.5 : 1.8
      ..strokeCap = StrokeCap.round;
    for (double x = -size.height; x < size.width; x += isBack ? 24 : 36) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), line);
    }

    final ring = Paint()
      ..color = accent.withValues(alpha: isBack ? 0.24 : 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isBack ? 1.8 : 1.2;
    final stampCenter = Offset(size.width * 0.5, size.height * 0.5);
    canvas.drawCircle(stampCenter, size.width * 0.23, ring);
    canvas.drawCircle(stampCenter, size.width * 0.16, ring);

    final bar = Paint()
      ..color = accent.withValues(alpha: isBack ? 0.32 : 0.22)
      ..strokeWidth = isBack ? 2.2 : 1.4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.22, size.height * 0.14),
      Offset(size.width * 0.78, size.height * 0.14),
      bar,
    );
    canvas.drawLine(
      Offset(size.width * 0.22, size.height * 0.86),
      Offset(size.width * 0.78, size.height * 0.86),
      bar,
    );
  }

  void _drawClubTexture(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          accent.withValues(alpha: isBack ? 0.24 : 0.18),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: size.width * 0.68),
      );
    canvas.drawCircle(center, size.width * 0.68, glow);

    final ring = Paint()
      ..color = accent.withValues(alpha: isBack ? 0.34 : 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    for (final scale in const [0.32, 0.46, 0.62]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center,
            width: size.width * scale,
            height: size.height * scale * 0.68,
          ),
          Radius.circular(size.width * 0.08),
        ),
        ring,
      );
    }

    final corner = Paint()
      ..color = Colors.white.withValues(alpha: isBack ? 0.1 : 0.055)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final margin = size.width * 0.16;
    final short = size.width * 0.15;
    for (final point in [
      Offset(margin, margin),
      Offset(size.width - margin, margin),
      Offset(margin, size.height - margin),
      Offset(size.width - margin, size.height - margin),
    ]) {
      final xDir = point.dx < size.width / 2 ? 1.0 : -1.0;
      final yDir = point.dy < size.height / 2 ? 1.0 : -1.0;
      canvas.drawLine(point, point.translate(short * xDir, 0), corner);
      canvas.drawLine(point, point.translate(0, short * yDir), corner);
    }
  }

  void _drawTicketTexture(Canvas canvas, Size size) {
    final rule = Paint()
      ..color = (isBack ? Colors.white : const Color(0xFF2C160D))
          .withValues(alpha: isBack ? 0.045 : 0.04)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 12; i++) {
      final y = size.height * (0.2 + i * 0.052);
      canvas.drawLine(
        Offset(size.width * 0.16, y),
        Offset(size.width * 0.84, y),
        rule,
      );
    }

    final perforation = Paint()
      ..color = isBack
          ? Colors.black.withValues(alpha: 0.22)
          : const Color(0xFFFFF6E4).withValues(alpha: 0.96);
    const count = 10;
    for (var i = 0; i <= count; i++) {
      final x = size.width * (i / count);
      canvas.drawCircle(Offset(x, 0), 4.6, perforation);
      canvas.drawCircle(Offset(x, size.height), 4.6, perforation);
    }

    final side = Paint()
      ..color = accent.withValues(alpha: isBack ? 0.28 : 0.18)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.18),
      Offset(size.width * 0.12, size.height * 0.82),
      side,
    );
    canvas.drawLine(
      Offset(size.width * 0.88, size.height * 0.18),
      Offset(size.width * 0.88, size.height * 0.82),
      side,
    );
  }

  void _drawFrame(Canvas canvas, Size size) {
    final outer = Paint()
      ..color = accent.withValues(alpha: isBack ? 0.58 : 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isBack ? 1.6 : 1.35;
    final inner = Paint()
      ..color = (variant == TchinCardDesignVariant.club && !isBack
              ? const Color(0xFFFFEDC9)
              : Colors.white)
          .withValues(alpha: isBack ? 0.13 : 0.34)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(8, 8, size.width - 16, size.height - 16),
        const Radius.circular(13),
      ),
      outer,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(17, 17, size.width - 34, size.height - 34),
        const Radius.circular(10),
      ),
      inner,
    );
  }

  void _drawFrontSafeArea(Canvas canvas, Size size) {
    final topLine = Paint()
      ..color = accent.withValues(alpha: isBorderline ? 0.34 : 0.24)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.22, size.height * 0.18),
      Offset(size.width * 0.78, size.height * 0.18),
      topLine,
    );
    canvas.drawLine(
      Offset(size.width * 0.22, size.height * 0.82),
      Offset(size.width * 0.78, size.height * 0.82),
      topLine,
    );
  }

  @override
  bool shouldRepaint(covariant _TchinModeCardPainter oldDelegate) {
    return oldDelegate.accent != accent ||
        oldDelegate.variant != variant ||
        oldDelegate.isBack != isBack ||
        oldDelegate.isBorderline != isBorderline;
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
