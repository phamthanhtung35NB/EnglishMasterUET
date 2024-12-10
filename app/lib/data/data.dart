class ExerciseQuestion {
  final String sentence;
  final List<String> options;
  final int correctAnswerIndex;

  ExerciseQuestion({
    required this.sentence,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class ExerciseData {
  static List<ExerciseQuestion> questions = [
    ExerciseQuestion(
      sentence: "She ____ to the park every weekend.",
      options: ['go', 'goes', 'going', 'gone'],
      correctAnswerIndex: 1,
    ),
    ExerciseQuestion(
      sentence: "I ____ a book about history last night.",
      options: ['read', 'reads', 'reading', 'readed'],
      correctAnswerIndex: 0,
    ),
    ExerciseQuestion(
      sentence: "They ____ basketball after school yesterday.",
      options: ['play', 'plays', 'played', 'playing'],
      correctAnswerIndex: 2,
    ),
    ExerciseQuestion(
      sentence: "My brother ____ in London for five years.",
      options: ['live', 'lives', 'lived', 'living'],
      correctAnswerIndex: 1,
    ),
    ExerciseQuestion(
      sentence: "We ____ to the cinema next week.",
      options: ['will go', 'goes', 'going', 'go'],
      correctAnswerIndex: 0,
    ),
    ExerciseQuestion(
      sentence: "She is ____ her homework right now.",
      options: ['do', 'does', 'did', 'doing'],
      correctAnswerIndex: 3,
    ),
    ExerciseQuestion(
      sentence: "____ you like to have dinner with me?",
      options: ['Do', 'Does', 'Did', 'Doing'],
      correctAnswerIndex: 0,
    ),
    ExerciseQuestion(
      sentence: "The cat ____ on the roof last night.",
      options: ['sleep', 'sleeps', 'slept', 'sleeping'],
      correctAnswerIndex: 2,
    ),
    ExerciseQuestion(
      sentence: "I ____ a new car last month.",
      options: ['buy', 'buys', 'bought', 'buying'],
      correctAnswerIndex: 2,
    ),
    ExerciseQuestion(
      sentence: "They ____ English since childhood.",
      options: ['learn', 'learns', 'learned', 'learning'],
      correctAnswerIndex: 2,
    ),
  ];
}