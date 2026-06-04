import 'package:flutter/material.dart';

class DevilLaughAnimation extends StatefulWidget {
  final double size;
  final Duration frameDuration;
  final bool repeat;

  const DevilLaughAnimation({
    super.key,
    this.size = 128,
    this.frameDuration = const Duration(milliseconds: 90),
    this.repeat = false,
  });

  static const List<String> frames = [
    'assets/devil_laugh_frames/devil_laugh_0.png',
    'assets/devil_laugh_frames/devil_laugh_1.png',
    'assets/devil_laugh_frames/devil_laugh_2.png',
    'assets/devil_laugh_frames/devil_laugh_3.png',
    'assets/devil_laugh_frames/devil_laugh_4.png',
    'assets/devil_laugh_frames/devil_laugh_5.png',
  ];

  @override
  State<DevilLaughAnimation> createState() => _DevilLaughAnimationState();
}

class _DevilLaughAnimationState extends State<DevilLaughAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.frameDuration.inMilliseconds *
            (DevilLaughAnimation.frames.length - 1),
      ),
    );

    if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final frame in DevilLaughAnimation.frames) {
      precacheImage(AssetImage(frame), context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final framePosition =
                _controller.value * (DevilLaughAnimation.frames.length - 1);
            final currentFrame = framePosition
                .floor()
                .clamp(0, DevilLaughAnimation.frames.length - 1)
                .toInt();
            final nextFrame = (currentFrame + 1)
                .clamp(
                  0,
                  DevilLaughAnimation.frames.length - 1,
                )
                .toInt();
            final blend = framePosition - currentFrame;

            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  DevilLaughAnimation.frames[currentFrame],
                  width: widget.size,
                  height: widget.size,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.medium,
                  gaplessPlayback: true,
                ),
                if (nextFrame != currentFrame)
                  Opacity(
                    opacity: blend.clamp(0.0, 1.0),
                    child: Image.asset(
                      DevilLaughAnimation.frames[nextFrame],
                      width: widget.size,
                      height: widget.size,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,
                      gaplessPlayback: true,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
