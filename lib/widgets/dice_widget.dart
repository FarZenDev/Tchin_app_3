
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DiceWidget extends StatefulWidget {
  final VoidCallback? onRollComplete;

  const DiceWidget({super.key, this.onRollComplete});

  @override
  State<DiceWidget> createState() => DiceWidgetState();
}

class DiceWidgetState extends State<DiceWidget> with SingleTickerProviderStateMixin {
  int _currentValue = 1;
  bool _isRolling = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Longer duration for full spin
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<int> roll() async {
    if (_isRolling) return _currentValue;

    setState(() {
      _isRolling = true;
    });

    _controller.forward(from: 0.0); // Start rotation from 0 to 1

    // Rapidly change values to simulate rolling
    // We want the value changes to sync roughly with the spin speed visually
    int changes = 0;
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      changes++;
      if (!_isRolling || changes > 20) { // Safety limit or stop condition
        timer.cancel();
      } else {
        setState(() {
          _currentValue = _random.nextInt(6) + 1;
        });
      }
    });

    // Wait for animation to finish
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRolling = false;
      _currentValue = _random.nextInt(6) + 1; // Final result
    });

    widget.onRollComplete?.call();
    return _currentValue;
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _isRolling ? _animation : const AlwaysStoppedAnimation(0), 
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(4, 4),
            ),
          ],
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade300]
          )
        ),
        child: Center(
          child: _buildDiceFace(_currentValue),
        ),
      ),
    );
  }

  Widget _buildDiceFace(int value) {
    // Standard dice dot positions
    /*
      1: Center
      2: TopLeft, BottomRight
      3: TopLeft, Center, BottomRight
      4: TopLeft, TopRight, BottomLeft, BottomRight
      5: TopLeft, TopRight, Center, BottomLeft, BottomRight
      6: TL, TR, ML, MR, BL, BR
    */
    
    // We can use GridView for simplicity
    List<Widget> dots = [];
    
    switch (value) {
      case 1:
        dots = [_dot(Alignment.center)];
        break;
      case 2:
        dots = [_dot(Alignment.topLeft), _dot(Alignment.bottomRight)];
        break;
      case 3:
        dots = [_dot(Alignment.topLeft), _dot(Alignment.center), _dot(Alignment.bottomRight)];
        break;
      case 4:
        dots = [
          _dot(Alignment.topLeft), _dot(Alignment.topRight),
          _dot(Alignment.bottomLeft), _dot(Alignment.bottomRight)
        ];
        break;
      case 5:
        dots = [
          _dot(Alignment.topLeft), _dot(Alignment.topRight),
          _dot(Alignment.center),
          _dot(Alignment.bottomLeft), _dot(Alignment.bottomRight)
        ];
        break;
      case 6:
        dots = [
          _dot(Alignment.topLeft), _dot(Alignment.topRight),
          _dot(Alignment.centerLeft), _dot(Alignment.centerRight),
          _dot(Alignment.bottomLeft), _dot(Alignment.bottomRight)
        ];
        break;
    }

    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(children: dots),
    );
  }

  Widget _dot(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 14,
        height: 14,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
