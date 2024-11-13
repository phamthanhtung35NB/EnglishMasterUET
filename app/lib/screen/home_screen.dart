// File: lib/screen/home_screen.dart
import 'package:flutter/material.dart';
import 'package:english_master_uet/widgets/app_bar.dart';
import 'package:english_master_uet/widgets/custom_drawer.dart';
import 'package:english_master_uet/widgets/bottom_app_bar.dart';
import 'package:english_master_uet/screen/statistical_screen.dart';

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
    return const Scaffold(
      appBar: AppBarScreen(),
      body: StatisticalScreen(),
      drawer: CustomDrawer(),
      bottomNavigationBar: BottomAppBarWidget(),
    );
  }
}