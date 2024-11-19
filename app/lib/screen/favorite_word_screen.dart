import 'package:flutter/material.dart';

class FavoriteWordsScreen extends StatelessWidget {
  // Mock data - thực tế sẽ lấy từ database/state management
  final List<Map<String, dynamic>> favoriteWords = [
    {
      'word': 'appreciate',
      'meaning': 'đánh giá cao, cảm kích',
      'example': 'I really appreciate your help.',
      'topic': 'Giao tiếp',
      'dateAdded': '20/11/2024',
    },
    {
      'word': 'determine',
      'meaning': 'xác định, quyết định',
      'example': 'We need to determine the cause of the problem.',
      'topic': 'Công việc',
      'dateAdded': '19/11/2024',
    },
    // Thêm các từ khác...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Từ vựng yêu thích'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: favoriteWords.length,
        itemBuilder: (context, index) {
          final word = favoriteWords[index];

          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              title: Text(
                word['word'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                word['meaning'],
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              trailing: Icon(Icons.favorite, color: Colors.red),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ví dụ:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(word['example']),
                      SizedBox(height: 8),
                      Divider(),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chủ đề: ${word['topic']}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            'Thêm: ${word['dateAdded']}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}