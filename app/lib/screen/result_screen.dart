import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;

  const ResultScreen({Key? key, required this.correctAnswers, required this.totalQuestions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Result")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have learned $correctAnswers/$totalQuestions words!',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              child: const Text("Go Back"),
            ),
          ],
        ),
      ),
    );
  }
}
