import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lyxa_live/src/app.dart';
import 'package:lyxa_live/src/config/firebase_options.dart';

void main() async {
  // Ensures all Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Run the setup process
  await setupFirebase();

  // Launch the app
  startApp();
}

Future<void> setupFirebase() async {
  // Initializes Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void startApp() {
  // Starts the app by running the root widget
  runApp(LyxaApp());
}

