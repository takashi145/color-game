import 'color_pair.dart';
import 'game_color.dart';

enum GameMode {
  colorMode,
  wordMode,
  mixMode;

  String get label {
    switch (this) {
      case GameMode.colorMode:
        return '文字色モード';
      case GameMode.wordMode:
        return '文字内容モード';
      case GameMode.mixMode:
        return 'ミックスモード';
    }
  }
}

enum GamePhase { idle, countdown, playing, finished }

enum AnswerInstruction { color, word }

class GameState {
  const GameState({
    required this.mode,
    required this.phase,
    required this.currentPair,
    required this.instruction,
    required this.score,
    required this.totalQuestions,
    required this.correctCount,
    required this.remainingSeconds,
    required this.lastAnswerCorrect,
  });

  final GameMode mode;
  final GamePhase phase;
  final ColorPair currentPair;
  final AnswerInstruction instruction;
  final int score;
  final int totalQuestions;
  final int correctCount;
  final int remainingSeconds;
  final bool? lastAnswerCorrect;

  GameColor get correctAnswer {
    return instruction == AnswerInstruction.color
        ? currentPair.textColor
        : currentPair.textContent;
  }

  GameState copyWith({
    GameMode? mode,
    GamePhase? phase,
    ColorPair? currentPair,
    AnswerInstruction? instruction,
    int? score,
    int? totalQuestions,
    int? correctCount,
    int? remainingSeconds,
    bool? lastAnswerCorrect,
    bool clearLastAnswer = false,
  }) {
    return GameState(
      mode: mode ?? this.mode,
      phase: phase ?? this.phase,
      currentPair: currentPair ?? this.currentPair,
      instruction: instruction ?? this.instruction,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctCount: correctCount ?? this.correctCount,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      lastAnswerCorrect:
          clearLastAnswer ? null : (lastAnswerCorrect ?? this.lastAnswerCorrect),
    );
  }
}
