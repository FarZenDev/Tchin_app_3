import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class SlotMachineWidget extends StatefulWidget {
  final Function(int sips) onResult;

  const SlotMachineWidget({super.key, required this.onResult});

  @override
  State<SlotMachineWidget> createState() => SlotMachineWidgetState();
}

class SlotMachineWidgetState extends State<SlotMachineWidget> {
  final List<String> _symbols = ["🍒", "🍋", "🔔", "💎", "🍺", "7️⃣"];
  
  // Controllers for each reel
  late FixedExtentScrollController _ctrl1;
  late FixedExtentScrollController _ctrl2;
  late FixedExtentScrollController _ctrl3;
  
  bool _isSpinning = false;
  String? _resultText;
  
  @override
  void initState() {
    super.initState();
    _ctrl1 = FixedExtentScrollController();
    _ctrl2 = FixedExtentScrollController();
    _ctrl3 = FixedExtentScrollController();
  }
  
  @override
  void dispose() {
    _ctrl1.dispose();
    _ctrl2.dispose();
    _ctrl3.dispose();
    super.dispose();
  }

  // Exposed method to trigger spin externally if needed, or internal button
  Future<void> spin() async {
    if (_isSpinning) return;
    setState(() {
      _isSpinning = true;
      _resultText = null;
    });

    // Random targets
    final rand = Random();
    int target1 = rand.nextInt(_symbols.length) + 20; // +20 loops
    int target2 = rand.nextInt(_symbols.length) + 40; 
    int target3 = rand.nextInt(_symbols.length) + 60;
    
    // Animate
    _ctrl1.animateToItem(target1, duration: const Duration(milliseconds: 1500), curve: Curves.easeOut);
    _ctrl2.animateToItem(target2, duration: const Duration(milliseconds: 2000), curve: Curves.easeOut);
    await _ctrl3.animateToItem(target3, duration: const Duration(milliseconds: 2500), curve: Curves.easeOut);
    
    // Calculate Result
    int idx1 = target1 % _symbols.length;
    int idx2 = target2 % _symbols.length;
    int idx3 = target3 % _symbols.length;

    String s1 = _symbols[idx1];
    String s2 = _symbols[idx2];
    String s3 = _symbols[idx3]; // Corrected index usage

    int sips = 0;
    String text = "";
    
    if (s1 == s2 && s2 == s3) {
      // JACKPOT
      if (s1 == "7️⃣" || s1 == "💎") {
        sips = 5;
        text = "JACKPOT !!! (5 Gorgées)";
      } else {
        sips = 3;
        text = "TRIPLÉ ! (3 Gorgées)";
      }
    } else if (s1 == s2 || s2 == s3 || s1 == s3) {
      sips = 2;
      text = "DOUBLE ! (2 Gorgées)";
    } else {
      sips = 1;
      text = "PERDU... (1 Gorgée)";
    }
    
    setState(() {
      _isSpinning = false;
      _resultText = text;
    });
    
    widget.onResult(sips);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 120, // Height of the view window
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber, width: 3),
            boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10)]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildReel(_ctrl1),
              const VerticalDivider(color: Colors.amber, width: 2),
              _buildReel(_ctrl2),
              const VerticalDivider(color: Colors.amber, width: 2),
              _buildReel(_ctrl3),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        if (_resultText != null)
           Text(
             _resultText!, 
             style: GoogleFonts.bebasNeue(fontSize: 28, color: Colors.deepOrange)
           )
        else
           ElevatedButton(
             onPressed: _isSpinning ? null : spin,
             style: ElevatedButton.styleFrom(
               backgroundColor: Colors.amber, 
               foregroundColor: Colors.black,
               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)
             ),
             child: const Text("TENTER SA CHANCE 🎰", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           )
      ],
    );
  }

  Widget _buildReel(FixedExtentScrollController ctrl) {
    return SizedBox(
      width: 60,
      child: ListWheelScrollView.useDelegate(
        controller: ctrl,
        itemExtent: 60,
        physics: const FixedExtentScrollPhysics(),
        perspective: 0.005,
        childDelegate: ListWheelChildLoopingListDelegate(
          children: _symbols.map((s) => Center(
            child: Text(s, style: const TextStyle(fontSize: 40)),
          )).toList(),
        ),
      ),
    );
  }
}
