import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/user_progress.dart';
import '../../model/learned_word.dart';

class LearnedWordsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProgress = context.watch<UserProgress>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Từ vựng đã học'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filtering functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tính năng lọc sẽ được cập nhật')),
              );
            },
          )
        ],
      ),
      body: userProgress.allLearnedWords.isEmpty
          ? Center(
        child: Text(
          'Bạn chưa học từ vựng nào',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: userProgress.allLearnedWords.length,
        itemBuilder: (context, index) {
          final LearnedWord word = userProgress.allLearnedWords[index];

          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(
                word.word,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    'Nghĩa: ${word.meaning}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Chủ đề: ${word.topic}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ngày học: ${word.learnedDate.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(
                  word.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: word.isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  userProgress.toggleWordFavorite(word);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}