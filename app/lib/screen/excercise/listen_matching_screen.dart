import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ListenMatchingScreen extends StatefulWidget {
  const ListenMatchingScreen({super.key});

  @override
  _ListenMatchingScreenState createState() => _ListenMatchingScreenState();
}

class _ListenMatchingScreenState extends State<ListenMatchingScreen> {
  String correctAnswer = "hello world"; // Đáp án đúng
  String userAnswer = ""; // Câu trả lời của người dùng
  FlutterTts flutterTts = FlutterTts(); // Khởi tạo đối tượng FlutterTts

  // Hàm để phát âm thanh
  void _playAudio() async {
    await flutterTts.speak(correctAnswer); // Phát âm "hello world"
  }

  // Kiểm tra câu trả lời của người dùng
  void checkAnswer() {
    if (userAnswer.trim().toLowerCase() == correctAnswer.toLowerCase()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chính xác!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sai rồi, hãy thử lại!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bài tập Nghe và Viết',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _playAudio, // Gọi hàm phát âm thanh
                      icon: const Icon(Icons.volume_up),
                      iconSize: 40,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Nghe và viết lại câu nói bạn vừa nghe.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              onChanged: (value) {
                setState(() {
                  userAnswer = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Nhập câu trả lời của bạn",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 32),
              ),
              child: const Text(
                'Xác nhận',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            const Text(
              'Tip: Hãy lắng nghe thật kỹ để viết chính xác!',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
