import 'package:english_master_uet/screen/statistical_screen.dart';
import 'package:english_master_uet/screen/topic_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:english_master_uet/screen/login_screen.dart';
import 'package:english_master_uet/screen/home_screen.dart';
import 'package:english_master_uet/config/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Import Firebase options
import 'package:english_master_uet/screen/Exercises.dart';


import 'package:english_master_uet/screen/progress.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Sử dụng Firebase options đã cấu hình
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Master UET',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TopicSelectionScreen(), // Khởi động HomeScreen
    );
  }
}
