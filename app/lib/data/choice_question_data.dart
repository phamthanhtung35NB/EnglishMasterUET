import 'dart:math';

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
  static List<ExerciseQuestion> generateQuestions() {
    List<ExerciseQuestion> baseQuestions = [
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
        options: ['learned', 'learns', 'have learned', 'learning'],
        correctAnswerIndex: 2,
      ),

      ExerciseQuestion(
        sentence: "My friends ____ to the beach every summer.",
        options: ['go', 'goes', 'went', 'going'],
        correctAnswerIndex: 0,
      ),
      ExerciseQuestion(
        sentence: "He ____ to finish his homework before watching TV.",
        options: ['should', 'has', 'must', 'may'],
        correctAnswerIndex: 1,
      ),
      ExerciseQuestion(
        sentence: "The students ____ an important exam next week.",
        options: ['will take', 'take', 'takes', 'taking'],
        correctAnswerIndex: 0,
      ),
      ExerciseQuestion(
        sentence: "She ____ piano since she was a child.",
        options: ['played', 'has played', 'played', 'playing'],
        correctAnswerIndex: 1,
      ),
      ExerciseQuestion(
        sentence: "I ____ to Paris twice this year.",
        options: ['travel', 'travels', 'traveled', 'travelling'],
        correctAnswerIndex: 2,
      ),
      ExerciseQuestion(
        sentence: "They ____ a great movie last night.",
        options: ['watch', 'watches', 'watched', 'watching'],
        correctAnswerIndex: 2,
      ),
      ExerciseQuestion(
        sentence: "____ he come to the party tomorrow?",
        options: ['Does', 'Do', 'Will', 'Is'],
        correctAnswerIndex: 2,
      ),
      ExerciseQuestion(
        sentence: "The flowers ____ in the garden right now.",
        options: ['bloom', 'blooms', 'bloomed', 'are blooming'],
        correctAnswerIndex: 3,
      ),
      ExerciseQuestion(
        sentence: "We ____ lunch at the new restaurant next week.",
        options: ['will have', 'have', 'has', 'having'],
        correctAnswerIndex: 0,
      ),
      ExerciseQuestion(
        sentence: "The children ____ quietly in the library.",
        options: ['read', 'reads', 'are reading', 'readed'],
        correctAnswerIndex: 2,
      )
    ];

    var random = Random();
    baseQuestions.shuffle(random);

    for (var question in baseQuestions) {
      var originalOptions = List<String>.from(question.options);
      var originalCorrectIndex = question.correctAnswerIndex;
      var shuffledOptions = [...originalOptions];
      shuffledOptions.shuffle(random);
      var newCorrectIndex =
          shuffledOptions.indexOf(originalOptions[originalCorrectIndex]);
      question = ExerciseQuestion(
        sentence: question.sentence,
        options: shuffledOptions,
        correctAnswerIndex: newCorrectIndex,
      );
    }

    return baseQuestions;
  }

  static List<ExerciseQuestion> questions = generateQuestions();
}
