import 'dart:async';

import 'package:flutter/material.dart';

import '../logic/game_logic.dart';
import '../models/color_pair.dart';
import '../models/game_color.dart';
import '../models/game_state.dart';
import '../services/storage_service.dart';

class GameProvider extends ChangeNotifier {
  GameProvider({required StorageService storageService})
      : _storage = storageService;

  final StorageService _storage;
  Timer? _timer;
  Timer? _feedbackTimer;

  GameState _state = GameState(
    mode: GameMode.colorMode,
    phase: GamePhase.idle,
    currentPair: ColorPair(
      textContent: GameColor.red,
      textColor: GameColor.blue,
    ),
    instruction: AnswerInstruction.color,
    score: 0,
    totalQuestions: 0,
    correctCount: 0,
    remainingSeconds: kGameDurationSeconds,
    lastAnswerCorrect: null,
  );

  int _highScore = 0;
  bool _isNewHighScore = false;
  bool _isAnswering = false;

  GameState get state => _state;
  int get highScore => _highScore;
  bool get isNewHighScore => _isNewHighScore;

  Future<void> startGame(GameMode mode) async {
    _highScore = await _storage.getHighScore(mode);
    _isNewHighScore = false;
    _isAnswering = false;

    final pair = GameLogic.generateColorPair();
    final instruction = GameLogic.generateInstruction(mode, AnswerInstruction.color);

    _state = GameState(
      mode: mode,
      phase: GamePhase.playing,
      currentPair: pair,
      instruction: instruction,
      score: 0,
      totalQuestions: 0,
      correctCount: 0,
      remainingSeconds: kGameDurationSeconds,
      lastAnswerCorrect: null,
    );
    notifyListeners();

    _startTimer();
  }

  void answer(GameColor selected) {
    if (_state.phase != GamePhase.playing) return;
    if (_isAnswering) return;
    _isAnswering = true;

    final correct = GameLogic.checkAnswer(_state, selected);
    final newScore = correct ? _state.score + kScorePerCorrect : _state.score;

    _state = _state.copyWith(
      score: newScore,
      totalQuestions: _state.totalQuestions + 1,
      correctCount: _state.correctCount + (correct ? 1 : 0),
      lastAnswerCorrect: correct,
    );
    notifyListeners();

    _feedbackTimer?.cancel();
    _feedbackTimer = Timer(const Duration(milliseconds: 400), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    _isAnswering = false;
    if (_state.phase != GamePhase.playing) return;

    final pair = GameLogic.generateColorPair();
    final instruction = GameLogic.generateInstruction(_state.mode, _state.instruction);

    _state = _state.copyWith(
      currentPair: pair,
      instruction: instruction,
      clearLastAnswer: true,
    );
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_state.remainingSeconds <= 1) {
        _endGame();
      } else {
        _state = _state.copyWith(remainingSeconds: _state.remainingSeconds - 1);
        notifyListeners();
      }
    });
  }

  Future<void> _endGame() async {
    _timer?.cancel();
    _feedbackTimer?.cancel();

    _isNewHighScore = await _storage.saveHighScore(_state.mode, _state.score);
    if (_isNewHighScore) {
      _highScore = _state.score;
    }
    await _storage.recordGameResult(
      correctCount: _state.correctCount,
      totalQuestions: _state.totalQuestions,
    );

    _state = _state.copyWith(phase: GamePhase.finished, remainingSeconds: 0);
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _feedbackTimer?.cancel();
    super.dispose();
  }
}