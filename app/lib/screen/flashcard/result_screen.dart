import 'package:english_master_uet/screen/flashcard/topic_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_screen.dart';

class ResultScreen extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (correctAnswers / totalQuestions) * 100;
    String resultMessage = _getResultMessage(percentage);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Kết Quả Học Tập',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[400]
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(
                    'Bạn đã học $correctAnswers/$totalQuestions từ',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    resultMessage,
                    style: TextStyle(
                        fontSize: 18,
                        color: _getMessageColor(percentage)
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[300],
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                context.read<AppState>().updateScreen(
                    'Flashcard',
                    TopicSelectionScreen()
                );
              },
              child: const Text(
                'Quay Lại',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getResultMessage(double percentage) {
    if (percentage == 100) return 'Tuyệt vời! Bài học hoàn hảo!';
    if (percentage >= 80) return 'Rất tốt! Tiếp tục phát huy!';
    if (percentage >= 60) return 'Khá tốt. Cố gắng nhiều hơn nhé!';
    if (percentage >= 40) return 'Bạn đang tiến bộ. Đừng ngừng học!';
    return 'Hãy cố gắng nhiều hơn nữa nhé!';
  }

  Color _getMessageColor(double percentage) {
    if (percentage == 100) return Colors.green;
    if (percentage >= 80) return Colors.blue;
    if (percentage >= 60) return Colors.orange;
    if (percentage >= 40) return Colors.deepOrange;
    return Colors.red;
  }
}