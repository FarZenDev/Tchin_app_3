import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

/// Fond animé premium : particules dorées + orbes flottants.
class AnimatedBackground extends StatelessWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final count = size.shortestSide < 380 ? 7 : 10;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return Stack(
      children: [
        // Fond dégradé profond
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.3),
              radius: 1.4,
              colors: [Color(0xFF1C2340), AppTheme.background],
            ),
          ),
        ),

        // Orbe ambre subtil en haut
        Positioned(
          top: -size.height * 0.15,
          left: size.width * 0.1,
          right: size.width * 0.1,
          height: size.height * 0.45,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.07),
                  blurRadius: 100,
                  spreadRadius: 60,
                ),
              ],
            ),
          ),
        ),

        // Particules flottantes
        RepaintBoundary(
          child: IgnorePointer(
            child: Stack(
              children: List.generate(
                count,
                (i) => _buildParticle(context, i, disableAnimations),
              ),
            ),
          ),
        ),

        child,
      ],
    );
  }

  Widget _buildParticle(BuildContext context, int index, bool disable) {
    final rng = Random(index * 7 + 3);
    final screen = MediaQuery.of(context).size;
    final sz = rng.nextDouble() * 28 + 6;
    final left = rng.nextDouble() * screen.width;
    final dur = rng.nextInt(8) + 10;
    final delay = rng.nextDouble() * 7;

    // Alterner entre petites boules et étoiles
    final isGold = index % 3 == 0;

    final particle = Container(
      width: sz,
      height: sz,
      decoration: BoxDecoration(
        color: isGold
            ? AppTheme.primary.withOpacity(0.08 + rng.nextDouble() * 0.1)
            : Colors.white.withOpacity(0.03 + rng.nextDouble() * 0.06),
        shape: BoxShape.circle,
        boxShadow: isGold
            ? [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.2),
                  blurRadius: 8,
                )
              ]
            : null,
      ),
    );

    if (disable) {
      return Positioned(
        bottom: rng.nextDouble() * screen.height,
        left: left,
        child: particle,
      );
    }

    return Positioned(
      bottom: -60,
      left: left,
      child: particle
          .animate(onPlay: (c) => c.repeat())
          .moveY(
            begin: 0,
            end: -screen.height - 120,
            duration: dur.seconds,
            delay: delay.seconds,
            curve: Curves.linear,
          )
          .fadeIn(duration: 1500.ms)
          .fadeOut(delay: (dur - 2).seconds),
    );
  }
}
