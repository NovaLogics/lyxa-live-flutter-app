import 'package:flutter/material.dart';
import 'package:lyxa_live/constants/app_strings.dart';
import 'package:lyxa_live/features/home/presentation/components/drawer_unit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.appName,
        ),
      ),
      drawer: const DrawerUnit(),
    );
  }
}
