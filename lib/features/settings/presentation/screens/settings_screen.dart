import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/app.dart';
import 'package:lyxa_live/themes/theme_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();

    bool isDarkMode = themeCubit.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Dark Mode"),
            trailing: CupertinoSwitch(
              value: isDarkMode,
              onChanged: (value) {
                themeCubit.toggleTheme();
              },
            ),
          )
        ],
      ),
    );
  }
}