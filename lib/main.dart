import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lyxa_live/app.dart';
import 'package:lyxa_live/config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(LyxaApp());
}
