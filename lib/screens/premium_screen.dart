import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/premium_provider.dart';
import '../widgets/game_layout.dart';
import '../widgets/gradient_button.dart';
import '../theme/app_theme.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameLayout(
      child: Column(
        children: [
          // Header
          Row(
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
                    "👑 Premium",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Crown Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppTheme.secondary, AppTheme.accent],
              ),
            ),
            child: const Icon(Icons.workspace_premium, size: 60, color: Colors.white),
          ),
          
          const SizedBox(height: 20),
          
          const Text(
            "Débloquez tous les modes !",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 30),
          
          // Benefits List
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.glassCardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Avantages Premium :",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildBenefit("🎮", "Accès aux 4 modes de jeu"),
                  _buildBenefit("🚫", "Zéro publicité"),
                  _buildBenefit("🎉", "Mode Duo exclusif"),
                  _buildBenefit("🍸", "Mode Bar exclusif"),
                  _buildBenefit("✨", "Mises à jour futures incluses"),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Price & Purchase Button
          Consumer<PremiumProvider>(
            builder: (context, premium, _) {
              if (!premium.isAvailable) {
                return const Text(
                  "Achats non disponibles",
                  style: TextStyle(color: AppTheme.error),
                );
              }
              
              final product = premium.products.isNotEmpty ? premium.products.first : null;
              
              return Column(
                children: [
                  if (product != null)
                    Text(
                      "${product.price} / mois",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondary,
                      ),
                    ),
                  const SizedBox(height: 16),
                  GradientButton(
                    text: "S'abonner maintenant",
                    icon: Icons.shopping_cart,
                    isLarge: true,
                    onPressed: () async {
                      await premium.purchasePremium();
                      if (context.mounted && premium.isPremium) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("🎉 Bienvenue Premium !"),
                            backgroundColor: AppTheme.success,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () async {
                      await premium.restorePurchases();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              premium.isPremium 
                                ? "✅ Achats restaurés !" 
                                : "Aucun achat trouvé"
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Restaurer les achats",
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildBenefit(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Icon(Icons.check_circle, color: AppTheme.success, size: 20),
        ],
      ),
    );
  }
}
