import 'package:flutter/material.dart';
import 'package:lyxa_live/constants/app_strings.dart';
import 'package:lyxa_live/features/home/presentation/components/drawer_unit.dart';
import 'package:lyxa_live/features/post/presentation/screens/upload_post_screen.dart';

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
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          AppStrings.appName,
        ),
        actions: [
          // Upload new post button
          IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UploadPostScreen(),
                )),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: const DrawerUnit(),
    );
  }
}
