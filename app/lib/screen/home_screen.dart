import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_master_uet/widgets/app_bar.dart';
import 'package:english_master_uet/widgets/custom_drawer.dart';
import 'package:english_master_uet/widgets/bottom_app_bar.dart';
import 'package:english_master_uet/screen/statistical_screen.dart';
import 'package:english_master_uet/screen/progress.dart';
import 'package:english_master_uet/screen/flashcard/flashcard_screen.dart'; // Giả sử bạn có màn hình này

class AppState extends ChangeNotifier {
  String _currentTitle = "Home";
  Widget _currentBody = ProgressScreen();

  String get currentTitle => _currentTitle;
  Widget get currentBody => _currentBody;

  void updateScreen(String newTitle, Widget newBody) {
    _currentTitle = newTitle;
    _currentBody = newBody;
    notifyListeners();
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          appBar: const AppBarScreen(),
          body: appState.currentBody,
          drawer: const CustomDrawer(),
          bottomNavigationBar: const BottomAppBarWidget(),
        );
      },
    );
  }
}