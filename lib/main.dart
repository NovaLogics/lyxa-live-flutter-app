import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lyxa_live/src/app.dart';
import 'package:lyxa_live/src/config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(LyxaApp());
}
