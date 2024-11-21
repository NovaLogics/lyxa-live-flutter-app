import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lyxa_live/src/app.dart';
import 'package:lyxa_live/src/config/firebase_options.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/utils/hive_helper.dart';

/// Main Entry Point
/// 
/// This function handles the setup process by:
/// 1. Making sure Flutter bindings are initialized to get the engine ready
/// 2. Setting up Firebase with the correct settings for the platform
/// 3. Initializing Hive for local storage and caching
/// 4. Setting up the service locator for managing dependencies
/// 5. Launching the main user interface of the app

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  await initHive();
  initServiceLocator();

  launchApp();
}

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> initHive() async {
  await Hive.initFlutter();
  final hiveHelper = HiveHelper();
  await hiveHelper.initialize();
}

void initServiceLocator() {
    setupServiceLocator();
}

void launchApp() {
  runApp(LyxaApp());
}
