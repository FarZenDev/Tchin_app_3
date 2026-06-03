import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'animated_background.dart';

class GameLayout extends StatelessWidget {
  final Widget child;
  final bool showBubbles;
  final bool enableBackground;
  final double? maxFrameWidth;
  final double? outerPadding;
  final double? framePadding;
  final Widget? customBackground;

  const GameLayout({
    super.key,
    required this.child,
    this.showBubbles = true,
    this.enableBackground = true,
    this.maxFrameWidth,
    this.outerPadding,
    this.framePadding,
    this.customBackground,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortestSide = size.shortestSide;
    final resolvedMaxFrameWidth =
        maxFrameWidth ?? (shortestSide < 380 ? shortestSide : 440.0);
    final resolvedOuterPadding =
        outerPadding ?? (shortestSide < 380 ? 8.0 : 14.0);
    final resolvedFramePadding =
        framePadding ?? (shortestSide < 380 ? 16.0 : 22.0);
    final frameRadius = shortestSide < 380 ? 24.0 : 28.0;

    // Performance optimization: Reduce default blur (28 -> 12) and disable it if system animations are disabled
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final blur = disableAnimations ? 0.0 : (shortestSide < 380 ? 8.0 : 12.0);

    return Container(
      decoration: (enableBackground && customBackground == null) 
          ? AppTheme.appBackgroundDecoration 
          : null,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // Custom or ambient background
            if (customBackground != null)
              Positioned.fill(child: customBackground!)
            else ...[
              if (enableBackground)
                Positioned(
                  top: size.height * 0.1,
                  left: size.width * 0.2,
                  right: size.width * 0.2,
                  height: size.height * 0.4,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.12),
                          blurRadius: 120,
                          spreadRadius: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              if (showBubbles && enableBackground)
                Positioned.fill(
                  child: AnimatedBackground(child: const SizedBox.shrink()),
                ),
            ],

            SafeArea(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: resolvedMaxFrameWidth),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Padding(
                    padding: EdgeInsets.all(resolvedOuterPadding),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        // Double couche : blanc 6% + border lumineuse
                        color: const Color(0x0FFFFFFF),
                        borderRadius: BorderRadius.circular(frameRadius),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 80,
                            offset: const Offset(0, 24),
                          ),
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.06),
                            blurRadius: 40,
                            offset: const Offset(0, -8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(frameRadius),
                        child: blur > 0
                            ? BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                                child: Padding(
                                  padding: EdgeInsets.all(resolvedFramePadding),
                                  child: child,
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.all(resolvedFramePadding),
                                child: child,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
