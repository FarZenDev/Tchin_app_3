import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TchinCardBackAsset extends StatelessWidget {
  final Color accent;
  final bool isBorderline;

  const TchinCardBackAsset({
    super.key,
    required this.accent,
    this.isBorderline = false,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.68,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
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
              size: 56,
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
