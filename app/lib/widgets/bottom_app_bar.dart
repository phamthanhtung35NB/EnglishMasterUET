import 'package:flutter/material.dart';
import 'package:english_master_uet/screen/home_screen.dart';
// import 'package:english_master_uet/screen/';

import 'package:english_master_uet/screen/progress.dart';
class BottomAppBarWidget extends StatelessWidget {
  const BottomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            onPressed: () {
              // chuyen den man hinh home
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProgressScreen()),
              );
              //icon là hình ảnh trong assets
            },
            // chỉnh px của icon
            iconSize: 25,
            icon: Image.asset('assets/images/home.png'),
          ),
          IconButton(
              onPressed: () {
                // chuyen den man hinh report
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const ErrorWarning()),
                // );
              },iconSize: 25,
              icon: Image.asset('assets/images/flashcard.png')),
          IconButton(
              onPressed: () {
                // chuyen den man hinh report
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const ErrorWarning()),
                // );
              },iconSize: 25,
              icon: Image.asset('assets/images/notebook.png')),
          IconButton(
              onPressed: () {
                // chuyen den man hinh report
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const ErrorWarning()),
                // );
              },iconSize: 25,
              icon: Image.asset('assets/images/translate.png')),
        ],
      ),
    );
  }
}
