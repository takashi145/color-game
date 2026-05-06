import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_state.dart';

class StorageService {
  static const _keyHighScoreColor = 'high_score_color';
  static const _keyHighScoreWord = 'high_score_word';
  static const _keyHighScoreMix = 'high_score_mix';
  static const _keyTotalPlays = 'total_plays';
  static const _keyTotalCorrect = 'total_correct';
  static const _keyTotalQuestions = 'total_questions';

  static String _highScoreKey(GameMode mode) {
    switch (mode) {
      case GameMode.colorMode:
        return _keyHighScoreColor;
      case GameMode.wordMode:
        return _keyHighScoreWord;
      case GameMode.mixMode:
        return _keyHighScoreMix;
    }
  }

  Future<int> getHighScore(GameMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey(mode)) ?? 0;
  }

  Future<bool> saveHighScore(GameMode mode, int score) async {
    final current = await getHighScore(mode);
    if (score <= current) return false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_highScoreKey(mode), score);
    return true;
  }

  Future<Map<String, int>> getAllStats() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'highScoreColor': prefs.getInt(_keyHighScoreColor) ?? 0,
      'highScoreWord': prefs.getInt(_keyHighScoreWord) ?? 0,
      'highScoreMix': prefs.getInt(_keyHighScoreMix) ?? 0,
    };
  }

  Future<void> recordGameResult({
    required int correctCount,
    required int totalQuestions,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final plays = (prefs.getInt(_keyTotalPlays) ?? 0) + 1;
    final correct = (prefs.getInt(_keyTotalCorrect) ?? 0) + correctCount;
    final questions = (prefs.getInt(_keyTotalQuestions) ?? 0) + totalQuestions;
    await prefs.setInt(_keyTotalPlays, plays);
    await prefs.setInt(_keyTotalCorrect, correct);
    await prefs.setInt(_keyTotalQuestions, questions);
  }
}