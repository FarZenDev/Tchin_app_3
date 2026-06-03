
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/game_layout.dart';

class PartyGamesScreen extends StatelessWidget {
  const PartyGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameLayout(
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          
          Expanded(
            child: ListView(
              children: [
                _buildGameCard(
                  context,
                  title: "L'Autoroute",
                  description: "Traversez l'autoroute sans faire marche arrière. Un jeu de cartes classique !",
                  icon: "🛣️",
                  color: Colors.orangeAccent,
                  onTap: () => Navigator.pushNamed(context, '/autoroute'),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                
                const SizedBox(height: 16),
                
                _buildLockedGameCard(
                  title: "Le 21",
                  description: "Comptez jusqu'à 21, mais attention aux nouvelles règles !",
                  icon: "🎲",
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

                const SizedBox(height: 16),

                _buildLockedGameCard(
                  title: "Pyramide",
                  description: "Mémorisez vos cartes et bluffez vos amis pour donner des gorgées.",
                  icon: "🔺",
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white10,
            foregroundColor: Colors.white,
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              "Jeux de Soirée",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
        const SizedBox(width: 48), // Spacer to balance back button
      ],
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
    required String title,
    required String description,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.glassCardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 30)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppTheme.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLockedGameCard({
    required String title,
    required String description,
    required String icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.glassCardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.5),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 30, color: Colors.grey)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.lock_outline, color: Colors.grey, size: 20),
              ],
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black12,
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Bientôt disponible",
                    style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
