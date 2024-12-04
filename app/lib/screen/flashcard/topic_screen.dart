import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_screen.dart';
import 'flashcard_screen.dart';
import '../../data/words_data.dart';

class TopicSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topics = topicWords.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Select a Topic")),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(topics[index]),
            onTap: () {
              context.read<AppState>().updateScreen(
                'Flashcard',
                FlashcardScreen(topic: topics[index]),
              );
            },
          );
        },
      ),
    );
  }
}
