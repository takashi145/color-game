import 'dart:math';

import '../models/color_pair.dart';
import '../models/game_color.dart';
import '../models/game_state.dart';

const int kGameDurationSeconds = 60;
const int kScorePerCorrect = 10;

class GameLogic {
  static final _random = Random();

  static ColorPair generateColorPair() {
    final colors = GameColor.values;
    final textContent = colors[_random.nextInt(colors.length)];
    GameColor textColor;
    do {
      textColor = colors[_random.nextInt(colors.length)];
    } while (textColor == textContent);
    return ColorPair(textContent: textContent, textColor: textColor);
  }

  static AnswerInstruction generateInstruction(GameMode mode, AnswerInstruction current) {
    switch (mode) {
      case GameMode.colorMode:
        return AnswerInstruction.color;
      case GameMode.wordMode:
        return AnswerInstruction.word;
      case GameMode.mixMode:
        return _random.nextBool() ? AnswerInstruction.color : AnswerInstruction.word;
    }
  }

  static bool checkAnswer(GameState state, GameColor selected) {
    return selected == state.correctAnswer;
  }
}