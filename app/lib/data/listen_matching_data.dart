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
      ListenData(
        question: "see you later",
        correctAnswer: "see you later",
      ),
      ListenData(
        question: "nice to meet you",
        correctAnswer: "nice to meet you",
      ),
      ListenData(
        question: "what is your name",
        correctAnswer: "what is your name",
      ),
      ListenData(
        question: "I am fine",
        correctAnswer: "I am fine",
      ),
      ListenData(
        question: "have a nice day",
        correctAnswer: "have a nice day",
      ),
      ListenData(
        question: "good night",
        correctAnswer: "good night",
      ),
      ListenData(
        question: "welcome home",
        correctAnswer: "welcome home",
      ),
      ListenData(
        question: "I love you",
        correctAnswer: "I love you",
      ),
      ListenData(
        question: "see you tomorrow",
        correctAnswer: "see you tomorrow",
      ),
      ListenData(
        question: "take care",
        correctAnswer: "take care",
      ),
      ListenData(
        question: "how is the weather today",
        correctAnswer: "how is the weather today",
      ),
      ListenData(
        question: "can you help me please",
        correctAnswer: "can you help me please",
      ),
      ListenData(
        question: "what time is it now",
        correctAnswer: "what time is it now",
      ),
      ListenData(
        question: "where are you going",
        correctAnswer: "where are you going",
      ),
      ListenData(
        question: "I need some water",
        correctAnswer: "I need some water",
      ),
      ListenData(
        question: "let's go to the park",
        correctAnswer: "let's go to the park",
      ),
      ListenData(
        question: "do you like ice cream",
        correctAnswer: "do you like ice cream",
      ),
      ListenData(
        question: "what are you doing now",
        correctAnswer: "what are you doing now",
      ),
      ListenData(
        question: "please sit down here",
        correctAnswer: "please sit down here",
      ),
      ListenData(
        question: "this is a beautiful place",
        correctAnswer: "this is a beautiful place",
      ),
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
