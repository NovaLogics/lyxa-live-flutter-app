import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/scrollable_scaffold.dart';
import 'package:lyxa_live/src/features/auth/presentation/screens/login_screen.dart';
import 'package:lyxa_live/src/features/auth/presentation/screens/register_screen.dart';

/// AuthScreen:
/// -> Displays either the Login or Register page with the ability to toggle between them
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoginPage = true;

  @override
  Widget build(BuildContext context) {
    _setStatusBarStyle();

    return ScrollableScaffold(
      backgroundStyle: BackgroundStyle.auth,
      body: _isLoginPage
          ? LoginScreen(
              onToggleScreen: _toggleAuthScreen,
            )
          : RegisterScreen(
              onToggleScreen: _toggleAuthScreen,
            ),
    );
  }

  void _toggleAuthScreen() {
    setState(() {
      _isLoginPage = !_isLoginPage;
    });
  }

  /// Set status bar color styles
  void _setStatusBarStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }
}
