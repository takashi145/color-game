import 'package:shared_preferences/shared_preferences.dart';

import '../models/best_score_record.dart';
import '../models/game_state.dart';

class StorageService {
  static const _keyHighScoreColor = 'high_score_color';
  static const _keyHighScoreWord = 'high_score_word';
  static const _keyHighScoreMix = 'high_score_mix';
  static const _keyBestCorrectColor = 'best_correct_color';
  static const _keyBestCorrectWord = 'best_correct_word';
  static const _keyBestCorrectMix = 'best_correct_mix';
  static const _keyBestQuestionsColor = 'best_questions_color';
  static const _keyBestQuestionsWord = 'best_questions_word';
  static const _keyBestQuestionsMix = 'best_questions_mix';
  static const _keyBestAvgTimeColor = 'best_avg_time_color';
  static const _keyBestAvgTimeWord = 'best_avg_time_word';
  static const _keyBestAvgTimeMix = 'best_avg_time_mix';
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

  static String _bestCorrectKey(GameMode mode) {
    switch (mode) {
      case GameMode.colorMode:
        return _keyBestCorrectColor;
      case GameMode.wordMode:
        return _keyBestCorrectWord;
      case GameMode.mixMode:
        return _keyBestCorrectMix;
    }
  }

  static String _bestQuestionsKey(GameMode mode) {
    switch (mode) {
      case GameMode.colorMode:
        return _keyBestQuestionsColor;
      case GameMode.wordMode:
        return _keyBestQuestionsWord;
      case GameMode.mixMode:
        return _keyBestQuestionsMix;
    }
  }

  static String _bestAvgTimeKey(GameMode mode) {
    switch (mode) {
      case GameMode.colorMode:
        return _keyBestAvgTimeColor;
      case GameMode.wordMode:
        return _keyBestAvgTimeWord;
      case GameMode.mixMode:
        return _keyBestAvgTimeMix;
    }
  }

  Future<int> getHighScore(GameMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey(mode)) ?? 0;
  }

  Future<bool> saveHighScore(
    GameMode mode,
    int score, {
    required int correctCount,
    required int totalQuestions,
    required int avgResponseTimeMs,
  }) async {
    final current = await getHighScore(mode);
    if (score <= current) return false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_highScoreKey(mode), score);
    await prefs.setInt(_bestCorrectKey(mode), correctCount);
    await prefs.setInt(_bestQuestionsKey(mode), totalQuestions);
    await prefs.setInt(_bestAvgTimeKey(mode), avgResponseTimeMs);
    return true;
  }

  Future<Map<GameMode, BestScoreRecord>> getAllBestRecords() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      for (final mode in GameMode.values)
        mode: BestScoreRecord(
          score: prefs.getInt(_highScoreKey(mode)) ?? 0,
          correctCount: prefs.getInt(_bestCorrectKey(mode)) ?? 0,
          totalQuestions: prefs.getInt(_bestQuestionsKey(mode)) ?? 0,
          avgResponseTimeMs: prefs.getInt(_bestAvgTimeKey(mode)) ?? 0,
        ),
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
