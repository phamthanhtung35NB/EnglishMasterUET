import 'package:flutter/material.dart';
import 'package:english_master_uet/data/choice_question_data.dart';

class ExerciseController extends ChangeNotifier {
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  bool _isQuestionAnswered = false;
  int? _selectedAnswerIndex;

  final List<ExerciseQuestion> questions = ExerciseData.questions;

  int get currentQuestionIndex => _currentQuestionIndex;
  int get totalQuestions => questions.length;
  int get correctAnswers => _correctAnswers;
  bool get isQuestionAnswered => _isQuestionAnswered;
  int? get selectedAnswerIndex => _selectedAnswerIndex;

  void selectAnswer(int index) {
    _selectedAnswerIndex = index;
    _isQuestionAnswered = true;
    notifyListeners();
  }

  void checkAnswer() {
    if (_selectedAnswerIndex == questions[_currentQuestionIndex].correctAnswerIndex) {
      _correctAnswers++;
      _moveToNextQuestion();
    } else {
      // Giữ nguyên câu hỏi để người dùng chọn lại
      _isQuestionAnswered = false;
      notifyListeners();
    }
  }

  void _moveToNextQuestion() {
    if (_currentQuestionIndex < questions.length - 1) {
      _currentQuestionIndex++;
      _isQuestionAnswered = false;
      _selectedAnswerIndex = null;
      notifyListeners();
    }
  }

  double get progressValue {
    return (_currentQuestionIndex + 1) / questions.length;
  }

  bool get isExerciseComplete => _currentQuestionIndex == questions.length - 1 && _isQuestionAnswered;
}