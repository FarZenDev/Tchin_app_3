import 'dart:math';
import 'package:flutter/material.dart';

class LiquidTransition extends StatefulWidget {
  final bool isFilling;
  final Color color;
  final Duration duration;
  final VoidCallback? onCompleted;

  const LiquidTransition({
    super.key,
    required this.isFilling, // true = fill up, false = drain down
    required this.color,
    this.duration = const Duration(milliseconds: 2000), // Slower for realism
    this.onCompleted,
  });

  @override
  State<LiquidTransition> createState() => _LiquidTransitionState();
}

class _LiquidTransitionState extends State<LiquidTransition> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  
  late AnimationController _bubbleController; // Continuous loop for bubbles
  final List<_Bubble> _bubbles = [];

  @override
  void initState() {
    super.initState();
    
    // 1. Fill Animation
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCompleted?.call();
      }
    });
    _controller.forward();

    // 2. Bubble Animation (Loop)
    _bubbleController = AnimationController(
        vsync: this, 
        duration: const Duration(seconds: 10)
    )..repeat(); // Runs 0 -> 1 forever

    // Generate random bubbles
    final random = Random();
    for(int i=0; i<30; i++) {
        _bubbles.add(_Bubble(
            x: random.nextDouble(),
            y: random.nextDouble(),
            size: random.nextDouble() * 5 + 2,
            speed: random.nextDouble() * 2 + 1
        ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_progressAnimation, _bubbleController]),
      builder: (context, child) {
        return CustomPaint(
          painter: _BeerPainter(
            progress: _progressAnimation.value,
            bubbleProgress: _bubbleController.value,
            color: widget.color,
            isFilling: widget.isFilling,
            bubbles: _bubbles,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Bubble {
    double x; // 0..1
    double y; // 0..1 relative to liquid height? No, absolute.
    double size;
    double speed;
    _Bubble({required this.x, required this.y, required this.size, required this.speed});
}

class _BeerPainter extends CustomPainter {
  final double progress;
  final double bubbleProgress;
  final Color color;
  final bool isFilling;
  final List<_Bubble> bubbles;

  _BeerPainter({
    required this.progress,
    required this.bubbleProgress,
    required this.color,
    required this.isFilling,
    required this.bubbles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Liquid Body
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    // Wave parameters
    // Keep wave moving slightly even when full?
    // Use bubbleProgress for phase shift to keep wave alive
    double waveHeight = 15.0 * (1 - progress); 
    if (progress >= 0.99) waveHeight = 2.0; // Minimal wave when full

    double phase = (progress * 4 * pi) + (bubbleProgress * 2 * pi);
    
    double currentLevelY;
    if (isFilling) {
      currentLevelY = size.height * (1 - progress);
    } else {
      currentLevelY = size.height * progress;
    }
    
    final path = Path();
    path.moveTo(0, size.height); // Bottom Left
    path.lineTo(0, currentLevelY); // Liquid Top Left

    // Draw Top Wave
    for (double x = 0; x <= size.width; x+=5) {
      double y = currentLevelY + sin((x / size.width * 2 * pi) + phase) * waveHeight;
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height); // Bottom Right
    path.close();
    canvas.drawPath(path, paint);

    // 2. Bubbles (Rising)
    // Only draw bubbles inside the liquid area
    final bubblePaint = Paint()..color = Colors.white.withOpacity(0.3);
    for (var bubble in bubbles) {
        // Continuous movement using bubbleProgress
        // y simulates position 0..1. 
        // We want it to move UP (decrement y).
        
        double animatedY = (bubble.y - bubbleProgress * bubble.speed * 4) % 1.0;
        if (animatedY < 0) animatedY += 1.0;
        
        double actualY = size.height * animatedY;
        double actualX = size.width * bubble.x;
        
        // Check if below surface
        if (actualY > currentLevelY) {
            canvas.drawCircle(Offset(actualX, actualY), bubble.size, bubblePaint);
        }
    }

    // 3. Foam Head (Mousse)
    if (currentLevelY < size.height) { // If there is liquid
        double foamThickness = 30.0;
        // Foam grows slightly as we pour, then stabilizes
        if (isFilling && progress < 0.2) foamThickness *= (progress * 5);
        
        final foamPaint = Paint()
          ..color = const Color(0xFFFFF8E1) // Creamy white
          ..style = PaintingStyle.fill;
          
        final foamPath = Path();
        
        // Top of foam (bubbly/irregular)
        foamPath.moveTo(0, currentLevelY);
        for (double x = 0; x <= size.width; x+=5) {
           // Offset the sine wave for the top of the foam to look organic
           double y = currentLevelY + sin((x / size.width * 3 * pi) + phase + 1) * waveHeight - foamThickness;
           // Add noise/bubbles to top edge? simplified for now
           foamPath.lineTo(x, y);
        }
        
        // Bottom of foam (matches liquid top)
        for (double x = size.width; x >= 0; x-=5) {
            double y = currentLevelY + sin((x / size.width * 2 * pi) + phase) * waveHeight;
            foamPath.lineTo(x, y);
        }
        
        foamPath.close();
        
        // Shadow under foam for depth
        // canvas.drawShadow(foamPath, Colors.black26, 4, true); 
        canvas.drawPath(foamPath, foamPaint);
    }
  }

  @override
  bool shouldRepaint(_BeerPainter oldDelegate) {
     return oldDelegate.progress != progress || 
            oldDelegate.bubbleProgress != bubbleProgress ||
            oldDelegate.color != color;
  }
}
