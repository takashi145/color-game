class BestScoreRecord {
  const BestScoreRecord({
    required this.score,
    required this.correctCount,
    required this.totalQuestions,
    required this.avgResponseTimeMs,
  });

  final int score;
  final int correctCount;
  final int totalQuestions;
  final int avgResponseTimeMs;

  double get accuracy =>
      totalQuestions == 0 ? 0 : correctCount / totalQuestions;

  bool get hasRecord => score > 0;
}