// lib/widgets/bottom_app_bar.dart
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:english_master_uet/screen/flashcard/topic_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_master_uet/screen/home_screen.dart';
import 'package:english_master_uet/screen/progress/progress.dart';
import 'package:english_master_uet/screen/flashcard/flashcard_screen.dart';
import 'package:english_master_uet/screen/excercise/Exercises.dart';
import 'package:english_master_uet/screen/translate_screen.dart';

class BottomAppBarWidget extends StatelessWidget {
  const BottomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      style: TabStyle.react,
      items: [
        TabItem(icon: Image.asset('assets/images/home.png'), title: 'Progress'),
        TabItem(icon: Image.asset('assets/images/flashcard.png'), title: 'Chọn Chủ Đề'),
        TabItem(icon: Image.asset('assets/images/notebook.png'), title: 'Exercise'),
        TabItem(icon: Image.asset('assets/images/translate.png'), title: 'Translate'),
      ],
      initialActiveIndex: 0,
      onTap: (int index) {
        switch (index) {
          case 0:
            context.read<AppState>().updateScreen('Progress', ProgressScreen());
            break;
          case 1:
            context.read<AppState>().updateScreen('Chọn Chủ Đề', TopicSelectionScreen());
            break;
          case 2:
            context.read<AppState>().updateScreen('Exercise', const progressScreen());
            break;
          case 3:
            context.read<AppState>().updateScreen('Translate', TranslateScreen());
            break;
        }
      },
    );
  }
}