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
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(word);
  }

  @override
  Widget build(BuildContext context) {
    final words = topicWords[widget.topic]!;
    final currentWord = words[currentIndex];

    void checkAnswer(String input) {
      setState(() {
        isAnswerCorrect = (input.trim().toLowerCase() == currentWord.word.toLowerCase());
        if (isAnswerCorrect) correctAnswers++;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: isAnswerCorrect ? Colors.green[100] : Colors.red[100],
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
        Navigator.pop(context);
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
      appBar: AppBar(
        title: Text(widget.topic),
        backgroundColor: Colors.blue[100],
        elevation: 0,
      ),
      body: Center(
        child: currentIndex < words.length
            ? Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
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
              const SizedBox(height: 20),
              FlipCard(
                key: cardKey,
                front: Flashcard(text: currentWord.word),
                back: Flashcard(text: currentWord.meaning),
              ),
              const SizedBox(height: 20),
              Row(
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
                  const SizedBox(width: 10),
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
            ],
          ),
        )
            : const CircularProgressIndicator(),
      ),
    );
  }

  void _showInputDialog(BuildContext context, Function(String) checkAnswer) {
    TextEditingController inputController = TextEditingController();
    bool isEmpty = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
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
                  if (inputController.text.trim().isEmpty) {
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