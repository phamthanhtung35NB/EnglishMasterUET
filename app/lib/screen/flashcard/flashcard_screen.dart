import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import '../../data/words_data.dart';
import '../../widgets/flashcard.dart';
import 'result_screen.dart';

class FlashcardScreen extends StatefulWidget {
  final String topic;

  const FlashcardScreen({Key? key, required this.topic}) : super(key: key);

  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int currentIndex = 0;
  int correctAnswers = 0;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  bool isAnswerCorrect = false;

  @override
  Widget build(BuildContext context) {
    final words =
    topicWords[widget.topic]!; // Lấy danh sách từ vựng theo chủ đề
    final currentWord = words[currentIndex]; // Lấy từ hiện tại

    void checkAnswer(String input) {
      setState(() {
        isAnswerCorrect =
        (input.trim().toLowerCase() == currentWord.word.toLowerCase());
        if (isAnswerCorrect) correctAnswers++;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(isAnswerCorrect ? "Correct!" : "Wrong!"),
          content: Text(isAnswerCorrect
              ? "You got it right!"
              : "The correct word is: ${currentWord.word}"),
        ),
      );

      // Delay before going to next word (reduced to 1 second)
      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.pop(context); // Close the dialog
        if (currentIndex < words.length - 1) {
          setState(() {
            currentIndex++;
          });
          cardKey = GlobalKey<
              FlipCardState>(); // Reset the card key to show the front side.
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ResultScreen(
                  correctAnswers: correctAnswers,
                  totalQuestions: words.length,
                )),
          );
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.topic)),
      body: Center(
        child: currentIndex < words.length
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlipCard(
              key: cardKey, // Đảm bảo cardKey được gán cho FlipCard
              front: Flashcard(text: currentWord.word),
              back: Flashcard(text: currentWord.meaning),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                TextEditingController inputController =
                TextEditingController();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Enter the word"),
                    content: TextField(
                      controller: inputController,
                      decoration:
                      const InputDecoration(hintText: "Type here"),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          checkAnswer(inputController
                              .text); // Kiểm tra câu trả lời khi người dùng nhấn Submit
                        },
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                );
              },
              child: const Text("Continue"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  correctAnswers++; // Tăng số câu trả lời đúng khi người dùng bỏ qua và biết từ này
                  if (currentIndex < words.length - 1) {
                    currentIndex++;
                    cardKey = GlobalKey<
                        FlipCardState>(); // Reset lại key của FlipCard để hiển thị mặt trước
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultScreen(
                          correctAnswers: correctAnswers,
                          totalQuestions: words.length,
                        ),
                      ),
                    );
                  }
                });
              },
              child: const Text("I already know this word"),
            ),
          ],
        )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
