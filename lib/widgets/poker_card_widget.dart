import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/card_model.dart';

class PokerCardWidget extends StatelessWidget {
  final PlayingCard card;
  final bool isFaceUp;
  final double width;
  final double height;
  final int? cardNumber;
  final bool isCurrent;
  final bool isSipCard;
  final bool showPositionNumber;

  const PokerCardWidget({
    super.key,
    required this.card,
    this.isFaceUp = false,
    this.width = 100,
    this.height = 150,
    this.cardNumber,
    this.isCurrent = false,
    this.isSipCard = false,
    this.showPositionNumber = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      transitionBuilder: (child, animation) {
        final rotate = Tween(begin: math.pi, end: 0.0).animate(animation);
        return AnimatedBuilder(
          animation: rotate,
          child: child,
          builder: (context, child) {
            final isBack = rotate.value > math.pi / 2;
            final matrix = Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(rotate.value);
            return Transform(
              transform: matrix,
              alignment: Alignment.center,
              child: isBack ? SizedBox(width: width, height: height) : child,
            );
          },
        );
      },
      child: isFaceUp ? _buildFront() : _buildBack(),
    );
  }

  Widget _buildFront() {
    final suitColor = (card.suit == Suit.hearts || card.suit == Suit.diamonds)
        ? Colors.redAccent
        : const Color(0xFF1A1512);
    final accentColor = isSipCard ? Colors.amber : suitColor;

    return Container(
      key: const ValueKey('front'),
      width: width,
      height: height,
      padding: EdgeInsets.all(width * 0.09),
      decoration: _cardDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFAED), Color(0xFFF1D9A7)],
        ),
        borderColor: isCurrent
            ? Colors.blueAccent
            : isSipCard
                ? Colors.amber
                : Colors.black12,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(width * 0.1),
        child: Stack(
          children: [
            Center(
              child: Opacity(
                opacity: 0.06,
                child: Text('TCHIN',
                    style: GoogleFonts.bebasNeue(
                      fontSize: width * 0.31,
                      color: accentColor,
                    )),
              ),
            ),
            if (cardNumber != null && showPositionNumber)
              Positioned(
                top: 0,
                right: 0,
                child: _CardNumberPill(
                  number: cardNumber!,
                  color: isSipCard ? Colors.amber : Colors.blueAccent,
                  filled: false,
                ),
              ),
            Positioned(
              top: 0,
              left: 0,
              child: _CardCorner(
                rank: card.rankText,
                suit: card.suitSvg,
                color: suitColor,
                width: width,
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card.rankText,
                    style: GoogleFonts.bebasNeue(
                      fontSize: width * (isSipCard ? 0.2 : 0.28),
                      color: suitColor,
                      height: 0.8,
                    ),
                  ),
                  Text(
                    card.suitSvg,
                    style: TextStyle(
                      fontSize: width * (isSipCard ? 0.28 : 0.38),
                      color: suitColor,
                      height: 0.9,
                    ),
                  ),
                  if (isSipCard) ...[
                    SizedBox(height: width * 0.04),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.08,
                        vertical: width * 0.025,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(999),
                        border:
                            Border.all(color: Colors.amber.withOpacity(0.42)),
                      ),
                      child: Text(
                        'GORGEE',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF5B3204),
                          fontSize: width * 0.08,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Transform.rotate(
                angle: math.pi,
                child: _CardCorner(
                  rank: card.rankText,
                  suit: card.suitSvg,
                  color: suitColor,
                  width: width,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      key: const ValueKey('back'),
      width: width,
      height: height,
      decoration: _cardDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF28110C), Color(0xFF713016), Color(0xFF170A07)],
        ),
        borderColor:
            isCurrent ? Colors.blueAccent : Colors.amber.withOpacity(0.34),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(width * 0.14),
        child: CustomPaint(
          painter: _RoadCardBackPainter(color: Colors.amber),
          child: Padding(
            padding: EdgeInsets.all(width * 0.1),
            child: Stack(
              children: [
                if (cardNumber != null)
                  Align(
                    alignment: Alignment.topLeft,
                    child: _CardNumberPill(
                      number: cardNumber!,
                      color: Colors.amber,
                      filled: true,
                    ),
                  ),
                Center(
                  child: Container(
                    width: width * 0.48,
                    height: width * 0.48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.18),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.42),
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      cardNumber == null
                          ? 'T'
                          : cardNumber!.toString().padLeft(2, '0'),
                      style: GoogleFonts.bebasNeue(
                        color: Colors.amber.withOpacity(0.9),
                        fontSize:
                            cardNumber == null ? width * 0.32 : width * 0.26,
                        height: 0.9,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration({
    required Gradient gradient,
    required Color borderColor,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(width * 0.14),
      gradient: gradient,
      border: Border.all(color: borderColor, width: isCurrent ? 2.2 : 1.3),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: isCurrent ? 26 : 16,
          offset: const Offset(0, 10),
        ),
        if (isCurrent)
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.38),
            blurRadius: 24,
          ),
      ],
    );
  }
}

class _CardCorner extends StatelessWidget {
  final String rank;
  final String suit;
  final Color color;
  final double width;

  const _CardCorner({
    required this.rank,
    required this.suit,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          rank,
          style: GoogleFonts.bebasNeue(
            fontSize: width * 0.21,
            height: 0.9,
            color: color,
          ),
        ),
        Text(suit, style: TextStyle(fontSize: width * 0.13, color: color)),
      ],
    );
  }
}

class _CardNumberPill extends StatelessWidget {
  final int number;
  final Color color;
  final bool filled;

  const _CardNumberPill({
    required this.number,
    required this.color,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color:
            filled ? color.withOpacity(0.16) : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        number.toString().padLeft(2, '0'),
        style: GoogleFonts.inter(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _RoadCardBackPainter extends CustomPainter {
  final Color color;

  const _RoadCardBackPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final stripe = Paint()
      ..color = Colors.white.withOpacity(0.045)
      ..strokeWidth = 5;
    for (double x = -size.height; x < size.width; x += 18) {
      canvas.drawLine(
          Offset(x, 0), Offset(x + size.height, size.height), stripe);
    }

    final border = Paint()
      ..color = color.withOpacity(0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final rect = Rect.fromLTWH(9, 9, size.width - 18, size.height - 18);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(size.width * 0.08)),
      border,
    );
  }

  @override
  bool shouldRepaint(covariant _RoadCardBackPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
