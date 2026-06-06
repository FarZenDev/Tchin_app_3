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
      TchinCardDesignVariant.comptoir => 'Comptoir',
      TchinCardDesignVariant.club => 'Club',
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
              color: Colors.black.withValues(alpha: 0.32),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: accent.withValues(alpha: isBorderline ? 0.24 : 0.14),
              blurRadius: 22,
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
      child: Container(
        width: 94,
        height: 94,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.22),
          border: Border.all(color: accent.withValues(alpha: 0.68), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: isBorderline ? 0.26 : 0.16),
              blurRadius: 22,
            ),
          ],
        ),
        child: isBorderline
            ? const TchinDevilSeal(size: 72)
            : Icon(
                icon,
                color: accent.withValues(alpha: 0.92),
                size: 44,
              ),
      ),
    );
  }

  Widget _buildFront() {
    final ink =
        isBorderline ? const Color(0xFF2A0608) : const Color(0xFF25140C);
    return Stack(
      children: [
        Positioned(
          left: 16,
          top: 16,
          child: _TchinCornerMark(accent: accent, icon: icon, small: true),
        ),
        if (isBorderline)
          const Positioned(
            left: 0,
            right: 0,
            top: 20,
            child: const Center(child: TchinDevilSeal(size: 36)),
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
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: _paperColor(variant),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: accent.withValues(alpha: 0.24),
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
                      width: 42,
                      height: 3,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.82),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Icon(
                      icon,
                      color: ink.withValues(alpha: 0.72),
                      size: 32,
                    ),
                    const SizedBox(height: 14),
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
    return Container(
      width: small ? 32 : 42,
      height: small ? 32 : 42,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withValues(alpha: 0.32)),
      ),
      child: Icon(icon, color: accent, size: small ? 17 : 22),
    );
  }
}

Color _paperColor(TchinCardDesignVariant variant) {
  return switch (variant) {
    TchinCardDesignVariant.comptoir => const Color(0xFFFFF5D9),
    TchinCardDesignVariant.club => const Color(0xFFFFEFD4),
    TchinCardDesignVariant.ticket => const Color(0xFFFFF9E8),
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
    _drawFrame(canvas, size);

    if (!isBack) {
      _drawFrontSafeArea(canvas, size);
    }
  }

  List<Color> _baseGradientColors() {
    if (isBack) {
      return switch (variant) {
        TchinCardDesignVariant.comptoir => [
            Color.lerp(const Color(0xFF20100B), accent, 0.16)!,
            Color.lerp(const Color(0xFF613018), accent, 0.18)!,
            const Color(0xFF120706),
          ],
        TchinCardDesignVariant.club => [
            const Color(0xFF100916),
            Color.lerp(const Color(0xFF23112A), accent, 0.24)!,
            const Color(0xFF08060B),
          ],
        TchinCardDesignVariant.ticket => [
            Color.lerp(const Color(0xFF2C150C), accent, 0.12)!,
            const Color(0xFF4B2613),
            const Color(0xFF140805),
          ],
      };
    }

    return switch (variant) {
      TchinCardDesignVariant.comptoir => [
          const Color(0xFFFFF8E6),
          const Color(0xFFF3DEB6),
          const Color(0xFFFFF2D2),
        ],
      TchinCardDesignVariant.club => [
          const Color(0xFF21191D),
          Color.lerp(const Color(0xFF2C211C), accent, 0.18)!,
          const Color(0xFF171114),
        ],
      TchinCardDesignVariant.ticket => [
          const Color(0xFFFFF8E6),
          const Color(0xFFF5E8CA),
          const Color(0xFFFFF3D5),
        ],
    };
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
      ..color = (isBack ? Colors.white : accent)
          .withValues(alpha: isBack ? 0.05 : 0.055)
      ..strokeWidth = isBack ? 5 : 2.2
      ..strokeCap = StrokeCap.round;
    for (double x = -size.height; x < size.width; x += isBack ? 22 : 30) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), line);
    }

    final ring = Paint()
      ..color = accent.withValues(alpha: isBack ? 0.2 : 0.11)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    for (var i = 0; i < 4; i++) {
      final center = Offset(
        size.width * (0.22 + (i % 2) * 0.56),
        size.height * (0.18 + i * 0.2),
      );
      canvas.drawCircle(center, size.width * 0.08, ring);
    }
  }

  void _drawClubTexture(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final ray = Paint()
      ..color = accent.withValues(alpha: isBack ? 0.18 : 0.08)
      ..strokeWidth = isBack ? 2.6 : 1.6
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 22; i++) {
      final angle = (math.pi * 2 / 22) * i;
      final startRadius = size.width * (isBack ? 0.18 : 0.34);
      final endRadius = size.width * (isBack ? 0.74 : 0.56);
      canvas.drawLine(
        Offset(
          center.dx + math.cos(angle) * startRadius,
          center.dy + math.sin(angle) * startRadius,
        ),
        Offset(
          center.dx + math.cos(angle) * endRadius,
          center.dy + math.sin(angle) * endRadius,
        ),
        ray,
      );
    }

    final dot = Paint()
      ..color = Colors.white.withValues(alpha: isBack ? 0.09 : 0.04);
    for (var i = 0; i < 26; i++) {
      final x = size.width * (0.1 + ((i * 37) % 81) / 100);
      final y = size.height * (0.08 + ((i * 23) % 86) / 100);
      canvas.drawCircle(Offset(x, y), 1.2 + (i % 3) * 0.6, dot);
    }
  }

  void _drawTicketTexture(Canvas canvas, Size size) {
    final grain = Paint()
      ..color = Colors.black.withValues(alpha: isBack ? 0.07 : 0.04)
      ..strokeWidth = 1;
    for (var i = 0; i < 18; i++) {
      final y = size.height * (0.08 + i * 0.05);
      canvas.drawLine(
        Offset(size.width * 0.08, y),
        Offset(size.width * 0.92, y + ((i % 2) == 0 ? 0.8 : -0.8)),
        grain,
      );
    }

    final notch = Paint()
      ..color = isBack
          ? Colors.black.withValues(alpha: 0.22)
          : const Color(0xFFFFF8E6).withValues(alpha: 0.86);
    const count = 9;
    for (var i = 0; i <= count; i++) {
      final x = size.width * (i / count);
      canvas.drawCircle(Offset(x, 0), 5, notch);
      canvas.drawCircle(Offset(x, size.height), 5, notch);
    }
  }

  void _drawFrame(Canvas canvas, Size size) {
    final outer = Paint()
      ..color = accent.withValues(alpha: isBack ? 0.54 : 0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final inner = Paint()
      ..color = Colors.white.withValues(alpha: isBack ? 0.13 : 0.24)
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
      ..color = accent.withValues(alpha: isBorderline ? 0.36 : 0.22)
      ..strokeWidth = 1.3
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
