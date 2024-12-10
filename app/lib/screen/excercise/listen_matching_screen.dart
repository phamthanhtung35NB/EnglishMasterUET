import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../data/listenData.dart';

class ListenMatchingScreen extends StatefulWidget {
  const ListenMatchingScreen({super.key});

  @override
  _ListenMatchingScreenState createState() => _ListenMatchingScreenState();
}

class _ListenMatchingScreenState extends State<ListenMatchingScreen> with SingleTickerProviderStateMixin {
  late ListenData currentExercise;
  String userAnswer = "";
  int currentIndex = 0;
  FlutterTts flutterTts = FlutterTts();
  final TextEditingController _textController = TextEditingController();
  late AnimationController _animationController;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    currentExercise = ListenData.getRandomExercise();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 0.8,
      upperBound: 1.0,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _playAudio() async {
    setState(() {
      _isListening = true;
    });

    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(currentExercise.question);

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isListening = false;
    });
  }

  void checkAnswer() {
    if (userAnswer.trim().toLowerCase() == currentExercise.correctAnswer.toLowerCase()) {
      _showFeedbackDialog(true);
      _moveToNextExercise();
    } else {
      _showFeedbackDialog(false);
    }
  }

  void _moveToNextExercise() {
    setState(() {
      if (currentIndex < ListenData.getExercises().length - 1) {
        currentIndex++;
        currentExercise = ListenData.getExercises()[currentIndex];
        userAnswer = "";
        _textController.clear();
      } else {
        _showCompletionDialog();
      }
    });
  }

  void _showFeedbackDialog(bool isCorrect) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isCorrect ? Colors.green[50] : Colors.red[50],
        title: Icon(
          isCorrect ? Icons.check_circle : Icons.error,
          color: isCorrect ? Colors.green : Colors.red,
          size: 64,
        ),
        content: Text(
          isCorrect
              ? 'Chính xác! Tuyệt vời!'
              : 'Câu trả lời chưa chính xác. Hãy thử lại!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isCorrect ? Colors.green[800] : Colors.red[800],
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (isCorrect) _moveToNextExercise();
            },
            child: Text(
              isCorrect ? 'Tiếp tục' : 'Thử lại',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue[50],
        title: const Icon(
          Icons.celebration,
          color: Colors.blue,
          size: 64,
        ),
        content: const Text(
          'Chúc mừng! Bạn đã hoàn thành tất cả bài tập nghe.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Có thể thêm chức năng reset hoặc quay về màn hình chính
            },
            child: const Text(
              'Hoàn tất',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Listening Challenge'),
        centerTitle: true,
        backgroundColor: Colors.blue[600],
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: 1.1),
                duration: const Duration(milliseconds: 500),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ScaleTransition(
                                  scale: _animationController,
                                  child: IconButton(
                                    onPressed: _playAudio,
                                    icon: Icon(
                                      _isListening ? Icons.music_note : Icons.volume_up,
                                      color: _isListening ? Colors.blue[300] : Colors.blue,
                                      size: 48,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Text(
                                    'Nhấn vào biểu tượng để nghe và ghi lại câu.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _textController,
                onChanged: (value) {
                  setState(() {
                    userAnswer = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Nhập câu trả lời của bạn",
                  labelStyle: TextStyle(color: Colors.blue[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.blue[50],
                  prefixIcon: const Icon(Icons.edit),
                ),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: userAnswer.isNotEmpty ? checkAnswer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  disabledBackgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 48),
                ),
                child: const Text(
                  'Kiểm tra',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'Mẹo: Tập trung lắng nghe và ghi chép chính xác!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

            ],
          ),
        ),
      ),
    );
  }
}