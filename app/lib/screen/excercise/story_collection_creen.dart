import 'package:flutter/material.dart';

class WordFillGameScreen extends StatefulWidget {
  @override
  _WordFillGameScreenState createState() => _WordFillGameScreenState();
}

class _WordFillGameScreenState extends State<WordFillGameScreen> {
  final List<String> wordsToChoose = ["dog", "forest", "mountain", "river"];
  final List<String> correctAnswer = ["dog", "forest"];
  final List<String> selectedWords = [];

  void checkAnswer() {
    bool isCorrect = selectedWords.length == correctAnswer.length &&
        selectedWords.every((word) => correctAnswer.contains(word));

    if (isCorrect) {
      // Hiệu ứng hoàn thành
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Image.asset('assets/images/success.png'), // Sử dụng hình ảnh thay vì Lottie
          content: const Text('🎉 Chúc mừng! Bạn đã trả lời chính xác!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tiếp tục'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Sai rồi, hãy thử lại!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text('Điền từ vào câu'),
        backgroundColor: Colors.purpleAccent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          // Câu chuyện
          Card(
            margin: const EdgeInsets.all(16),
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                  children: [
                    TextSpan(text: 'Once upon a time, there was a '),
                    TextSpan(
                      text: '______',
                      style: TextStyle(
                          backgroundColor: Colors.yellowAccent,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' living in the '),
                    TextSpan(
                      text: '______',
                      style: TextStyle(
                          backgroundColor: Colors.yellowAccent,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Các từ cần chọn
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: wordsToChoose.map((word) {
              return ChoiceChip(
                label: Text(
                  word,
                  style: const TextStyle(fontSize: 16),
                ),
                selected: selectedWords.contains(word),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedWords.add(word);
                    } else {
                      selectedWords.remove(word);
                    }
                  });
                },
                selectedColor: Colors.greenAccent,
                backgroundColor: Colors.white,
                elevation: 2,
              );
            }).toList(),
          ),

          const Spacer(),

          // Nút kiểm tra
          ElevatedButton.icon(
            onPressed: checkAnswer,
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text('Kiểm tra'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}
