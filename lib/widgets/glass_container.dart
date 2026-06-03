import 'dart:ui';
import 'package:flutter/material.dart';

/// Conteneur glassmorphism amélioré avec glow coloré optionnel.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;
  final Color? color;
  final Color? glowColor;
  final double? width;
  final double? height;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 18.0,
    this.opacity = 0.08,
    this.borderRadius,
    this.padding,
    this.margin,
    this.border,
    this.color,
    this.glowColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(24);
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final resolvedBlur = disableAnimations ? 0.0 : blur;

    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.white.withOpacity(opacity),
        borderRadius: br,
        border: border ??
            Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.2,
            ),
      ),
      child: child,
    );

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: br,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
          if (glowColor != null)
            BoxShadow(
              color: glowColor!.withOpacity(0.18),
              blurRadius: 30,
              spreadRadius: 2,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: br,
        child: resolvedBlur > 0
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: resolvedBlur, sigmaY: resolvedBlur),
                child: content,
              )
            : content,
      ),
    );
  }
}
