import 'dart:math';

import 'package:flutter/material.dart';

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
                    modeLabel: modeLabel,
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

class _CardVisual {
  final String modeName;
  final Color accent;
  final IconData icon;
  final TchinCardDesignVariant variant;

  const _CardVisual({
    required this.modeName,
    required this.accent,
    required this.icon,
    required this.variant,
  });
}

_CardVisual _visualForMode(
  String modeLabel,
  Color accentColor,
  bool isBorderline,
) {
  final label = modeLabel.toLowerCase();
  if (isBorderline || label.contains('borderline')) {
    return _CardVisual(
      modeName: 'Borderline',
      accent: accentColor,
      icon: Icons.local_fire_department_rounded,
      variant: TchinCardDesignVariant.club,
    );
  }
  if (label.contains('duo')) {
    return _CardVisual(
      modeName: 'Duo',
      accent: accentColor,
      icon: Icons.groups_rounded,
      variant: TchinCardDesignVariant.comptoir,
    );
  }
  if (label.contains('bar')) {
    return _CardVisual(
      modeName: 'Bar',
      accent: accentColor,
      icon: Icons.local_bar_rounded,
      variant: TchinCardDesignVariant.club,
    );
  }
  if (label.contains('chill')) {
    return _CardVisual(
      modeName: 'Chill',
      accent: accentColor,
      icon: Icons.spa_rounded,
      variant: TchinCardDesignVariant.comptoir,
    );
  }
  if (label.contains('hot')) {
    return _CardVisual(
      modeName: 'Hot',
      accent: accentColor,
      icon: Icons.local_fire_department_rounded,
      variant: TchinCardDesignVariant.ticket,
    );
  }
  if (label.contains('express')) {
    return _CardVisual(
      modeName: 'Express',
      accent: accentColor,
      icon: Icons.bolt_rounded,
      variant: TchinCardDesignVariant.comptoir,
    );
  }
  return _CardVisual(
    modeName: 'Classique',
    accent: accentColor,
    icon: Icons.sports_bar_rounded,
    variant: TchinCardDesignVariant.comptoir,
  );
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
              modeLabel: modeLabel,
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
              modeLabel: modeLabel,
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
  final String modeLabel;
  final bool isBorderline;
  final Widget child;

  const _CardDealTransition({
    required this.animation,
    required this.accentColor,
    required this.modeLabel,
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
                            modeLabel: modeLabel,
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
        final visual = _visualForMode(modeLabel, accentColor, isBorderline);
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
          child: TchinModeCardSurface(
            modeName: visual.modeName,
            accent: visual.accent,
            icon: visual.icon,
            variant: visual.variant,
            isBorderline: isBorderline,
            borderRadius: radius,
            topPadding: topPadding,
            horizontalPadding: horizontalPadding,
            bottomPadding: bottomPadding,
            child: child,
          ),
        );
      },
    );
  }
}

class _CardBack extends StatelessWidget {
  final Color accentColor;
  final String modeLabel;
  final bool isBorderline;

  const _CardBack({
    required this.accentColor,
    required this.modeLabel,
    this.isBorderline = false,
  });

  @override
  Widget build(BuildContext context) {
    final visual = _visualForMode(modeLabel, accentColor, isBorderline);
    return TchinModeCardSurface(
      modeName: visual.modeName,
      accent: visual.accent,
      icon: visual.icon,
      variant: visual.variant,
      isBack: true,
      isBorderline: isBorderline,
      borderRadius: 24,
    );
  }
}
