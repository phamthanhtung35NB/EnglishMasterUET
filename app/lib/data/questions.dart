import 'dart:math';

class Question {
  final String question;
  final List<String> correctAnswer;
  final List<String> wordsToChooseFrom;

  Question({
    required this.question,
    required this.correctAnswer,
    required this.wordsToChooseFrom,
  });

  // Method to shuffle words within each question
  Question shuffleWords() {
    final Random random = Random();
    List<String> shuffledWords = List.from(wordsToChooseFrom)..shuffle(random);
    return Question(
      question: question,
      correctAnswer: correctAnswer,
      wordsToChooseFrom: shuffledWords,
    );
  }
}

// Function to get randomized questions
List<Question> getRandomizedQuestions(List<Question> originalQuestions) {
  final Random random = Random();
  List<Question> questions = List.from(originalQuestions);

  // Shuffle the entire list of questions
  questions.shuffle(random);

  // Shuffle words within each question
  return questions.map((question) => question.shuffleWords()).toList();
}

List<Question> questions = [
  Question(
    question: 'twelve bottles',
    correctAnswer: ['mười', 'hai', 'chai'],
    wordsToChooseFrom: ['mười', 'hai', 'chai', 'bút', 'cây', 'bảy'],
  ),
  Question(
    question: 'five books',
    correctAnswer: ['năm','quyển','sách'],
    wordsToChooseFrom: ['năm','quyển','sách', 'bốn', 'giấy', 'bút'],
  ),
  Question(
    question: 'three cars',
    correctAnswer: ['ba', 'chiếc', 'xe'],
    wordsToChooseFrom: ['ba', 'chiếc', 'xe', 'bốn', 'máy', 'nhà'],
  ),
  Question(
    question: 'six pencils',
    correctAnswer: ['sáu', 'cái', 'bút'],
    wordsToChooseFrom: ['sáu', 'cái', 'bút', 'năm', 'giấy', 'mười'],
  ),
  Question(
    question: 'eight cups',
    correctAnswer: ['tám', 'cái', 'cốc'],
    wordsToChooseFrom: ['tám', 'cái', 'cốc', 'bảy', 'chai', 'máy'],
  ),
  Question(
    question: 'two dogs',
    correctAnswer: ['hai', 'con', 'chó'],
    wordsToChooseFrom: ['hai', 'con', 'chó', 'ba', 'mèo', 'năm'],
  ),
  Question(
    question: 'four pens',
    correctAnswer: ['bốn', 'cái', 'bút'],
    wordsToChooseFrom: ['bốn', 'cái', 'bút', 'sáu', 'giấy', 'xe'],
  ),
  Question(
    question: 'The cat drinks milk',
    correctAnswer: ['con', 'mèo', 'uống', 'sữa'],
    wordsToChooseFrom: ['con', 'mèo', 'uống', 'sữa', 'nước', 'cái'],
  ),
  Question(
    question: 'She eats an apple',
    correctAnswer: ['cô', 'ấy', 'ăn', 'quả', 'táo'],
    wordsToChooseFrom: ['cô', 'ấy', 'ăn', 'quả', 'táo', 'chuối'],
  ),
  Question(
    question: 'We go to school',
    correctAnswer: ['chúng', 'tôi', 'đi', 'đến', 'trường'],
    wordsToChooseFrom: ['chúng', 'tôi', 'đi', 'đến', 'trường', 'nhà'],
  ),
  Question(
    question: 'He plays football',
    correctAnswer: ['anh', 'ấy', 'chơi', 'bóng', 'đá'],
    wordsToChooseFrom: ['anh', 'ấy', 'chơi', 'bóng', 'đá', 'tennis'],
  ),
  Question(
    question: 'They read books',
    correctAnswer: ['họ', 'đọc', 'sách'],
    wordsToChooseFrom: ['họ', 'đọc', 'sách', 'báo', 'bút', 'giấy'],
  ),
  Question(
    question: 'The dog barks loudly',
    correctAnswer: ['con', 'chó', 'sủa', 'to'],
    wordsToChooseFrom: ['con', 'chó', 'sủa', 'to', 'mèo', 'nhỏ'],
  ),
  Question(
    question: 'She writes a letter',
    correctAnswer: ['cô', 'ấy', 'viết', 'một', 'bức', 'thư'],
    wordsToChooseFrom: ['cô', 'ấy', 'viết', 'một', 'bức', 'thư', 'email'],
  ),
  Question(
    question: 'The cat drinks milk',
    correctAnswer: ['con', 'mèo', 'uống', 'sữa'],
    wordsToChooseFrom: ['con', 'mèo', 'uống', 'sữa', 'nước', 'cái'],
  ),
  Question(
    question: 'She eats an apple',
    correctAnswer: ['cô', 'ấy', 'ăn', 'quả', 'táo'],
    wordsToChooseFrom: ['cô', 'ấy', 'ăn', 'quả', 'táo', 'chuối'],
  ),
  Question(
    question: 'We go to school',
    correctAnswer: ['chúng', 'tôi', 'đi', 'đến', 'trường'],
    wordsToChooseFrom: ['chúng', 'tôi', 'đi', 'đến', 'trường', 'nhà'],
  ),
  Question(
    question: 'He plays football',
    correctAnswer: ['anh', 'ấy', 'chơi', 'bóng', 'đá'],
    wordsToChooseFrom: ['anh', 'ấy', 'chơi', 'bóng', 'đá', 'tennis'],
  ),
  Question(
    question: 'They read books',
    correctAnswer: ['họ', 'đọc', 'sách'],
    wordsToChooseFrom: ['họ', 'đọc', 'sách', 'báo', 'bút', 'giấy'],
  ),
  Question(
    question: 'The dog barks loudly',
    correctAnswer: ['con', 'chó', 'sủa', 'to'],
    wordsToChooseFrom: ['con', 'chó', 'sủa', 'to', 'mèo', 'nhỏ'],
  ),
  Question(
    question: 'She writes a letter',
    correctAnswer: ['cô', 'ấy', 'viết', 'một', 'bức', 'thư'],
    wordsToChooseFrom: ['cô', 'ấy', 'viết', 'một', 'bức', 'thư', 'email'],
  )
];