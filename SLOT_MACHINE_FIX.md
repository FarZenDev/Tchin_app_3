Ajoutez ce code dans game_screen.dart après la ligne 293 (après le bouton "Tourner la Roue"):

```dart
                                      else if (game.currentQuestionType == QuestionType.slotMachine)
                                         Padding(
                                           padding: const EdgeInsets.only(top: 10),
                                           child: SlotMachineWidget(
                                             onResult: (sips) {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (ctx) => AlertDialog(
                                                    title: const Text("🎰 Résultat du Jackpot !"),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        const Text("Tu dois boire :"),
                                                        const SizedBox(height: 10),
                                                        Text("$sips gorgée${sips > 1 ? 's' : ''} 🍺", 
                                                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepOrange)
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(ctx),
                                                        child: const Text("OK", style: TextStyle(fontSize: 18)),
                                                      )
                                                    ],
                                                  )
                                                );
                                             },
                                           ),
                                         )
```

Insérez ce code AVANT le `else` à la ligne 294.
