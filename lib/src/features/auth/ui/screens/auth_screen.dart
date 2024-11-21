import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/scrollable_scaffold.dart';
import 'package:lyxa_live/src/features/auth/ui/screens/login_screen.dart';
import 'package:lyxa_live/src/features/auth/ui/screens/register_screen.dart';

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
              onToggle: _toggleAuthenticationPage,
            )
          : RegisterScreen(
              onToggle: _toggleAuthenticationPage,
            ),
    );
  }

  /// Toggles between the login and register pages
  void _toggleAuthenticationPage() {
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
