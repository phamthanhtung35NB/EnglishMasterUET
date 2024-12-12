import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../../data/words_data.dart';
import '../../model/word.dart';
import '../../widgets/flashcard.dart';
import '../home_screen.dart';
import 'result_screen.dart';
import '../../model/learned_word.dart';
import '../../model/user_progress.dart';

class FlashcardScreen extends StatefulWidget {
  final String topic;

  const FlashcardScreen({Key? key, required this.topic}) : super(key: key);

  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  int correctAnswers = 0;
  bool _isListening = false;
  bool isAnswerCorrect = false;
  late FlutterTts flutterTts;
  late AudioPlayer audioPlayer;
  late AnimationController _animationController;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.4,
      upperBound: 0.6,
    );
    flutterTts = FlutterTts();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    flutterTts.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _speakWord(String word) async {
    setState(() {
      _isListening = true;
      _animationController.repeat(reverse: true);
    });
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.4);
    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isListening = false;
          if (_animationController.isAnimating) {
            _animationController.stop();
            _animationController.reset();
          }
        });
      }
    });
    await flutterTts.speak(word);
  }

  Future<void> playSound(String filePath) async {
    final AudioPlayer player = AudioPlayer();
    try {
      await player.play(AssetSource(filePath));
    } catch (e) {
      print("Lỗi phát âm thanh: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final words = topicWords[widget.topic]!;
    final currentWord = words[currentIndex];
    // Kiểm tra câu trả lời
    void checkAnswer(String input) {
      setState(() {
        isAnswerCorrect =
            (input.trim().toLowerCase() == currentWord.word.toLowerCase());
        if (isAnswerCorrect) {
          correctAnswers++;
          // Create a LearnedWord and add to user progress
          LearnedWord learnedWord = LearnedWord(
            word: currentWord.word,
            meaning: currentWord.meaning,
            topic: widget.topic,
          );
          // Add learned word to user progress
          context.read<UserProgress>().addLearnedWord(learnedWord);
        }
      });
      // Thông báo đúng sai
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
      ).then((_) {
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Từ ${currentIndex + 1}/${words.length}',
                    style: TextStyle(color: Colors.blue[600]),
                  ),
                  ScaleTransition(
                    scale: _animationController,
                    child: IconButton(
                      icon: Icon(
                        _isListening ? Icons.music_note : Icons.volume_up,
                        color: _isListening ? Colors.blue[300] : Colors.blue,
                        size: 48,
                      ),
                      onPressed: () => _speakWord(currentWord.word),
                    ),
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
                  onFlip: () async {
                    await playSound('sounds/flip_sound.mp3');
                  },
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
                        backgroundColor: Colors.blue.shade500,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  // Yêu cầu nhập từ vừa học
  void _showInputDialog(BuildContext context, Function(String) checkAnswer) {
    final TextEditingController inputController = TextEditingController();
    final FocusNode focusNode = FocusNode();
    bool isEmpty = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 330,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade50,
                    Colors.blue.shade100,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200.withOpacity(0.5),
                    blurRadius: 25,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Kiểm tra',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.blue.shade800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    controller: inputController,
                    cursorColor: Colors.black54,
                    focusNode: focusNode,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 22,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.5),
                      hintText: 'Nhập từ bạn vừa học',
                      errorText: isEmpty ? "Vui lòng nhập từ" : null,
                      hintStyle: TextStyle(
                        color: Colors.blue.shade300,
                        fontSize: 18,
                      ),
                      errorStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        height: 2.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Colors.blue.shade400,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        Navigator.pop(context);
                        checkAnswer(value);
                      }
                    },
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue[600],
                            side: BorderSide(color: Colors.blue.shade400),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Huỷ Bỏ',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton(
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade500,
                          foregroundColor: Colors.white,
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text('Xác Nhận',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Chuyển qua từ tiếp theo
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
