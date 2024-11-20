// File: lib/screen/home_screen.dart
import 'package:english_master_uet/screen/progress.dart';
import 'package:flutter/material.dart';
import 'package:english_master_uet/widgets/app_bar.dart';
import 'package:english_master_uet/widgets/custom_drawer.dart';
import 'package:english_master_uet/widgets/bottom_app_bar.dart';
import 'package:english_master_uet/screen/statistical_screen.dart';
import 'package:english_master_uet/screen/progress.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarScreen(),
      body: ProgressScreen(),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const BottomAppBarWidget(),
    );
  }
}