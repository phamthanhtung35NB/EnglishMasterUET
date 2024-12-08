class Question {
  final String question; // Từ tiếng Anh
  final List<String> correctAnswer; // Đáp án đúng bằng tiếng Việt
  final List<String> wordsToChooseFrom; // Các từ cần ghép từ tiếng Việt

  Question({
    required this.question,
    required this.correctAnswer,
    required this.wordsToChooseFrom,
  });

  // Getter để tách câu hỏi thành các từ riêng biệt
  List<String> get questionWords {
    return question.split(' '); // Tách câu hỏi thành các từ cách nhau bởi dấu cách
  }
}
List<Question> questions = [
  Question(
    question: 'twelve bottles',  // Câu hỏi bằng tiếng Anh
    correctAnswer: ['mười', 'hai', 'chai'], // Đáp án đúng bằng tiếng Việt
    wordsToChooseFrom: ['mười', 'hai', 'chai','abc','a','sd','s','2','f'], // Các từ người dùng có thể chọn
  ),
  Question(
    question: 'five books',
    correctAnswer: ['năm','quyển','sách'],
    wordsToChooseFrom: ['năm','quyển','sách'],
  ),
  // Thêm các câu hỏi khác ở đây...
];
