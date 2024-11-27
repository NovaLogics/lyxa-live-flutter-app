import 'package:flutter/widgets.dart';

Widget addVerticalSpacing(double height) {
  return SizedBox(height: height);
}

Widget addSpacing({double? height, double? width}) {
  return SizedBox(
    height: height ?? 0.0,
    width: width ?? 0.0,
  );
}
