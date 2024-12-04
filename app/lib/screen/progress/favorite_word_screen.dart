import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/user_progress.dart';
import '../../model/learned_word.dart';

class FavoriteWordsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProgress = context.watch<UserProgress>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Từ vựng yêu thích'),
        elevation: 0,
      ),
      body: userProgress.favoriteWords.isEmpty
          ? Center(
        child: Text(
          'Bạn chưa có từ vựng yêu thích',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: userProgress.favoriteWords.length,
        itemBuilder: (context, index) {
          final LearnedWord word = userProgress.favoriteWords[index];

          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              title: Text(
                word.word,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                word.meaning,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  // Remove from favorites
                  userProgress.toggleWordFavorite(word);
                },
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Divider(),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chủ đề: ${word.topic}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            'Ngày học: ${word.learnedDate.toLocal().toString().split(' ')[0]}',
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
