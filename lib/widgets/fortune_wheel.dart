import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class FortuneWheel extends StatefulWidget {
  final List<String> items;
  final Function(String) onResult;

  const FortuneWheel({
    super.key,
    required this.items,
    required this.onResult,
  });

  @override
  State<FortuneWheel> createState() => _FortuneWheelState();
}

class _FortuneWheelState extends State<FortuneWheel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _angle = 0;
  double _currentSpeed = 0;
  String? _result;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _controller.addListener(_updateRotation);
  }

  void _updateRotation() {
    // Deceleration curve imitation
    var t = _controller.value;
    // Speed decreases over time
    var speedMultiplier = (1 - t); 
    
    setState(() {
      _angle += _currentSpeed * speedMultiplier * 0.5; // Update angle
      
      // Keep angle normalized 0..2pi
      _angle %= 2 * pi;
    });

    if (_controller.isCompleted) {
      _calculateResult();
    }
  }

  void _spin() {
    if (_controller.isAnimating) return;
    
    setState(() {
      _result = null;
      _currentSpeed = 0.5 + Random().nextDouble() * 0.5; // Random initial speed
    });
    
    _controller.forward(from: 0);
  }

  void _calculateResult() {
    // Calculate which segment is at the top (pointer is usually at top (3*pi/2) or right (0))
    // Let's assume pointer is at TOP (-pi/2 or 3*pi/2).
    // Angle increases clockwise.
    
    // Normalize angle to 0-2pi
    double normalizedAngle = _angle % (2 * pi);
    
    // Segment calculation
    int count = widget.items.length;
    double segmentAngle = (2 * pi) / count;
    
    // The "Top" position corresponds to -pi/2 or 270 degrees.
    // We need to find which segment intersects the top pointer.
    // Alternatively, we can just rotate the canvas so 0 is top.
    // Let's assume standard unit circle: 0 is Right, pi/2 is Bottom, pi is Left, 3pi/2 is Top.
    
    // Pointer is at Top (3pi/2 or 270deg).
    // Current rotation is _angle.
    // Effectivle angle at top = (3pi/2 - _angle) normalized.
    
    double pointerAngle = 3 * pi / 2;
    double effectiveAngle = (pointerAngle - _angle) % (2 * pi);
    if (effectiveAngle < 0) effectiveAngle += 2 * pi;
    
    int index = (effectiveAngle / segmentAngle).floor();
    
    // Safety check
    index = index.clamp(0, count - 1);
    
    String winner = widget.items[index];
    widget.onResult(winner);
    
    setState(() {
      _result = winner;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // The Wheel
            Transform.rotate(
              angle: _angle,
              child: CustomPaint(
                size: const Size(300, 300),
                painter: _WheelPainter(
                  items: widget.items,
                  colors: [
                    Colors.redAccent,
                    Colors.amber,
                    Colors.blueAccent,
                    Colors.greenAccent,
                    Colors.purpleAccent,
                    Colors.orangeAccent,
                  ]
                ),
              ),
            ),
            
            // Pointer (Top)
            Positioned(
              top: 0,
              child: Container(
                width: 20,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                  ),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)]
                ),
                child: const Icon(Icons.arrow_downward, size: 16, color: Colors.black),
              ),
            ),
            
            // Center Button
            GestureDetector(
              onTap: _spin,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 4),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10)
                  ]
                ),
                child: Center(
                  child: Icon(
                    Icons.touch_app_rounded, 
                    size: 28, 
                    color: AppTheme.primary
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        if (_result != null)
           Container(
             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
             decoration: BoxDecoration(
               color: AppTheme.secondary,
               borderRadius: BorderRadius.circular(20),
             ),
             child: Text(
               _result!,
               style: const TextStyle(
                 fontSize: 24, 
                 fontWeight: FontWeight.bold,
                 color: Colors.black
               ),
             ),
           )
      ],
    );
  }
}

class _WheelPainter extends CustomPainter {
  final List<String> items;
  final List<Color> colors;

  _WheelPainter({required this.items, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    
    final count = items.length;
    final sweepAngle = 2 * pi / count;
    
    // Draw Segments
    for (int i = 0; i < count; i++) {
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;
        
      canvas.drawArc(
        rect, 
        i * sweepAngle, 
        sweepAngle, 
        true, 
        paint
      );
      
      // Draw Border
      final borderPaint = Paint()
        ..color = Colors.white.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
        
      canvas.drawArc(
        rect, 
        i * sweepAngle, 
        sweepAngle, 
        true, 
        borderPaint
      );
      
      // Draw Text
      _drawText(canvas, size, items[i], i * sweepAngle, sweepAngle, radius);
    }
  }
  
  void _drawText(Canvas canvas, Size size, String text, double startAngle, double sweepAngle, double radius) {
    final center = Offset(size.width / 2, size.height / 2);
    
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(startAngle + sweepAngle / 2);
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white, 
          fontSize: 14, 
          fontFamily: GoogleFonts.inter().fontFamily,
          fontFamilyFallback: [GoogleFonts.notoColorEmoji().fontFamily!],
          fontWeight: FontWeight.bold,
          shadows: const [Shadow(blurRadius: 2, color: Colors.black)]
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    // Position text at ~70% of radius
    canvas.translate(radius * 0.6, -textPainter.height / 2);
    
    textPainter.paint(canvas, Offset.zero);
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
