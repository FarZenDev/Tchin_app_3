import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum TchinCardDesignVariant {
  comptoir,
  club,
  ticket,
}

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
    final skin = _TchinCardSkin.resolve(
      modeName: modeName,
      accent: accent,
      icon: icon,
      variant: variant,
      isBorderline: isBorderline,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        children: [
          Positioned.fill(
            child: isBack
                ? Image.asset(_tchinCardBackAsset, fit: BoxFit.fill)
                : _TchinCosmeticCardFace(
                    skin: skin,
                    borderRadius: borderRadius,
                  ),
          ),
          if (!isBack)
            Positioned.fill(
              child: _TchinCardFaceInk(skin: skin),
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

enum _TchinCardPattern {
  lager,
  duo,
  bar,
  chill,
  hot,
  express,
  borderline,
}

class _TchinCardSkin {
  final String name;
  final String label;
  final Color top;
  final Color middle;
  final Color bottom;
  final Color panel;
  final Color ink;
  final Color accent;
  final Color accentAlt;
  final IconData icon;
  final TchinCardDesignVariant variant;
  final _TchinCardPattern pattern;
  final bool isDark;

  const _TchinCardSkin({
    required this.name,
    required this.label,
    required this.top,
    required this.middle,
    required this.bottom,
    required this.panel,
    required this.ink,
    required this.accent,
    required this.accentAlt,
    required this.icon,
    required this.variant,
    required this.pattern,
    this.isDark = false,
  });

  static _TchinCardSkin resolve({
    required String modeName,
    required Color accent,
    required IconData icon,
    required TchinCardDesignVariant variant,
    required bool isBorderline,
  }) {
    final label = modeName.toLowerCase();
    if (isBorderline || label.contains('borderline')) {
      return _TchinCardSkin(
        name: 'Borderline',
        label: 'PACTE NOIR',
        top: const Color(0xFF3B0408),
        middle: const Color(0xFFB51623),
        bottom: const Color(0xFF180206),
        panel: const Color(0xFFFFD9B5),
        ink: const Color(0xFF230407),
        accent: const Color(0xFFFF343D),
        accentAlt: const Color(0xFFFF9C2F),
        icon: Icons.local_fire_department_rounded,
        variant: variant,
        pattern: _TchinCardPattern.borderline,
        isDark: true,
      );
    }
    if (label.contains('duo')) {
      return _TchinCardSkin(
        name: 'Duo',
        label: 'DOUBLE TOUR',
        top: const Color(0xFF43102E),
        middle: const Color(0xFFE91E8C),
        bottom: const Color(0xFF200B22),
        panel: const Color(0xFFFFE1EF),
        ink: const Color(0xFF28111E),
        accent: const Color(0xFFE91E8C),
        accentAlt: const Color(0xFFFFB3D7),
        icon: Icons.groups_rounded,
        variant: variant,
        pattern: _TchinCardPattern.duo,
        isDark: true,
      );
    }
    if (label.contains('bar')) {
      return _TchinCardSkin(
        name: 'Bar',
        label: 'COMPTOIR',
        top: const Color(0xFF1B0A25),
        middle: const Color(0xFF7F3DA3),
        bottom: const Color(0xFF0D0614),
        panel: const Color(0xFFFFEBD3),
        ink: const Color(0xFF211327),
        accent: const Color(0xFFB06DE0),
        accentAlt: const Color(0xFFFFBE5B),
        icon: Icons.local_bar_rounded,
        variant: variant,
        pattern: _TchinCardPattern.bar,
        isDark: true,
      );
    }
    if (label.contains('chill')) {
      return _TchinCardSkin(
        name: 'Chill',
        label: 'LOUNGE',
        top: const Color(0xFF073847),
        middle: const Color(0xFF00BCD4),
        bottom: const Color(0xFF10283A),
        panel: const Color(0xFFE5FAFF),
        ink: const Color(0xFF0B2530),
        accent: const Color(0xFF00BCD4),
        accentAlt: const Color(0xFFFFD66B),
        icon: Icons.spa_rounded,
        variant: variant,
        pattern: _TchinCardPattern.chill,
        isDark: true,
      );
    }
    if (label.contains('hot')) {
      return _TchinCardSkin(
        name: 'Hot',
        label: 'COUP DE CHAUD',
        top: const Color(0xFF4A1208),
        middle: const Color(0xFFFF5722),
        bottom: const Color(0xFF260A05),
        panel: const Color(0xFFFFE1CA),
        ink: const Color(0xFF301107),
        accent: const Color(0xFFFF5722),
        accentAlt: const Color(0xFFFFC247),
        icon: Icons.local_fire_department_rounded,
        variant: variant,
        pattern: _TchinCardPattern.hot,
        isDark: true,
      );
    }
    if (label.contains('express')) {
      return _TchinCardSkin(
        name: 'Express',
        label: 'SERVICE RAPIDE',
        top: const Color(0xFF06351C),
        middle: const Color(0xFF00C76B),
        bottom: const Color(0xFF041A12),
        panel: const Color(0xFFE6FFF0),
        ink: const Color(0xFF071E13),
        accent: const Color(0xFF00E676),
        accentAlt: const Color(0xFFFFD65E),
        icon: Icons.bolt_rounded,
        variant: variant,
        pattern: _TchinCardPattern.express,
        isDark: true,
      );
    }

    return _TchinCardSkin(
      name: 'Classique',
      label: 'LE TCHIN BAR',
      top: const Color(0xFFFFF2C8),
      middle: const Color(0xFFD99023),
      bottom: const Color(0xFF6C3A0B),
      panel: const Color(0xFFFFEECF),
      ink: const Color(0xFF2B1A0D),
      accent: accent,
      accentAlt: const Color(0xFF4C2C11),
      icon: icon,
      variant: variant,
      pattern: _TchinCardPattern.lager,
    );
  }
}

class _TchinCosmeticCardFace extends StatelessWidget {
  final _TchinCardSkin skin;
  final double borderRadius;

  const _TchinCosmeticCardFace({
    required this.skin,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _TchinCosmeticCardFacePainter(skin: skin),
          ),
        ),
        Positioned(
          top: 11,
          left: 0,
          right: 0,
          child: Center(child: _TchinSkinLogo(skin: skin)),
        ),
        Positioned(
          left: 22,
          right: 22,
          top: 65,
          child: _TchinSkinRibbon(skin: skin),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 20,
          child: _TchinSkinFooter(skin: skin),
        ),
      ],
    );
  }
}

class _TchinSkinLogo extends StatelessWidget {
  final _TchinCardSkin skin;

  const _TchinSkinLogo({required this.skin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [skin.accentAlt, skin.accent, skin.bottom],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: skin.accent.withValues(alpha: 0.36),
            blurRadius: 22,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF090B15),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/app_icon.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _TchinSkinRibbon extends StatelessWidget {
  final _TchinCardSkin skin;

  const _TchinSkinRibbon({required this.skin});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _ribbonLine()),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: skin.isDark
                ? Colors.black.withValues(alpha: 0.34)
                : Colors.white.withValues(alpha: 0.42),
            border: Border.all(color: skin.accent.withValues(alpha: 0.52)),
            boxShadow: [
              BoxShadow(
                color: skin.accent.withValues(alpha: 0.18),
                blurRadius: 14,
              ),
            ],
          ),
          child: Text(
            skin.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: skin.isDark
                  ? Colors.white.withValues(alpha: 0.92)
                  : skin.ink.withValues(alpha: 0.82),
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.9,
            ),
          ),
        ),
        Expanded(child: _ribbonLine()),
      ],
    );
  }

  Widget _ribbonLine() {
    return Container(
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          colors: [
            skin.accent.withValues(alpha: 0),
            skin.accentAlt.withValues(alpha: 0.8),
            skin.accent.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

class _TchinSkinFooter extends StatelessWidget {
  final _TchinCardSkin skin;

  const _TchinSkinFooter({required this.skin});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(skin.icon, size: 15, color: skin.accent.withValues(alpha: 0.72)),
        const SizedBox(width: 7),
        Expanded(
          child: Container(
            height: 1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: skin.accent.withValues(alpha: 0.34),
            ),
          ),
        ),
        const SizedBox(width: 9),
        Text(
          skin.name.toUpperCase(),
          style: GoogleFonts.inter(
            color: skin.isDark
                ? Colors.white.withValues(alpha: 0.58)
                : skin.ink.withValues(alpha: 0.42),
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Container(
            height: 1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: skin.accent.withValues(alpha: 0.34),
            ),
          ),
        ),
        const SizedBox(width: 7),
        Icon(skin.icon, size: 15, color: skin.accent.withValues(alpha: 0.72)),
      ],
    );
  }
}

class _TchinCosmeticCardFacePainter extends CustomPainter {
  final _TchinCardSkin skin;

  const _TchinCosmeticCardFacePainter({required this.skin});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final base = Paint()
      ..shader = LinearGradient(
        colors: [skin.top, skin.middle, skin.bottom],
        stops: const [0, 0.52, 1],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);
    canvas.drawRect(rect, base);

    _drawAtmosphere(canvas, size);
    _drawModePattern(canvas, size);
    _drawVariantLayer(canvas, size);
    _drawVignette(canvas, size);
    _drawFrame(canvas, size);
    _drawQuestionPlate(canvas, size);
  }

  void _drawAtmosphere(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, -0.34),
          radius: 0.9,
          colors: [
            Colors.white.withValues(alpha: skin.isDark ? 0.16 : 0.24),
            skin.accent.withValues(alpha: skin.isDark ? 0.18 : 0.12),
            Colors.transparent,
          ],
          stops: const [0, 0.42, 1],
        ).createShader(Offset.zero & size),
    );

    final grain = Paint();
    for (var i = 0; i < 120; i++) {
      final x = ((i * 37) % 101) / 100 * size.width;
      final y = ((i * 53) % 103) / 102 * size.height;
      final alpha = skin.isDark ? 0.06 : 0.09;
      grain.color = (i.isEven ? Colors.white : skin.ink)
          .withValues(alpha: alpha * (i % 5 + 1) / 5);
      canvas.drawCircle(Offset(x, y), 0.6 + (i % 4) * 0.35, grain);
    }
  }

  void _drawModePattern(Canvas canvas, Size size) {
    switch (skin.pattern) {
      case _TchinCardPattern.lager:
        _drawLager(canvas, size);
      case _TchinCardPattern.duo:
        _drawDuo(canvas, size);
      case _TchinCardPattern.bar:
        _drawBar(canvas, size);
      case _TchinCardPattern.chill:
        _drawChill(canvas, size);
      case _TchinCardPattern.hot:
        _drawHot(canvas, size);
      case _TchinCardPattern.express:
        _drawExpress(canvas, size);
      case _TchinCardPattern.borderline:
        _drawBorderline(canvas, size);
    }
  }

  void _drawVariantLayer(Canvas canvas, Size size) {
    switch (skin.variant) {
      case TchinCardDesignVariant.comptoir:
        final stamp = Paint()
          ..color = Colors.black.withValues(alpha: skin.isDark ? 0.08 : 0.045)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        for (var i = 0; i < 4; i++) {
          final rect = Rect.fromCenter(
            center: Offset(
              size.width * (0.22 + i * 0.19),
              size.height * (i.isEven ? 0.84 : 0.14),
            ),
            width: size.width * 0.18,
            height: size.width * 0.18,
          );
          canvas.drawArc(rect, 0.2, math.pi * 1.35, false, stamp);
        }
      case TchinCardDesignVariant.club:
        final neon = Paint()
          ..color = skin.accentAlt.withValues(alpha: skin.isDark ? 0.22 : 0.14)
          ..strokeWidth = 1.5;
        for (var i = 0; i < 9; i++) {
          final x = size.width * (0.08 + i * 0.105);
          canvas.drawLine(
            Offset(x, size.height * 0.08),
            Offset(size.width * 0.5, size.height * 0.52),
            neon,
          );
          canvas.drawLine(
            Offset(x, size.height * 0.92),
            Offset(size.width * 0.5, size.height * 0.52),
            neon,
          );
        }
      case TchinCardDesignVariant.ticket:
        final cut = Paint()
          ..color = Colors.white.withValues(alpha: skin.isDark ? 0.18 : 0.32);
        final ink = Paint()
          ..color = skin.ink.withValues(alpha: skin.isDark ? 0.18 : 0.1)
          ..strokeWidth = 1.3;
        for (var i = 0; i < 12; i++) {
          final y = size.height * (0.1 + i * 0.073);
          canvas.drawCircle(Offset(size.width * 0.038, y), 4.2, cut);
          canvas.drawCircle(Offset(size.width * 0.962, y), 4.2, cut);
        }
        canvas.drawLine(
          Offset(size.width * 0.08, size.height * 0.1),
          Offset(size.width * 0.08, size.height * 0.9),
          ink,
        );
        canvas.drawLine(
          Offset(size.width * 0.92, size.height * 0.1),
          Offset(size.width * 0.92, size.height * 0.9),
          ink,
        );
    }
  }

  void _drawLager(Canvas canvas, Size size) {
    final ray = Paint()
      ..color = Colors.white.withValues(alpha: 0.16)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final center = Offset(size.width / 2, size.height * 0.2);
    for (var i = 0; i < 26; i++) {
      final angle = -math.pi * 0.84 + i * math.pi / 25;
      final start = center + Offset(math.cos(angle), math.sin(angle)) * 35;
      final end = center + Offset(math.cos(angle), math.sin(angle)) * 260;
      canvas.drawLine(start, end, ray);
    }
    _drawBubbles(canvas, size, Colors.white, 0.22);
    _drawDiagonalBands(canvas, size, skin.accentAlt, 0.1, 28);
  }

  void _drawDuo(Canvas canvas, Size size) {
    _drawDiagonalBands(canvas, size, Colors.white, 0.1, 24);
    final paint = Paint()
      ..color = skin.accentAlt.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (var i = 0; i < 7; i++) {
      final y = size.height * (0.18 + i * 0.11);
      canvas.drawCircle(Offset(size.width * 0.25, y), size.width * 0.09, paint);
      canvas.drawCircle(
          Offset(size.width * 0.75, y + 12), size.width * 0.09, paint);
    }
  }

  void _drawBar(Canvas canvas, Size size) {
    final shelf = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 6; i++) {
      final y = size.height * (0.18 + i * 0.13);
      canvas.drawLine(
          Offset(size.width * 0.1, y), Offset(size.width * 0.9, y), shelf);
      for (var j = 0; j < 5; j++) {
        final x = size.width * (0.18 + j * 0.16);
        final bottle = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y - 32, 13, 28),
          const Radius.circular(3),
        );
        canvas.drawRRect(
            bottle, Paint()..color = skin.accentAlt.withValues(alpha: 0.18));
      }
    }
    _drawDiagonalBands(canvas, size, skin.accent, 0.12, 18);
  }

  void _drawChill(Canvas canvas, Size size) {
    final wave = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    for (var i = 0; i < 8; i++) {
      final y = size.height * (0.16 + i * 0.09);
      final path = Path()..moveTo(size.width * 0.08, y);
      for (var x = size.width * 0.08;
          x <= size.width * 0.92;
          x += size.width * 0.18) {
        path.quadraticBezierTo(
            x + size.width * 0.045, y - 18, x + size.width * 0.09, y);
        path.quadraticBezierTo(
            x + size.width * 0.135, y + 18, x + size.width * 0.18, y);
      }
      canvas.drawPath(path, wave);
    }
    _drawBubbles(canvas, size, skin.accentAlt, 0.2);
  }

  void _drawHot(Canvas canvas, Size size) {
    _drawDiagonalBands(canvas, size, skin.accentAlt, 0.16, 18);
    final flame = Paint()
      ..color = skin.accentAlt.withValues(alpha: 0.24)
      ..style = PaintingStyle.fill;
    for (var i = 0; i < 10; i++) {
      final x = size.width * (0.08 + (i % 5) * 0.2);
      final y = size.height * (0.24 + (i ~/ 5) * 0.46);
      final path = Path()
        ..moveTo(x, y + 70)
        ..cubicTo(x - 22, y + 28, x + 8, y + 17, x + 2, y)
        ..cubicTo(x + 34, y + 28, x + 27, y + 52, x, y + 70)
        ..close();
      canvas.drawPath(path, flame);
    }
  }

  void _drawExpress(Canvas canvas, Size size) {
    final speed = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 15; i++) {
      final y = size.height * (0.12 + i * 0.055);
      final x = size.width * ((i % 3) * 0.1);
      canvas.drawLine(
        Offset(x, y),
        Offset(size.width * 0.58 + x, y - size.height * 0.12),
        speed,
      );
    }
    final bolt = Paint()
      ..color = skin.accentAlt.withValues(alpha: 0.26)
      ..style = PaintingStyle.fill;
    for (var i = 0; i < 5; i++) {
      final x = size.width * (0.18 + i * 0.17);
      final y = size.height * (0.22 + (i % 2) * 0.42);
      final path = Path()
        ..moveTo(x + 18, y)
        ..lineTo(x - 5, y + 52)
        ..lineTo(x + 18, y + 48)
        ..lineTo(x - 2, y + 102)
        ..lineTo(x + 52, y + 32)
        ..lineTo(x + 25, y + 37)
        ..close();
      canvas.drawPath(path, bolt);
    }
  }

  void _drawBorderline(Canvas canvas, Size size) {
    _drawDiagonalBands(canvas, size, Colors.black, 0.24, 22);
    final smoke = Paint()
      ..color = skin.accentAlt.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    for (var i = 0; i < 9; i++) {
      final x = size.width * (0.08 + i * 0.11);
      final path = Path()
        ..moveTo(x, size.height * 0.9)
        ..cubicTo(
          x - 18,
          size.height * 0.72,
          x + 24,
          size.height * 0.62,
          x,
          size.height * 0.45,
        )
        ..cubicTo(
          x - 20,
          size.height * 0.31,
          x + 22,
          size.height * 0.2,
          x,
          size.height * 0.1,
        );
      canvas.drawPath(path, smoke);
    }
    final ember = Paint()..color = skin.accentAlt.withValues(alpha: 0.5);
    for (var i = 0; i < 34; i++) {
      final x = ((i * 29) % 97) / 96 * size.width;
      final y = size.height * (0.18 + (((i * 43) % 87) / 100));
      canvas.drawCircle(Offset(x, y), 1.2 + (i % 3), ember);
    }
  }

  void _drawDiagonalBands(
    Canvas canvas,
    Size size,
    Color color,
    double alpha,
    double gap,
  ) {
    final paint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..strokeWidth = gap * 0.35
      ..strokeCap = StrokeCap.round;
    for (var x = -size.height; x < size.width + size.height; x += gap) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height * 0.72, size.height),
        paint,
      );
    }
  }

  void _drawBubbles(Canvas canvas, Size size, Color color, double alpha) {
    final bubble = Paint()
      ..color = color.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    for (var i = 0; i < 32; i++) {
      final x = ((i * 41) % 101) / 100 * size.width;
      final y = ((i * 31) % 103) / 102 * size.height;
      canvas.drawCircle(Offset(x, y), 4 + (i % 5) * 2.3, bubble);
    }
  }

  void _drawVignette(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          radius: 0.86,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: skin.isDark ? 0.28 : 0.13),
          ],
        ).createShader(Offset.zero & size),
    );
  }

  void _drawFrame(Canvas canvas, Size size) {
    final outer = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.045,
        size.height * 0.035,
        size.width * 0.91,
        size.height * 0.93,
      ),
      Radius.circular(size.width * 0.05),
    );
    final mid = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.074,
        size.height * 0.065,
        size.width * 0.852,
        size.height * 0.87,
      ),
      Radius.circular(size.width * 0.034),
    );

    canvas.drawRRect(
      outer,
      Paint()
        ..color = Colors.black.withValues(alpha: skin.isDark ? 0.48 : 0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    canvas.drawRRect(
      mid,
      Paint()
        ..color = skin.accentAlt.withValues(alpha: 0.62)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    final corner = Paint()
      ..color = Colors.white.withValues(alpha: skin.isDark ? 0.24 : 0.2)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final points = [
      Offset(size.width * 0.12, size.height * 0.12),
      Offset(size.width * 0.88, size.height * 0.12),
      Offset(size.width * 0.12, size.height * 0.88),
      Offset(size.width * 0.88, size.height * 0.88),
    ];
    for (final p in points) {
      final xDir = p.dx < size.width / 2 ? 1.0 : -1.0;
      final yDir = p.dy < size.height / 2 ? 1.0 : -1.0;
      canvas.drawLine(p, p.translate(size.width * 0.09 * xDir, 0), corner);
      canvas.drawLine(p, p.translate(0, size.height * 0.052 * yDir), corner);
    }
  }

  void _drawQuestionPlate(Canvas canvas, Size size) {
    final plate = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.115,
        size.height * 0.18,
        size.width * 0.77,
        size.height * 0.61,
      ),
      Radius.circular(size.width * 0.055),
    );

    final plateRect = plate.outerRect;
    final warmPanel =
        Color.lerp(skin.panel, skin.middle, skin.isDark ? 0.18 : 0.26)!;
    final deepPanel =
        Color.lerp(skin.panel, skin.bottom, skin.isDark ? 0.1 : 0.22)!;
    final platePath = Path()..addRRect(plate);

    canvas.drawRRect(
      plate,
      Paint()
        ..shader = LinearGradient(
          colors: [
            warmPanel.withValues(alpha: skin.isDark ? 0.78 : 0.7),
            skin.panel.withValues(alpha: skin.isDark ? 0.74 : 0.64),
            deepPanel.withValues(alpha: skin.isDark ? 0.8 : 0.72),
          ],
          stops: const [0, 0.5, 1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(plateRect)
        ..style = PaintingStyle.fill,
    );

    canvas.save();
    canvas.clipPath(platePath);
    final glassGlow = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.55),
        radius: 0.92,
        colors: [
          Colors.white.withValues(alpha: skin.isDark ? 0.2 : 0.18),
          skin.accent.withValues(alpha: skin.isDark ? 0.1 : 0.08),
          Colors.transparent,
        ],
        stops: const [0, 0.45, 1],
      ).createShader(plateRect);
    canvas.drawRect(plateRect, glassGlow);

    final bandPaint = Paint()
      ..color = skin.accent.withValues(alpha: skin.isDark ? 0.075 : 0.095)
      ..strokeWidth = size.width * 0.032
      ..strokeCap = StrokeCap.round;
    for (var x = plateRect.left - size.height;
        x < plateRect.right;
        x += size.width * 0.105) {
      canvas.drawLine(
        Offset(x, plateRect.top + 8),
        Offset(x + size.height * 0.58, plateRect.bottom - 8),
        bandPaint,
      );
    }

    final speck = Paint()
      ..color = skin.ink.withValues(alpha: skin.isDark ? 0.045 : 0.055);
    for (var i = 0; i < 54; i++) {
      final x = plateRect.left + (((i * 37) % 97) / 96) * plateRect.width;
      final y = plateRect.top + (((i * 53) % 101) / 100) * plateRect.height;
      canvas.drawCircle(Offset(x, y), 0.55 + (i % 3) * 0.28, speck);
    }
    canvas.restore();

    canvas.drawRRect(
      plate,
      Paint()
        ..color = skin.accentAlt.withValues(alpha: skin.isDark ? 0.36 : 0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5,
    );
    canvas.drawRRect(
      plate.deflate(5),
      Paint()
        ..color = skin.accent.withValues(alpha: skin.isDark ? 0.46 : 0.34)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    final hatch = Paint()
      ..color = skin.ink.withValues(alpha: skin.isDark ? 0.07 : 0.075)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 7; i++) {
      final y = size.height * (0.27 + i * 0.067);
      final path = Path()
        ..moveTo(size.width * 0.18, y)
        ..cubicTo(
          size.width * 0.34,
          y - 7,
          size.width * 0.48,
          y + 7,
          size.width * 0.82,
          y - 3,
        );
      canvas.drawPath(path, hatch);
    }

    final watermark = Paint()
      ..color = skin.ink.withValues(alpha: skin.isDark ? 0.07 : 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.48),
      size.width * 0.17,
      watermark,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.48),
      size.width * 0.1,
      watermark,
    );
  }

  @override
  bool shouldRepaint(covariant _TchinCosmeticCardFacePainter oldDelegate) {
    return oldDelegate.skin != skin;
  }
}

class _TchinCardFaceInk extends StatelessWidget {
  final _TchinCardSkin skin;

  const _TchinCardFaceInk({required this.skin});

  @override
  Widget build(BuildContext context) {
    final ink = skin.ink;
    final markColor = skin.accent;

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
                    skin: skin,
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
                  text: skin.name.toUpperCase(),
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
                child: _TchinFacePip(icon: skin.icon, color: markColor),
              ),
              Positioned(
                right: width * 0.107,
                bottom: height * 0.232,
                child: Transform.rotate(
                  angle: math.pi,
                  child: _TchinFacePip(icon: skin.icon, color: markColor),
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
  final _TchinCardSkin skin;

  const _TchinCardFaceInkPainter({required this.skin});

  @override
  void paint(Canvas canvas, Size size) {
    final accent = skin.accent;
    final ink = skin.ink;
    final panel = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.09,
        size.height * 0.165,
        size.width * 0.82,
        size.height * 0.64,
      ),
      Radius.circular(size.width * 0.035),
    );

    canvas.drawRRect(
      panel,
      Paint()
        ..color = Colors.white.withValues(alpha: skin.isDark ? 0.075 : 0.045)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      panel,
      Paint()
        ..color = accent.withValues(alpha: skin.isDark ? 0.26 : 0.2)
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
        ..moveTo(size.width * 0.17, y)
        ..cubicTo(
          size.width * 0.34,
          y - 5,
          size.width * 0.52,
          y + 4,
          size.width * 0.83,
          y - 2,
        );
      canvas.drawPath(path, rulePaint);
    }

    final dotPaint = Paint()
      ..color = accent.withValues(alpha: skin.isDark ? 0.28 : 0.2);
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
    return oldDelegate.skin != skin;
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
