class BestScoreRecord {
  const BestScoreRecord({
    required this.score,
    required this.correctCount,
    required this.totalQuestions,
  });

  final int score;
  final int correctCount;
  final int totalQuestions;

  double get accuracy =>
      totalQuestions == 0 ? 0 : correctCount / totalQuestions;

  bool get hasRecord => score > 0;
}
