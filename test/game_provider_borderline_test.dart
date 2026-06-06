import 'package:flutter_test/flutter_test.dart';
import 'package:tchin_app_3/models/question_model.dart';
import 'package:tchin_app_3/providers/game_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  GameProvider providerWithPlayers() {
    return GameProvider()
      ..addPlayer('Mathis')
      ..addPlayer('Alex')
      ..addPlayer('Sam')
      ..addPlayer('Nico');
  }

  test('BorderLine sale never serves harder normal questions', () {
    final game = providerWithPlayers();
    addTearDown(game.dispose);

    game.setGameMode(
      GameMode.borderline,
      borderlineIntensity: BorderlineIntensity.sale,
      playSound: false,
    );

    for (var i = 0; i < 40 && !game.isGameOver; i++) {
      game.nextQuestion();

      if (!game.isGameOver && game.currentQuestionType == QuestionType.normal) {
        expect(
          game.currentQuestionIntensity.level,
          lessThanOrEqualTo(BorderlineIntensity.sale.level),
        );
      }
    }
  });

  test('BorderLine aucun filtre starts with sale pacing', () {
    final game = providerWithPlayers();
    addTearDown(game.dispose);

    game.setGameMode(
      GameMode.borderline,
      borderlineIntensity: BorderlineIntensity.aucunFiltre,
      playSound: false,
    );

    for (var i = 0; i < 4; i++) {
      game.nextQuestion();

      if (game.currentQuestionType == QuestionType.normal) {
        expect(
          game.currentQuestionIntensity.level,
          lessThanOrEqualTo(BorderlineIntensity.sale.level),
        );
      }
    }
  });
}
