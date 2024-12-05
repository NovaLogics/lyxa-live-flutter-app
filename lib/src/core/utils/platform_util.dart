import 'package:flutter/widgets.dart';

class PlatformUtil {
  bool isWebPlatform() {
    final MediaQueryData data = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single,
    );
    return data.size.shortestSide > 600;
  }
}
