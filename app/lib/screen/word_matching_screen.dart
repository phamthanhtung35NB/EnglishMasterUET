import 'package:flutter/material.dart';

class WordMatchingScreen extends StatefulWidget {
  const WordMatchingScreen({super.key});

  @override
  _WordMatchingScreenState createState() => _WordMatchingScreenState();
}

class _WordMatchingScreenState extends State<WordMatchingScreen> {
  List<String> words = ["ấy", "cà", "ép", "cái", "chai", "Hôm", "hai", "mười"];
  List<String> selectedWords = []; // Các từ người dùng đã chọn

  void onWordTap(String word) {
    setState(() {
      if (selectedWords.contains(word)) {
        selectedWords.remove(word); // Bỏ chọn nếu đã chọn trước đó
      } else {
        selectedWords.add(word); // Thêm từ vào danh sách chọn
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài tập Nối từ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TỪ VỰC MỚI',
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
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.volume_up, size: 28, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'twelve bottles',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Khu vực nhập từ
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: selectedWords.map((word) {
                    return Text(
                      '$word ',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Các từ để chọn
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: words.map((word) {
                return GestureDetector(
                  onTap: () => onWordTap(word),
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: selectedWords.contains(word)
                          ? Colors.blue
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedWords.contains(word)
                            ? Colors.blue
                            : Colors.grey,
                      ),
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
            const Spacer(),
            // Nút hoàn thành
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý hoàn thành bài tập
                  if (selectedWords.join(" ") == "mười hai chai") {
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
                },
                child: const Text('Hoàn thành'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
