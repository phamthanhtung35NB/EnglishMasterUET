import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_master_uet/screen/progress/progress.dart';

import 'package:english_master_uet/screen/home_screen.dart';

class AppBarScreen extends StatelessWidget implements PreferredSizeWidget {
  const AppBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
        builder: (context, appState, child) {
          return AppBar(

            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            title: Row(
              children: [
                TextButton(
                  child: Text(
                      appState.currentTitle,
                      style: const TextStyle(color: Colors.black)
                  ),
                  onPressed: () {
                    // Navigate to current screen
                  },
                )
              ],
            ),
            actions: [
              Container(
                width: 40,
                height: 40,
                color: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    // Navigate to Notifications screen
                  },
                ),
              )
            ],
          );
        }
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}