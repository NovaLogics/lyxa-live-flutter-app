import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lyxa_live/features/auth/presentation/screens/auth_screen.dart';
import 'package:lyxa_live/features/auth/presentation/screens/login_screen.dart';
import 'package:lyxa_live/firebase_options.dart';
import 'package:lyxa_live/themes/light_mode.dart';

void main() async {
  //Firebase setup
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //run app
  runApp(const LyxaApp());
}

class LyxaApp extends StatelessWidget {
  const LyxaApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: AuthScreen(),
    );
  }
}
