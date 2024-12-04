import 'package:english_master_uet/screen/register_screen.dart';
import 'package:english_master_uet/screen/statistical_screen.dart';
import 'package:english_master_uet/screen/flashcard/topic_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:english_master_uet/screen/login_screen.dart';
import 'package:english_master_uet/screen/home_screen.dart';
import 'package:english_master_uet/config/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Import Firebase options
import 'package:english_master_uet/screen/excercise/Exercises.dart';
import 'package:english_master_uet/screen/flashcard/topic_screen.dart';
import 'package:provider/provider.dart';
import 'package:english_master_uet/widgets/bottom_app_bar.dart';
// import 'package:english_master_uet/screen/progress.dart'as progress;


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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'English Master UET',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginScreen(),
        routes: {
          '/register_screen': (context) => const RegisterScreen(), // Add this line
        },
      ),
    );
  }
}