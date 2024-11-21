import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lyxa_live/src/app.dart';
import 'package:lyxa_live/src/config/firebase_options.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/utils/hive_helper.dart';

void main() async {
  // Ensures all Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Run the setup process
  await setupFirebase();

  await setupHive();

  setupServiceLocator();

  // Launch the app
  startApp();
}

Future<void> setupFirebase() async {
  // Initializes Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> setupHive() async {
  await Hive.initFlutter(); // Initialize Hive
  final hiveHelper = HiveHelper();
  await hiveHelper.initialize();
}

void startApp() {
  // Starts the app by running the root widget
  runApp(LyxaApp());
}
