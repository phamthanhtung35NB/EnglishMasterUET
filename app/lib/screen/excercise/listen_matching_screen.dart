import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class listen_matching_screen extends StatelessWidget {
  const  listen_matching_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài tập nghe'),
      ),
      body: Center(
        child: Text(
          'Đây là màn hình bài tập nghe',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}