import 'package:flutter/material.dart';

class ScrollableScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget body;

  const ScrollableScaffold({
    super.key,
    this.appBar,
    this.drawer,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBar,
      drawer: drawer,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 430,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: body,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
