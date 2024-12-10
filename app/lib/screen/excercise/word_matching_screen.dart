import 'package:flutter/material.dart';
import '../../data/questions.dart';

class WordMatchingScreen extends StatefulWidget {
  const WordMatchingScreen({super.key});

  @override
  _WordMatchingScreenState createState() => _WordMatchingScreenState();
}

class _WordMatchingScreenState extends State<WordMatchingScreen> {
  int currentQuestionIndex = 0; // Chỉ số câu hỏi hiện tại
  List<String> words = []; // Các từ có sẵn để người dùng chọn
  List<String> selectedWords = []; // Các từ người dùng đã chọn
  String currentQuestion = ''; // Câu hỏi hiện tại

  // Hàm để nạp câu hỏi
  void loadQuestions() {
    setState(() {
      currentQuestion =
          questions[currentQuestionIndex].question; // Câu hỏi tiếng Anh
      words = List<String>.from(
          questions[currentQuestionIndex].wordsToChooseFrom); // Các từ cần chọn
    });
  }

  // Hàm xử lý khi người dùng chọn hoặc bỏ chọn một từ
  void onWordTap(String word) {
    setState(() {
      if (selectedWords.contains(word)) {
        selectedWords.remove(word); // Nếu từ đã chọn thì bỏ chọn
      } else {
        selectedWords.add(word); // Nếu chưa chọn thì thêm vào danh sách
      }
    });
  }

  // Hàm kiểm tra đáp án và chuyển sang câu hỏi tiếp theo
  void checkAnswer() {
    if (selectedWords.join(" ") ==
        questions[currentQuestionIndex].correctAnswer.join(" ")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chính xác!'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++; // Chuyển sang câu hỏi tiếp theo
          selectedWords.clear(); // Xóa các từ đã chọn
          loadQuestions(); // Nạp câu hỏi mới
        } else {
          // Nếu đã hết câu hỏi
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bạn đã hoàn thành tất cả câu hỏi!'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      });
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
  void initState() {
    super.initState();
    questions = getRandomizedQuestions(questions); // Randomize both question order and words
    loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị câu hỏi bằng tiếng Anh
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TỪ VỰNG MỚI',
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Viết lại bằng Tiếng Việt',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.volume_up,
                            size: 28, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          currentQuestion, // Hiển thị câu hỏi tiếng Anh
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Phần tiếp theo của UI
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Row(
                children: selectedWords.map((word) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      word,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: words.map((word) {
                  return InkWell(
                    onTap: () => onWordTap(word),
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                        color: selectedWords.contains(word)
                            ? Colors.blueAccent
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selectedWords.contains(word)
                              ? Colors.blue
                              : Colors.grey[300]!,
                        ),
                        boxShadow: selectedWords.contains(word)
                            ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ]
                            : null,
                      ),
                      child: Text(
                        word,
                        style: TextStyle(
                          fontSize: 18,
                          color: selectedWords.contains(word)
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                ),
                onPressed: checkAnswer,
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text(
                  'Hoàn thành',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}