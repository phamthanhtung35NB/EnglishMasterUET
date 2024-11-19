import 'package:flutter/material.dart';

class CompletedTopicsScreen extends StatelessWidget {
  // Mock data - thực tế sẽ lấy từ database/state management
  final List<Map<String, dynamic>> completedTopics = [
    {
      'name': 'Các từ về gia đình',
      'completedDate': '20/11/2024',
      'totalWords': 20,
      'masteredWords': 18,
    },
    {
      'name': 'Từ vựng về màu sắc',
      'completedDate': '19/11/2024',
      'totalWords': 15,
      'masteredWords': 13,
    },
    {
      'name': 'Động vật',
      'completedDate': '18/11/2024',
      'totalWords': 25,
      'masteredWords': 22,
    },
    // Thêm các chủ đề khác...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chủ đề đã học'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: completedTopics.length,
        itemBuilder: (context, index) {
          final topic = completedTopics[index];
          final progress = topic['masteredWords'] / topic['totalWords'];

          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                topic['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text('Hoàn thành: ${topic['completedDate']}'),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${topic['masteredWords']}/${topic['totalWords']} từ đã thuộc',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}