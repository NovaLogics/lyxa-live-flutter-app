import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lyxa_live/src/core/assets/app_icons.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/features/home/ui/components/nav_custom_painter.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';

class BottomNavigationBarUnitV2 extends StatefulWidget {
  final Widget homeScreen;
  final Widget profileScreen;
  final Widget searchScreen;
  final Widget settingsScreen;
  final Widget newPostScreen;

  const BottomNavigationBarUnitV2({
    super.key,
    required this.homeScreen,
    required this.profileScreen,
    required this.searchScreen,
    required this.settingsScreen,
    required this.newPostScreen,
  });

  @override
  State<BottomNavigationBarUnitV2> createState() =>
      _BottomNavigationBarUnitV2State();
}

class _BottomNavigationBarUnitV2State extends State<BottomNavigationBarUnitV2> {
  int _currentIndex = 0;

  get backgroundStyle => null;

  setBottomBarIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
    final selectedColor = Theme.of(context).colorScheme.onSecondary;
    final screens = [
      widget.homeScreen,
      widget.searchScreen,
      widget.newPostScreen,
      widget.settingsScreen,
      widget.profileScreen,
    ];

    return Stack(
      children: [
        getIt<GradientBackgroundUnit>(
          param1: AppDimens.containerSize430,
          param2: BackgroundStyle.main,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              IndexedStack(
                index: _currentIndex,
                children: screens,
              ),
              //  _buildBar(context),
            ],
          ),
          bottomNavigationBar: _buildBar(context),
        ),
      ],
    );
  }

  Widget _buildBar(BuildContext context) {
    final selectedColor = Theme.of(context).colorScheme.onSecondary;
    return Row(
      children: [
        const Spacer(),
        Stack(
          children: [
            Container(
              width: 430,
              height: 80,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  CustomPaint(
                    size: Size(430, 80),
                    painter: NavCustomPainter(context),
                  ),
                  Center(
                    heightFactor: 0.6,
                    child: FloatingActionButton(
                      backgroundColor: Colors.orange,
                      child: _buildIcon(
                        3,
                        selectedColor,
                        AppIcons.settingsOutlinedStyle2,
                        Icons.settings_rounded,
                      ),
                      elevation: 0.1,
                      onPressed: () {
                        setBottomBarIndex(2); // New post action
                      },
                    ),
                  ),
                  Container(
                    width: 430,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.home,
                            color: _currentIndex == 0
                                ? Colors.orange
                                : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setBottomBarIndex(0); // Home screen
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.restaurant_menu,
                            color: _currentIndex == 1
                                ? Colors.orange
                                : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setBottomBarIndex(1); // Search screen
                          },
                        ),
                        Container(width: 430 * 0.20), // Spacer for FAB
                        IconButton(
                          icon: Icon(
                            Icons.bookmark,
                            color: _currentIndex == 2
                                ? Colors.orange
                                : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setBottomBarIndex(3); // Settings screen
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.notifications,
                            color: _currentIndex == 3
                                ? Colors.orange
                                : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setBottomBarIndex(4); // Profile screen
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Spacer(),
      ],
    );
  }

  Widget _buildIcon(
    int index,
    Color color,
    String iconMobile,
    IconData iconWeb, {
    bool isHighlight = false,
  }) {
    final isWeb = true;
    double size = isHighlight ? AppDimens.size28 : AppDimens.size24;
    return isWeb
        ? Icon(
            iconWeb,
            color: color,
          )
        : SvgPicture.asset(
            iconMobile,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            width: size,
            height: size,
          );
  }
}
