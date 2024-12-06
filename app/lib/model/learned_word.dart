class LearnedWord {
  final String word;
  final String meaning;
  final String topic;
  final DateTime learnedDate;
  bool isFavorite;

  LearnedWord({
    required this.word,
    required this.meaning,
    required this.topic,
    DateTime? learnedDate,
    this.isFavorite = false,
  }) : learnedDate = learnedDate ?? DateTime.now();

  // Methods to toggle favorite status
  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}