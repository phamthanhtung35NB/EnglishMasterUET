import 'dart:math';

class ListenData {
  final String question; // Câu hỏi nghe
  final String correctAnswer; // Đáp án đúng

  ListenData({
    required this.question,
    required this.correctAnswer,
  });

  // Danh sách các bài tập nghe
  static List<ListenData> getExercises() {
    return [
      ListenData(
        question: "hello world",
        correctAnswer: "hello world",
      ),
      ListenData(
        question: "good morning",
        correctAnswer: "good morning",
      ),
      ListenData(
        question: "how are you",
        correctAnswer: "how are you",
      ),
      ListenData(
        question: "thank you",
        correctAnswer: "thank you",
      ),
      ListenData(
        question: "goodbye",
        correctAnswer: "goodbye",
      ),
      // Thêm các bài tập khác tại đây
    ];
  }

  // Hàm để lấy một câu hỏi ngẫu nhiên
  static ListenData getRandomExercise() {
    final random = Random();
    List<ListenData> exercises = getExercises();
    int randomIndex = random.nextInt(exercises.length); // Sinh chỉ số ngẫu nhiên
    return exercises[randomIndex]; // Trả về bài tập ngẫu nhiên
  }
}
