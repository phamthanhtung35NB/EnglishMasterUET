import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../home_screen.dart';
import 'flashcard_screen.dart';
import '../../data/words_data.dart';
import '../../model/word.dart';

class TopicSelectionScreen extends StatelessWidget {
  final Map<String, String> topicIcons = {
    "Du Lịch": "✈️",
    "Công Nghệ": "💻",
    "Ẩm Thực": "🍽️",
    "Thể Thao": "🏆",
    "Văn Hóa": "🌍",
    "Sức Khỏe": "❤️",
    "Giáo Dục": "📚",
    "Nghệ Thuật": "🎨",
    "Môi Trường": "🌿",
    "Kinh Doanh": "💼"
  };

  // Đảo các từ trong topic
  List<Word> _shuffleWords(String topic) {
    List<Word> words = List.from(topicWords[topic]!);
    final random = Random();

    for (int i = words.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      final temp = words[i];
      words[i] = words[j];
      words[j] = temp;
    }

    return words;
  }

  @override
  Widget build(BuildContext context) {
    final topics = topicWords.keys.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chọn Chủ Đề'),
        backgroundColor: Colors.blue.shade50,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: topics.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Text(
                  topicIcons[topics[index]] ?? '📖',
                  style: const TextStyle(fontSize: 32),
                ),
                title: Text(
                  topics[index],
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18),
                ),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                onTap: () {
                  final shuffledWords = _shuffleWords(topics[index]);
                  topicWords[topics[index]] = shuffledWords;

                  context.read<AppState>().updateScreen(
                        topics[index],
                        FlashcardScreen(topic: topics[index]),
                      );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
