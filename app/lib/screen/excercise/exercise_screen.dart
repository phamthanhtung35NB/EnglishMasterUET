import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_master_uet/controller/exercise_controller.dart';
import 'package:english_master_uet/data/data.dart';

class ExerciseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExerciseController(),
      child: Scaffold(
        backgroundColor: Colors.blue[10],
        appBar: AppBar(
          backgroundColor: Colors.blue[200],
          title: Text('English Grammar Exercise'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(10),
            child: Consumer<ExerciseController>(
              builder: (context, controller, child) {
                return LinearProgressIndicator(
                  value: controller.progressValue,
                  backgroundColor: Colors.blue[1],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                );
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<ExerciseController>(
            builder: (context, controller, child) {
              if (controller.isExerciseComplete) {
                return _buildResultScreen(context, controller);
              }

              ExerciseQuestion currentQuestion =
              controller.questions[controller.currentQuestionIndex];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Question ${controller.currentQuestionIndex + 1}/${controller.totalQuestions}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    currentQuestion.sentence,
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  ...List.generate(
                    currentQuestion.options.length,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getButtonColor(controller, index),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {
                          if (!controller.isQuestionAnswered) {
                            controller.selectAnswer(index);
                          }
                        },
                        child: Text(
                          currentQuestion.options[index],
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black, // Màu chữ đen
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (controller.isQuestionAnswered)
                    Center(
                      child: SizedBox(
                        width: 120, // Giới hạn chiều rộng của nút
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getCheckButtonColor(controller),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: () {
                            controller.checkAnswer();
                          },
                          child: Text(
                            _getCheckButtonText(controller),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
  Color _getButtonColor(ExerciseController controller, int index) {
    if (!controller.isQuestionAnswered) {
      return Colors.blue[200]!;
    }

    if (index == controller.selectedAnswerIndex) {
      return index == controller.questions[controller.currentQuestionIndex].correctAnswerIndex
          ? Colors.green
          : Colors.redAccent[100]!;
    }

    return Colors.blue[200]!;
  }

  Color _getCheckButtonColor(ExerciseController controller) {
    // Kiểm tra xem câu trả lời có đúng không
    final currentQuestion = controller.questions[controller.currentQuestionIndex];
    final isCorrectAnswer = controller.selectedAnswerIndex == currentQuestion.correctAnswerIndex;

    return isCorrectAnswer ? Colors.green : (Colors.redAccent);
  }

  String _getCheckButtonText(ExerciseController controller) {
    // Kiểm tra xem câu trả lời có đúng không
    final currentQuestion = controller.questions[controller.currentQuestionIndex];
    final isCorrectAnswer = controller.selectedAnswerIndex == currentQuestion.correctAnswerIndex;

    return isCorrectAnswer ? 'Tiếp tục' : 'Làm lại';
  }

  Widget _buildResultScreen(BuildContext context, ExerciseController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hoàn thành bài tập!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Số câu trả lời đúng: ${controller.correctAnswers}/${controller.totalQuestions}',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Có thể thêm chức năng làm lại bài hoặc quay lại màn hình chính
              Navigator.pop(context);
            },
            child: Text('Quay lại'),
          ),
        ],
      ),
    );
  }
}