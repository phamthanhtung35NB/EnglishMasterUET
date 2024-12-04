import 'package:english_master_uet/screen/flashcard/topic_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_screen.dart';

class ResultScreen extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;

  const ResultScreen(
      {Key? key, required this.correctAnswers, required this.totalQuestions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                context.read<AppState>().updateScreen(
                    'Flashcard',
                    TopicSelectionScreen()
                );
              },
              child: const Text("Go Back"),
            ),
          ],
        ),
      ),
    );
  }
}
