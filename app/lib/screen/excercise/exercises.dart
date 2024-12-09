import 'package:english_master_uet/screen/excercise/story_collection_creen.dart';
import 'package:english_master_uet/screen/excercise/word_matching_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_screen.dart';
import 'listen_matching_screen.dart';

class Exercises extends StatelessWidget {
  const Exercises({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildProgressCard(
                    title: 'Phần 1: Nối từ',
                    progress: 100,
                    isCompleted: true,
                    icon: Icons.link,
                    onTap: () {
                      context.read<AppState>().updateScreen('Exercise', const WordMatchingScreen());
                    },
                  ),
                  _buildProgressCard(
                    title: 'Phần 2: Nghe',
                    progress: 100,
                    isCompleted: true,
                    icon: Icons.headphones,
                    onTap: () {
                      context.read<AppState>().updateScreen('Exercise', const ListenMatchingScreen());
                    },
                  ),
                  _buildProgressCard(
                    title: 'Phần 3: Kho truyện',
                    progress: 92,
                    isCompleted: false,
                    icon: Icons.book,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryCollectionScreen(storyId: 0), // Gọi màn hình StoryCollectionScreen với storyId
                        ),
                      );
                    },
                  ),
                  _buildProgressCard(
                    title: 'Phần 4: Phát âm',
                    progress: 92,
                    isCompleted: false,
                    icon: Icons.mic,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard({
    required String title,
    required int progress,
    required bool isCompleted,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon ?? Icons.star,
                size: 32,
                color: isCompleted ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: Colors.grey[300],
                      color: isCompleted ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isCompleted
                          ? 'Hoàn thành'
                          : 'Đang hoàn thiện (${progress}%)',
                      style: TextStyle(
                        color: isCompleted ? Colors.green : Colors.orange,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
