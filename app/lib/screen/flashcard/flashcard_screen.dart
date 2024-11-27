import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:provider/provider.dart';
import '../../data/words_data.dart';
import '../../widgets/flashcard.dart';
import '../home_screen.dart';
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

      // Delay trước khi chuyển từ
      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.pop(context); // Close the dialog
        if (currentIndex < words.length - 1) {
          setState(() {
            currentIndex++;
          });
          cardKey = GlobalKey<FlipCardState>();
        } else {
          context.read<AppState>().updateScreen(
            'Result',
            ResultScreen(
              correctAnswers: correctAnswers,
              totalQuestions: words.length,
            ),
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
                      TextEditingController inputController = TextEditingController();
                      bool isEmpty = false;
                      showDialog(
                        context: context,
                        builder: (context) => StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: const Text("Enter the word"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: inputController,
                                    decoration: const InputDecoration(hintText: "Type here"),
                                  ),
                                  if (isEmpty) // Hiển thị thông báo nếu input rỗng.
                                    const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "Please enter a word",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    if (inputController.text.trim().isEmpty) {
                                      // Nếu input rỗng, cập nhật trạng thái và hiển thị thông báo.
                                      setState(() {
                                        isEmpty = true;
                                      });
                                    } else {
                                      Navigator.pop(context);
                                      checkAnswer(inputController.text); // Gọi hàm kiểm tra.
                                    }
                                  },
                                  child: const Text("Submit"),
                                ),
                              ],
                            );
                          },
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
                          context.read<AppState>().updateScreen(
                                'Result',
                                ResultScreen(
                                  correctAnswers: correctAnswers,
                                  totalQuestions: words.length,
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
