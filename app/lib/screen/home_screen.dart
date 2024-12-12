import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_master_uet/widgets/app_bar.dart';
import 'package:english_master_uet/widgets/custom_drawer.dart';
import 'package:english_master_uet/widgets/bottom_app_bar.dart';
import 'package:english_master_uet/screen/statistical_screen.dart';
import 'package:english_master_uet/screen/progress/progress.dart';
import 'package:english_master_uet/screen/flashcard/flashcard_screen.dart';

import '../model/user_progress.dart';

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

class HomeScreen extends StatelessWidget { const HomeScreen({super.key}); @override Widget build(BuildContext context) { return WillPopScope( onWillPop: () async { Provider.of<UserProgress>(context, listen: false).stopStudyTime(); return true; }, child: Scaffold( appBar: const AppBarScreen(), body: Provider.of<AppState>(context).currentBody, drawer: const CustomDrawer(), bottomNavigationBar: const BottomAppBarWidget(), ), ); } }