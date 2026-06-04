import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class QuestionPlayingCard extends StatelessWidget {
  final Widget child;
  final Color accentColor;
  final String modeLabel;
  final bool isSpecial;
  final Object? animationKey;

  const QuestionPlayingCard({
    super.key,
    required this.child,
    required this.accentColor,
    required this.modeLabel,
    this.isSpecial = false,
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
                duration: const Duration(milliseconds: 620),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return _CardDealTransition(
                    animation: animation,
                    accentColor: accentColor,
                    child: child,
                  );
                },
                child: _CardDeck(
                  key: ValueKey(animationKey ?? modeLabel),
                  accentColor: accentColor,
                  modeLabel: modeLabel,
                  isSpecial: isSpecial,
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
  final bool isCompact;

  const _CardDeck({
    super.key,
    required this.child,
    required this.accentColor,
    required this.modeLabel,
    required this.isSpecial,
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
              accentColor: accentColor.withOpacity(0.82),
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
              accentColor: AppTheme.secondary.withOpacity(0.72),
            ),
          ),
        ),
        Positioned.fill(
          child: _CardFront(
            accentColor: accentColor,
            modeLabel: modeLabel,
            isSpecial: isSpecial,
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
  final Widget child;

  const _CardDealTransition({
    required this.animation,
    required this.accentColor,
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
                    child:
                        showBack ? _CardBack(accentColor: accentColor) : child,
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

  const _CardFront({
    required this.child,
    required this.accentColor,
    required this.modeLabel,
    required this.isSpecial,
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
                color: accentColor.withOpacity(isSpecial ? 0.45 : 0.22),
                blurRadius: isSpecial ? 72 : 48,
                spreadRadius: isSpecial ? 4 : 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
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
                        painter: _CardFacePainter(accentColor: accentColor),
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
                            color: accentColor.withOpacity(0.34),
                            width: 1.6,
                          ),
                        ),
                      ),
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

  const _CardBack({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF30160F), Color(0xFF6C2E12), Color(0xFF170B08)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.14), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: CustomPaint(
          painter: _CardBackPainter(accentColor: accentColor),
          child: Center(
            child: Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.16),
                border: Border.all(
                  color: accentColor.withOpacity(0.62),
                  width: 1.4,
                ),
              ),
              child: Icon(
                Icons.sports_bar,
                color: accentColor.withOpacity(0.86),
                size: 40,
              ),
            ),
          ),
        ),
      ),
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

  const _CardFooter({required this.accentColor, required this.modeLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: accentColor.withOpacity(0.28), thickness: 1.2),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            modeLabel.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: Colors.black.withOpacity(0.48),
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

  const _CardFacePainter({required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final watermark = Paint()
      ..color = accentColor.withOpacity(0.055)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width * 0.23, watermark);
    canvas.drawCircle(center, size.width * 0.33, watermark);

    final rayPaint = Paint()
      ..color = accentColor.withOpacity(0.045)
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
  }

  @override
  bool shouldRepaint(covariant _CardFacePainter oldDelegate) {
    return oldDelegate.accentColor != accentColor;
  }
}

class _CardBackPainter extends CustomPainter {
  final Color accentColor;

  const _CardBackPainter({required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final stripePaint = Paint()
      ..color = Colors.white.withOpacity(0.045)
      ..strokeWidth = 7;
    for (double x = -size.height; x < size.width; x += 26) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        stripePaint,
      );
    }

    final borderPaint = Paint()
      ..color = accentColor.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final rect = Rect.fromLTWH(16, 16, size.width - 32, size.height - 32);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(16)),
      borderPaint,
    );

    final innerPaint = Paint()
      ..color = Colors.black.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final innerRect = Rect.fromLTWH(28, 28, size.width - 56, size.height - 56);
    canvas.drawRRect(
      RRect.fromRectAndRadius(innerRect, const Radius.circular(12)),
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CardBackPainter oldDelegate) {
    return oldDelegate.accentColor != accentColor;
  }
}
