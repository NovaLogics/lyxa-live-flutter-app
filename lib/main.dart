import 'package:flutter/material.dart';

void main() {
  runApp(const LyxaApp());
}

class LyxaApp extends StatelessWidget {
  const LyxaApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(),
    );
  }
}
