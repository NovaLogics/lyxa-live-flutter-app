import 'package:flutter/material.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/shared/widgets/toast_messenger_unit.dart';

class RefreshButtonUnit extends StatefulWidget {
  final VoidCallback onRefresh;

  const RefreshButtonUnit({super.key, required this.onRefresh});

  @override
  State<RefreshButtonUnit> createState() => _RefreshButtonUnitState();
}

class _RefreshButtonUnitState extends State<RefreshButtonUnit> {
  bool _isCooldownActive = false;

  void _handleRefresh() {
    if (_isCooldownActive) {
      _showCooldownMessage();
    } else {
      setState(() {
        _isCooldownActive = true;
      });
      widget.onRefresh();

      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          _isCooldownActive = false;
        });
      });
    }
  }

  void _showCooldownMessage() {
    ToastMessengerUnit.showErrorToastShort(
      context: context,
      message: AppStrings.refreshCooldownMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _handleRefresh,
      icon: const Icon(Icons.refresh_rounded),
      tooltip: AppStrings.refreshPosts,
    );
  }
}
