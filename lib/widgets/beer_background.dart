import 'dart:math' as math;
import 'package:flutter/material.dart';

class BeerBackground extends StatefulWidget {
  final Widget? child;
  const BeerBackground({super.key, this.child});

  @override
  State<BeerBackground> createState() => _BeerBackgroundState();
}

class _BeerBackgroundState extends State<BeerBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Bubble> _bubbles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Generate initial bubbles scattered across the height
    for (int i = 0; i < 46; i++) {
      _bubbles.add(_createBubble(isInitial: true));
    }
  }

  _Bubble _createBubble({bool isInitial = false}) {
    final sizeFactor = _random.nextDouble();
    return _Bubble(
      xPct: _random.nextDouble(),
      yPct: isInitial
          ? _random.nextDouble() * 0.95 + 0.05
          : 1.05, // start from bottom
      radius: sizeFactor * 5.5 + 1.8,
      speed: sizeFactor * 0.14 + 0.07,
      swingWidth: _random.nextDouble() * 0.04 + 0.012,
      swingSpeed: _random.nextDouble() * 2.5 + 1.0,
      opacity: _random.nextDouble() * 0.35 + 0.22,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Update positions of the bubbles
        for (int i = 0; i < _bubbles.length; i++) {
          final bubble = _bubbles[i];
          bubble.yPct -= bubble.speed * 0.015; // speed of rising

          // Recycle bubble when it hits the foam zone
          if (bubble.yPct < 0.08) {
            _bubbles[i] = _createBubble(isInitial: false);
          }
        }

        return CustomPaint(
          painter: _BeerPainter(
            bubbles: _bubbles,
            animationValue: _controller.value,
          ),
          child: widget.child ?? const SizedBox.expand(),
        );
      },
    );
  }
}

class _Bubble {
  double xPct;
  double yPct;
  final double radius;
  final double speed;
  final double swingWidth;
  final double swingSpeed;
  final double opacity;

  _Bubble({
    required this.xPct,
    required this.yPct,
    required this.radius,
    required this.speed,
    required this.swingWidth,
    required this.swingSpeed,
    required this.opacity,
  });
}

class _BeerPainter extends CustomPainter {
  final List<_Bubble> bubbles;
  final double animationValue;

  _BeerPainter({required this.bubbles, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. Draw rich beer liquid gradient
    final liquidGradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: const [
        Color(0xFF2E1200), // dark amber bottom
        Color(0xFF6F3200), // medium amber
        Color(0xFFC56D00), // warm gold
        Color(0xFFE69A19), // beer gold
        Color(0xFFFFD66B), // light beer head
      ],
      stops: const [0.0, 0.22, 0.55, 0.85, 1.0],
    );
    final liquidPaint = Paint()..shader = liquidGradient.createShader(rect);
    canvas.drawRect(rect, liquidPaint);

    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.45, -0.25),
          radius: 1.1,
          colors: [
            Colors.white.withOpacity(0.18),
            Colors.white.withOpacity(0.02),
            Colors.black.withOpacity(0.28),
          ],
          stops: const [0.0, 0.48, 1.0],
        ).createShader(rect),
    );

    // 2. Draw rising carbonation bubbles
    for (final bubble in bubbles) {
      // Horizontal swing using sine wave
      final swing = math.sin(bubble.yPct * math.pi * 2 * bubble.swingSpeed) *
          bubble.swingWidth;
      final x = (bubble.xPct + swing).clamp(0.0, 1.0) * size.width;
      final y = bubble.yPct * size.height;

      // Inner fill
      final bubblePaint = Paint()
        ..color = Colors.white.withOpacity(bubble.opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), bubble.radius, bubblePaint);

      // Shiny border
      final borderPaint = Paint()
        ..color = Colors.white.withOpacity(bubble.opacity * 1.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      canvas.drawCircle(Offset(x, y), bubble.radius, borderPaint);
    }

    // 3. Draw frothy beer head (foam) at the top
    final foamPaint = Paint()..color = const Color(0xFFFFFDF7);
    final foamPath = Path();

    final foamHeight = size.height * 0.17;
    foamPath.moveTo(0, 0);
    foamPath.lineTo(0, foamHeight);

    final numWaves = 6;
    final waveWidth = size.width / numWaves;

    for (int i = 0; i < numWaves; i++) {
      final startX = i * waveWidth;
      final endX = (i + 1) * waveWidth;
      final midX = startX + waveWidth / 2;
      // Animate wave shape dynamically with a rolling motion
      final waveDepth =
          foamHeight + (math.sin(i * 1.5 + animationValue * math.pi * 2) * 7);

      foamPath.quadraticBezierTo(
        midX,
        waveDepth + 10, // wave peak depth
        endX,
        foamHeight,
      );
    }

    foamPath.lineTo(size.width, 0);
    foamPath.close();

    // Draw shadow under foam for depth
    canvas.drawPath(
      foamPath,
      Paint()
        ..color = const Color(0xFF805A1A).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Render outer foam layer
    canvas.drawPath(foamPath, foamPaint);

    // Render inner brighter foam layer
    final innerFoamPaint = Paint()..color = Colors.white;
    final innerFoamPath = Path();
    final innerFoamHeight = foamHeight - 18;

    innerFoamPath.moveTo(0, 0);
    innerFoamPath.lineTo(0, innerFoamHeight);

    for (int i = 0; i < numWaves; i++) {
      final startX = i * waveWidth;
      final endX = (i + 1) * waveWidth;
      final midX = startX + waveWidth / 2;
      // Parallax rolling effect for the inner layer
      final waveDepth = innerFoamHeight +
          (math.cos(i * 1.5 - animationValue * math.pi * 2) * 5);

      innerFoamPath.quadraticBezierTo(
        midX,
        waveDepth + 7,
        endX,
        innerFoamHeight,
      );
    }
    innerFoamPath.lineTo(size.width, 0);
    innerFoamPath.close();
    canvas.drawPath(innerFoamPath, innerFoamPaint);

    final foamBubblePaint = Paint()..color = Colors.white.withOpacity(0.7);
    for (var i = 0; i < 22; i++) {
      final x = ((i * 47.0) + animationValue * 26) % size.width;
      final y = size.height * (0.035 + (i % 5) * 0.018);
      canvas.drawCircle(Offset(x, y), 4 + (i % 4) * 2.0, foamBubblePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BeerPainter oldDelegate) => true;
}
