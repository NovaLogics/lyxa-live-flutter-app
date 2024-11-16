import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyxa_live/src/core/values/app_dimensions.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/ui/components/scrollable_scaffold.dart';
import 'package:lyxa_live/src/features/auth/ui/screens/login_screen.dart';
import 'package:lyxa_live/src/features/auth/ui/screens/register_screen.dart';
import 'package:lyxa_live/src/shared/widgets/center_loading_unit.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';

/// AuthScreen:
/// -> Displays either the Login or Register page with the ability to toggle between them
class AuthScreen extends StatefulWidget {
  final AppUser? authUser;
  final bool isLoading;

  const AuthScreen({
    super.key,
    this.authUser,
    this.isLoading = false,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoginPage = true;

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

  @override
  Widget build(BuildContext context) {
    _setStatusBarStyle();

    return Scaffold(
      body: Stack(
        children: [
          const GradientBackgroundUnit(width: AppDimens.containerSize400),
          ScrollableScaffold(
            body: _isLoginPage
                ? LoginScreen(
                    onToggle: _toggleAuthenticationPage,
                    authUser: widget.authUser,
                  )
                : RegisterScreen(
                    onToggle: _toggleAuthenticationPage,
                    authUser: widget.authUser,
                  ),
          ),
          if (widget.isLoading) const CenterLoadingUnit(),
        ],
      ),
    );
  }
}
