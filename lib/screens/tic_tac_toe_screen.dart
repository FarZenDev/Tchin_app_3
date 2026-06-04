import 'dart:math';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/premium_provider.dart';
import '../services/ad_service.dart';
import '../theme/app_theme.dart';
import '../widgets/game_layout.dart';
import '../widgets/gradient_button.dart';

class TicTacToeScreen extends StatefulWidget {
  final String challenger;

  const TicTacToeScreen({super.key, required this.challenger});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  String? _opponent;
  final List<int?> _board =
      List.filled(9, null); // 0 for X (challenger), 1 for O (opponent)
  final Queue<int> _p1Moves = Queue<int>();
  final Queue<int> _p2Moves = Queue<int>();
  bool _isP1Turn = true; // Challenger starts
  bool _gameOver = false;
  bool _allowExitPop = false;
  bool _isExitInterstitialShowing = false;

  @override
  void initState() {
    super.initState();
    // Auto-select opponent if only 2 players total
    final game = Provider.of<GameProvider>(context, listen: false);
    if (game.players.length == 2) {
      _opponent = game.players.firstWhere((p) => p != widget.challenger);
    }
  }

  Future<void> _leaveGame() async {
    if (_isExitInterstitialShowing) return;
    _isExitInterstitialShowing = true;

    final premium = context.read<PremiumProvider>();
    await context.read<AdService>().showInterstitialIfReady(
          isPremium: premium.isPremium,
          context: context,
        );

    if (!mounted) return;
    setState(() => _allowExitPop = true);
    Navigator.pop(context);
  }

  void _handleTap(int index) {
    if (_gameOver || _board[index] != null) return;

    setState(() {
      if (_isP1Turn) {
        // Player 1 (X)
        if (_p1Moves.length >= 3) {
          int old = _p1Moves.removeFirst();
          _board[old] = null;
        }
        _p1Moves.add(index);
        _board[index] = 0;
      } else {
        // Player 2 (O)
        if (_p2Moves.length >= 3) {
          int old = _p2Moves.removeFirst();
          _board[old] = null;
        }
        _p2Moves.add(index);
        _board[index] = 1;
      }

      if (_checkWin()) {
        _gameOver = true;
        _showWinDialog();
      } else {
        _isP1Turn = !_isP1Turn;
      }
    });
  }

  bool _checkWin() {
    // 012, 345, 678 (Rows)
    // 036, 147, 258 (Cols)
    // 048, 246 (Diags)
    final b = _board;
    final p = _isP1Turn ? 0 : 1;

    // Helper check
    bool c(int i1, int i2, int i3) => b[i1] == p && b[i2] == p && b[i3] == p;

    return c(0, 1, 2) ||
        c(3, 4, 5) ||
        c(6, 7, 8) ||
        c(0, 3, 6) ||
        c(1, 4, 7) ||
        c(2, 5, 8) ||
        c(0, 4, 8) ||
        c(2, 4, 6);
  }

  void _showWinDialog() {
    String winner = _isP1Turn ? widget.challenger : _opponent!;
    String loser = _isP1Turn ? _opponent! : widget.challenger;

    // Penalty logic
    final random = Random();
    bool culSec = random.nextDouble() < 0.2; // 20% chance
    String penalty =
        culSec ? "Cul sec !" : "Bois ${random.nextInt(5) + 1} gorgées !";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.glassCardBg,
        title: Text("🏆 $winner a gagné !",
            style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("💀 $loser a perdu...",
                style: const TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 20),
            Text(
              penalty,
              style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          GradientButton(
            text: "Retour au jeu",
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _leaveGame();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_opponent == null) {
      return _buildOpponentSelection();
    }
    return PopScope(
      canPop: _allowExitPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _leaveGame();
      },
      child: _buildGame(),
    );
  }

  Widget _buildOpponentSelection() {
    final game = Provider.of<GameProvider>(context, listen: false);
    final potentialOpponents =
        game.players.where((p) => p != widget.challenger).toList();

    return GameLayout(
        child: Column(
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Choisir un adversaire",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context))
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: potentialOpponents.length,
            itemBuilder: (context, index) {
              final p = potentialOpponents[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GradientButton(
                  text: p,
                  onPressed: () {
                    setState(() {
                      _opponent = p;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    ));
  }

  Widget _buildGame() {
    return GameLayout(
        child: Column(
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Morpion Infinity",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _leaveGame,
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Turn Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildPlayerBadge(widget.challenger, _isP1Turn, Colors.blue),
            const Text("VS",
                style: TextStyle(
                    color: Colors.white30, fontWeight: FontWeight.bold)),
            _buildPlayerBadge(_opponent!, !_isP1Turn, Colors.red),
          ],
        ),

        const SizedBox(height: 20),
        const Text(
          "Règle : 3 pions max par joueur.\nSi tu poses un 4ème, le 1er disparaît !",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 20),

        // Grid
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: AppTheme.glassCardBg,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3), blurRadius: 10)
                    ]),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _handleTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(8),
                            border: _board[index] != null
                                ? Border.all(
                                    color: _board[index] == 0
                                        ? Colors.blue.withOpacity(0.5)
                                        : Colors.red.withOpacity(0.5),
                                    width: 2)
                                : null),
                        child: Center(
                          child: _board[index] == null
                              ? null
                              : Icon(
                                  _board[index] == 0
                                      ? Icons.close
                                      : Icons.circle_outlined,
                                  color: _board[index] == 0
                                      ? Colors.blue
                                      : Colors.red,
                                  size: 40,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildPlayerBadge(String name, bool isActive, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.2) : Colors.transparent,
        border: Border.all(color: isActive ? color : Colors.transparent),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
                color: isActive ? Colors.white : AppTheme.textMuted,
                fontWeight: FontWeight.bold),
          ),
          if (isActive)
            Text("C'est ton tour !",
                style: TextStyle(color: color, fontSize: 10))
        ],
      ),
    );
  }
}
