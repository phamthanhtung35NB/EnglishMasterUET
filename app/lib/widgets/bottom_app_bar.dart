import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_master_uet/screen/home_screen.dart';
import 'package:english_master_uet/screen/progress.dart';
import 'package:english_master_uet/screen/flashcard_screen.dart';

class BottomAppBarWidget extends StatelessWidget {
  const BottomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            onPressed: () {
              context.read<AppState>().updateScreen(
                  'Progress',
                  ProgressScreen()
              );
            },
            iconSize: 25,
            icon: Image.asset('assets/images/home.png'),
          ),
          IconButton(
              onPressed: () {
                // context.read<AppState>().updateScreen(
                    // 'Flashcard',
                    // FlashcardScreen()
                // );
              },
              iconSize: 25,
              icon: Image.asset('assets/images/flashcard.png')
          ),
          IconButton(
              onPressed: () {
                // context.read<AppState>().updateScreen(
                //     'Notebook',
                //     NotebookScreen()
                // );
              },
              iconSize: 25,
              icon: Image.asset('assets/images/notebook.png')
          ),
          IconButton(
              onPressed: () {
                // context.read<AppState>().updateScreen(
                //     'Translate',
                //     TranslateScreen()
                // );
              },
              iconSize: 25,
              icon: Image.asset('assets/images/translate.png')
          ),
        ],
      ),
    );
  }
}