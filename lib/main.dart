import 'package:advanced_quizapp/provider/quiz.dart';
import 'package:advanced_quizapp/screens/auth_screen.dart';
import 'package:advanced_quizapp/screens/home_screen.dart';
import 'package:advanced_quizapp/screens/onboarding_screen.dart';
import 'package:advanced_quizapp/screens/question_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Admin/add_quiz_screen.dart';

bool? _firstTimeOpenApp;
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _firstTimeOpenApp = prefs.getBool('onboard')?? true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=> Q(),
      child: MaterialApp(
        title: 'quiz',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white,primary: Colors.grey)
        ),
        debugShowCheckedModeBanner: false,
        home: _firstTimeOpenApp == false? OnboardingScreen() : HomeScreen(),
      ),
    );
  }
}
