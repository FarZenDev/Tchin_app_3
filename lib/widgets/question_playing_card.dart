import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/question_model.dart';
import '../theme/app_theme.dart';
import 'tchin_assets.dart';

class QuestionPlayingCard extends StatelessWidget {
  final Widget child;
  final Color accentColor;
  final String modeLabel;
  final bool isSpecial;
  final bool isBorderline;
  final BorderlineIntensity intensity;
  final Object? animationKey;

  const QuestionPlayingCard({
    super.key,
    required this.child,
    required this.accentColor,
    required this.modeLabel,
    this.isSpecial = false,
    this.isBorderline = false,
    this.intensity = BorderlineIntensity.sale,
    this.animationKey,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth.clamp(260.0, 430.0).toDouble();
        final isCompact = cardWidth < 330;

        return Center(
          child: SizedBox(
            width: cardWidth,
            child: AspectRatio(
              aspectRatio: 0.68,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1050),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return _CardDealTransition(
                    animation: animation,
                    accentColor: accentColor,
                    isBorderline: isBorderline,
                    child: child,
                  );
                },
                child: _CardDeck(
                  key: ValueKey(animationKey ?? modeLabel),
                  accentColor: accentColor,
                  modeLabel: modeLabel,
                  isSpecial: isSpecial,
                  isBorderline: isBorderline,
                  intensity: intensity,
                  isCompact: isCompact,
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CardDeck extends StatelessWidget {
  final Widget child;
  final Color accentColor;
  final String modeLabel;
  final bool isSpecial;
  final bool isBorderline;
  final BorderlineIntensity intensity;
  final bool isCompact;

  const _CardDeck({
    super.key,
    required this.child,
    required this.accentColor,
    required this.modeLabel,
    required this.isSpecial,
    required this.isBorderline,
    required this.intensity,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          top: isCompact ? 16 : 22,
          left: isCompact ? 17 : 24,
          right: isCompact ? -12 : -18,
          bottom: isCompact ? -6 : -8,
          child: Transform.rotate(
            angle: 0.075,
            child: _CardBack(
              accentColor: isBorderline
                  ? const Color(0xFFFF3D3D).withOpacity(0.88)
                  : accentColor.withOpacity(0.82),
              isBorderline: isBorderline,
            ),
          ),
        ),
        Positioned.fill(
          top: isCompact ? 8 : 10,
          left: isCompact ? -11 : -16,
          right: isCompact ? 12 : 18,
          bottom: isCompact ? 6 : 8,
          child: Transform.rotate(
            angle: -0.06,
            child: _CardBack(
              accentColor: isBorderline
                  ? const Color(0xFF5A1212).withOpacity(0.86)
                  : AppTheme.secondary.withOpacity(0.72),
              isBorderline: isBorderline,
            ),
          ),
        ),
        Positioned.fill(
          child: _CardFront(
            accentColor: accentColor,
            modeLabel: modeLabel,
            isSpecial: isSpecial,
            isBorderline: isBorderline,
            intensity: intensity,
            child: child,
          ),
        ),
      ],
    );
  }
}

class _CardDealTransition extends StatelessWidget {
  final Animation<double> animation;
  final Color accentColor;
  final bool isBorderline;
  final Widget child;

  const _CardDealTransition({
    required this.animation,
    required this.accentColor,
    required this.isBorderline,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final isExiting = animation.status == AnimationStatus.reverse;
        final raw = animation.value.clamp(0.0, 1.0).toDouble();

        if (isExiting) {
          final exit = Curves.easeInCubic.transform(1 - raw);
          return Opacity(
            opacity: (1 - exit).clamp(0.0, 1.0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: _CardSwapFx(
                    progress: exit,
                    color: accentColor,
                    isExit: true,
                  ),
                ),
                FractionalTranslation(
                  translation: Offset(-0.58 * exit, -0.08 * exit),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateZ(-0.32 * exit)
                      ..rotateY((pi / 2) * exit),
                    child: Transform.scale(
                      scale: 1 - (0.08 * exit),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final deal = Curves.easeOutCubic.transform(raw);
        final flipProgress =
            Curves.easeInOutCubic.transform(((raw - 0.26) / 0.62).clamp(0, 1));
        final angle = (1 - flipProgress) * pi;
        final showBack = angle > pi / 2;

        return Opacity(
          opacity: (raw * 1.35).clamp(0.0, 1.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: _CardSwapFx(
                  progress: raw,
                  color: accentColor,
                  isExit: false,
                ),
              ),
              FractionalTranslation(
                translation: Offset((1 - deal) * 0.92, (1 - deal) * 0.14),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateZ((1 - deal) * 0.18)
                    ..rotateY(angle),
                  child: Transform.scale(
                    scale: 0.88 + (0.12 * deal),
                    child: showBack
                        ? _CardBack(
                            accentColor: accentColor,
                            isBorderline: isBorderline,
                          )
                        : child,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CardSwapFx extends StatelessWidget {
  final double progress;
  final Color color;
  final bool isExit;

  const _CardSwapFx({
    required this.progress,
    required this.color,
    required this.isExit,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _CardSwapFxPainter(
          progress: progress,
          color: color,
          isExit: isExit,
        ),
      ),
    );
  }
}

class _CardSwapFxPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isExit;

  const _CardSwapFxPainter({
    required this.progress,
    required this.color,
    required this.isExit,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final p = progress.clamp(0.0, 1.0).toDouble();
    if (isExit) {
      final paint = Paint()
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = color.withOpacity((0.35 * (1 - p)).clamp(0.0, 0.35));
      for (var i = 0; i < 6; i++) {
        final y = size.height * (0.18 + (i * 0.12));
        final start = Offset(size.width * (0.72 - p * 0.46), y);
        final end = Offset(size.width * (0.92 - p * 0.34), y - 18 + i * 4);
        canvas.drawLine(start, end, paint);
      }
      return;
    }

    final alpha = (1 - p).clamp(0.0, 1.0).toDouble();
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4
      ..color = color.withOpacity(0.32 * alpha);
    for (var i = 0; i < 7; i++) {
      final y = size.height * (0.2 + (i * 0.1));
      final x = size.width * (0.84 + (i % 2) * 0.04);
      canvas.drawLine(
        Offset(x, y),
        Offset(size.width * 1.12, y - 18),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CardSwapFxPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.isExit != isExit;
  }
}

class _CardFront extends StatelessWidget {
  final Widget child;
  final Color accentColor;
  final String modeLabel;
  final bool isSpecial;
  final bool isBorderline;
  final BorderlineIntensity intensity;

  const _CardFront({
    required this.child,
    required this.accentColor,
    required this.modeLabel,
    required this.isSpecial,
    required this.isBorderline,
    required this.intensity,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 330;
        final radius = isCompact ? 22.0 : 26.0;
        final horizontalPadding = isCompact ? 34.0 : 48.0;
        final topPadding = isCompact ? 68.0 : 78.0;
        final bottomPadding = isCompact ? 60.0 : 72.0;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.36),
                blurRadius: 34,
                offset: const Offset(0, 18),
              ),
              BoxShadow(
                color: isBorderline
                    ? const Color(0xFFFF3028)
                        .withOpacity(0.28 + (0.07 * intensity.level))
                    : accentColor.withOpacity(isSpecial ? 0.45 : 0.22),
                blurRadius: isBorderline ? 80 : (isSpecial ? 72 : 48),
                spreadRadius: isBorderline ? 5 : (isSpecial ? 4 : 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isBorderline
                      ? const [
                          Color(0xFFFFF0D7),
                          Color(0xFFF4C7A5),
                          Color(0xFFFFE4C0),
                        ]
                      : const [
                          Color(0xFFFFF9EA),
                          Color(0xFFF7E9C4),
                          Color(0xFFFFF4D6),
                        ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: _CardFacePainter(
                          accentColor: accentColor,
                          isBorderline: isBorderline,
                          intensity: intensity,
                        ),
                      ),
                    ),
                  ),
                  if (isBorderline)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.topCenter,
                              radius: 0.92,
                              colors: [
                                const Color(0xFFFF3D3D).withOpacity(0.14),
                                Colors.transparent,
                                const Color(0xFF250505).withOpacity(0.16),
                              ],
                              stops: const [0, 0.58, 1],
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.all(isCompact ? 11 : 14),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(isCompact ? 15 : 18),
                          border: Border.all(
                            color: isBorderline
                                ? const Color(0xFF9B1717).withOpacity(0.48)
                                : accentColor.withOpacity(0.34),
                            width: isBorderline ? 1.9 : 1.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isBorderline)
                    Positioned(
                      top: isCompact ? 20 : 24,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: TchinDevilSeal(size: isCompact ? 34 : 42),
                      ),
                    ),
                  Positioned(
                    left: isCompact ? 15 : 20,
                    top: isCompact ? 14 : 18,
                    child: _CardCorner(
                      accentColor: accentColor,
                      isCompact: isCompact,
                    ),
                  ),
                  Positioned(
                    right: isCompact ? 15 : 20,
                    bottom: isCompact ? 14 : 18,
                    child: Transform.rotate(
                      angle: pi,
                      child: _CardCorner(
                        accentColor: accentColor,
                        isCompact: isCompact,
                      ),
                    ),
                  ),
                  Positioned(
                    left: isCompact ? 26 : 32,
                    right: isCompact ? 26 : 32,
                    bottom: isCompact ? 16 : 20,
                    child: _CardFooter(
                      accentColor: accentColor,
                      modeLabel: modeLabel,
                      isBorderline: isBorderline,
                      intensity: intensity,
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
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CardBack extends StatelessWidget {
  final Color accentColor;
  final bool isBorderline;

  const _CardBack({
    required this.accentColor,
    this.isBorderline = false,
  });

  @override
  Widget build(BuildContext context) {
    return TchinCardBackAsset(
      accent: accentColor,
      isBorderline: isBorderline,
      borderRadius: 24,
      markSize: 94,
    );
  }
}

class _CardCorner extends StatelessWidget {
  final Color accentColor;
  final bool isCompact;

  const _CardCorner({required this.accentColor, required this.isCompact});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'T',
          style: GoogleFonts.bebasNeue(
            fontSize: isCompact ? 29 : 34,
            height: 0.9,
            color: accentColor,
          ),
        ),
        Icon(Icons.local_bar, size: isCompact ? 18 : 21, color: accentColor),
      ],
    );
  }
}

class _CardFooter extends StatelessWidget {
  final Color accentColor;
  final String modeLabel;
  final bool isBorderline;
  final BorderlineIntensity intensity;

  const _CardFooter({
    required this.accentColor,
    required this.modeLabel,
    required this.isBorderline,
    required this.intensity,
  });

  @override
  Widget build(BuildContext context) {
    final label = isBorderline
        ? '${modeLabel.toUpperCase()} · ${intensity.displayName.toUpperCase()}'
        : modeLabel.toUpperCase();

    return Row(
      children: [
        Expanded(
          child: Divider(color: accentColor.withOpacity(0.28), thickness: 1.2),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: isBorderline
                  ? const Color(0xFF5F1010).withOpacity(0.72)
                  : Colors.black.withOpacity(0.48),
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: accentColor.withOpacity(0.28), thickness: 1.2),
        ),
      ],
    );
  }
}

class _CardFacePainter extends CustomPainter {
  final Color accentColor;
  final bool isBorderline;
  final BorderlineIntensity intensity;

  const _CardFacePainter({
    required this.accentColor,
    required this.isBorderline,
    required this.intensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final watermark = Paint()
      ..color = (isBorderline ? const Color(0xFF9B1717) : accentColor)
          .withOpacity(isBorderline ? 0.08 : 0.055)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width * 0.23, watermark);
    canvas.drawCircle(center, size.width * 0.33, watermark);

    final rayPaint = Paint()
      ..color = (isBorderline ? const Color(0xFFFF3D3D) : accentColor)
          .withOpacity(isBorderline ? 0.055 : 0.045)
      ..strokeWidth = 1;
    for (var i = 0; i < 18; i++) {
      final angle = (2 * pi / 18) * i;
      final start = Offset(
        center.dx + cos(angle) * size.width * 0.12,
        center.dy + sin(angle) * size.width * 0.12,
      );
      final end = Offset(
        center.dx + cos(angle) * size.width * 0.38,
        center.dy + sin(angle) * size.width * 0.38,
      );
      canvas.drawLine(start, end, rayPaint);
    }

    if (isBorderline) {
      final smokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF7A1010).withOpacity(0.09);

      for (var i = 0; i < 4 + intensity.level; i++) {
        final y = size.height * (0.18 + i * 0.13);
        final path = Path()
          ..moveTo(size.width * 0.08, y)
          ..cubicTo(
            size.width * 0.28,
            y - 28,
            size.width * 0.56,
            y + 32,
            size.width * 0.92,
            y - 6,
          );
        canvas.drawPath(path, smokePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CardFacePainter oldDelegate) {
    return oldDelegate.accentColor != accentColor ||
        oldDelegate.isBorderline != isBorderline ||
        oldDelegate.intensity != intensity;
  }
}
