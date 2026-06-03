import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

/// Bouton avec gradient ambre→orange, glow et micro-animation au press.
class GradientButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLarge;
  final bool isSmall;

  const GradientButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.isLarge = false,
    this.isSmall = false,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null;
    final double vPad = widget.isLarge ? 20 : (widget.isSmall ? 11 : 15);
    final double hPad = widget.isSmall ? 18 : 26;
    final double fontSize = widget.isLarge ? 18 : (widget.isSmall ? 14 : 16);
    final double iconSize = widget.isSmall ? 18 : 20;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.isSmall ? null : double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: isDisabled
                ? null
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF5A623),
                      Color(0xFFFF6B35),
                    ],
                  ),
            color: isDisabled ? const Color(0x1AFFFFFF) : null,
            boxShadow: isDisabled
                ? null
                : [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.45),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: AppTheme.accent.withOpacity(0.20),
                      blurRadius: 40,
                      offset: const Offset(0, 12),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: vPad, horizontal: hPad),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize:
                    widget.isSmall ? MainAxisSize.min : MainAxisSize.max,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      color: isDisabled
                          ? AppTheme.textMuted
                          : Colors.white.withOpacity(0.95),
                      size: iconSize,
                    ),
                    const SizedBox(width: 9),
                  ],
                  Flexible(
                    child: Text(
                      widget.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDisabled ? AppTheme.textMuted : Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate(target: _pressed ? 1 : 0).shimmer(
              duration: 300.ms,
              color: Colors.white.withOpacity(0.15),
            ),
      ),
    );
  }
}
