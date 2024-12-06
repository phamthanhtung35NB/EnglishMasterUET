import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/user_progress.dart';


class CompletedTopicsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProgress = context.watch<UserProgress>();

    // Convert learned topics to a list of maps for easier display
    final completedTopics = userProgress.learnedTopics.entries.map((entry) {
      return {
        'name': entry.key,
        'totalWords': entry.value.length,
        'masteredWords': entry.value.length, // In this implementation, all words are considered mastered
        'completedDate': userProgress.allLearnedWords
            .where((word) => word.topic == entry.key)
            .map((word) => word.learnedDate)
            .reduce((a, b) => a.isAfter(b) ? a : b)
            .toLocal()
            .toString()
            .split(' ')[0], // Extract date in format YYYY-MM-DD
      };
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chủ đề đã học'),
        elevation: 0,
      ),
      body: completedTopics.isEmpty
          ? Center(
        child: Text(
          'Bạn chưa hoàn thành chủ đề nào',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: completedTopics.length,
        itemBuilder: (context, index) {
          final topic = completedTopics[index];
          final progress = 1.0; // All words are considered mastered in this implementation

          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                topic['name'] as String,
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