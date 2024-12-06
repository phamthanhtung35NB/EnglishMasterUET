import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../../data/words_data.dart';
import '../../model/word.dart';
import '../../widgets/flashcard.dart';
import '../home_screen.dart';
import 'result_screen.dart';

class FlashcardScreen extends StatefulWidget {
  final String topic;

  const FlashcardScreen({super.key, required this.topic});

  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int currentIndex = 0;
  int correctAnswers = 0;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  bool isAnswerCorrect = false;
  late FlutterTts flutterTts;
  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _speakWord(String word) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.3);
    await flutterTts.speak(word);
  }

  @override
  Widget build(BuildContext context) {
    final words = topicWords[widget.topic]!;
    final currentWord = words[currentIndex];

    void checkAnswer(String input) {
      setState(() {
        isAnswerCorrect =
        (input.trim().toLowerCase() == currentWord.word.toLowerCase());
        if (isAnswerCorrect) correctAnswers++;
      });

      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              backgroundColor:
              isAnswerCorrect ? Colors.green[100] : Colors.red[100],
              title: Text(
                isAnswerCorrect ? "Chính xác!" : "Sai rồi!",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(
                isAnswerCorrect
                    ? "Bạn đã trả lời đúng!"
                    : "Từ đúng là: ${currentWord.word}",
              ),
            ),
      );

      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.of(context).maybePop();
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
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Từ ${currentIndex + 1}/${words.length}',
                    style: TextStyle(color: Colors.blue[600]),
                  ),
                  IconButton(
                    icon: Icon(Icons.volume_up, color: Colors.blue[400]),
                    onPressed: () => _speakWord(currentWord.word),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: FlipCard(
                  key: cardKey,
                  front: Flashcard(text: currentWord.word),
                  back: Flashcard(text: currentWord.meaning),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => _showInputDialog(context, checkAnswer),
                      child: const Text('Kiểm Tra'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue[600],
                        side: BorderSide(color: Colors.blue.shade400),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          correctAnswers++;
                          _moveToNextWord(words);
                        });
                      },
                      child: const Text('Tôi Đã Biết Từ Này'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInputDialog(BuildContext context, Function(String) checkAnswer) {
    TextEditingController inputController = TextEditingController();
    bool isEmpty = false;

    showDialog(
      context: context,
      builder: (context) =>
          StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("Nhập Từ"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: inputController,
                      decoration: InputDecoration(
                        hintText: "Nhập từ của bạn",
                        errorText: isEmpty ? "Vui lòng nhập từ" : null,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (inputController.text
                          .trim()
                          .isEmpty) {
                        setState(() {
                          isEmpty = true;
                        });
                      } else {
                        Navigator.pop(context);
                        checkAnswer(inputController.text);
                      }
                    },
                    child: const Text("Xác Nhận"),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _moveToNextWord(List<Word> words) {
    if (currentIndex < words.length - 1) {
      setState(() {
        currentIndex++;
        cardKey = GlobalKey<FlipCardState>();
      });
    } else {
      context.read<AppState>().updateScreen(
        'Result',
        ResultScreen(
          correctAnswers: correctAnswers,
          totalQuestions: words.length,
        ),
      );
    }
  }
}
