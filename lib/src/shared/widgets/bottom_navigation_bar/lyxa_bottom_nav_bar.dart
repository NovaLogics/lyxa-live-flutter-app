import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lyxa_live/src/core/assets/app_icons.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/utils/platform_util.dart';
import 'package:lyxa_live/src/shared/widgets/bottom_navigation_bar/nav_custom_painter.dart';
import 'package:lyxa_live/src/shared/widgets/bottom_navigation_bar/rounded_corners_fab.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';

class LyxaBottomNavBar extends StatefulWidget {
  final Widget homeScreen;
  final Widget profileScreen;
  final Widget searchScreen;
  final Widget settingsScreen;
  final Widget newPostScreen;

  const LyxaBottomNavBar({
    super.key,
    required this.homeScreen,
    required this.profileScreen,
    required this.searchScreen,
    required this.settingsScreen,
    required this.newPostScreen,
  });

  @override
  State<LyxaBottomNavBar> createState() => _LyxaBottomNavBarState();
}

class _LyxaBottomNavBarState extends State<LyxaBottomNavBar> {
  final _platformUtil = getIt<PlatformUtil>();
  int _currentIndex = 0;

  setBottomBarIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Stack(
            children: [
              IndexedStack(
                index: _currentIndex,
                children: screens,
              ),
            ],
          ),
          bottomNavigationBar: _buildBar(context),
        ),
      ],
    );
  }

  Widget _buildBar(BuildContext context) {
    final isWebPlatform = _platformUtil.isWebPlatform();
    final selectedColor = Theme.of(context).colorScheme.onPrimary;
    final Size size = MediaQuery.of(context).size;
    final sizeWidth = isWebPlatform ? AppDimens.containerSize430 : size.width;
    const sizeHeight = 56.0;

    return Row(
      children: [
        const Spacer(),
        Stack(
          children: [
            SizedBox(
              width: sizeWidth,
              height: sizeHeight,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  CustomPaint(
                    size: Size(sizeWidth, sizeHeight),
                    painter: NavCustomPainter(context),
                  ),

                  // ADD POST
                  Center(
                      heightFactor: 0.6,
                      child: RoundedCornerFAB(
                        onPressed: () {
                          setBottomBarIndex(2);
                        },
                        child: _buildIcon(
                          2,
                          selectedColor,
                          AppIcons.addPostOutlinedStyle3,
                          Icons.add_photo_alternate_outlined,
                          isWebPlatform,
                          isHighlight: true,
                        ),
                      )),

                  // HOME
                  SizedBox(
                    width: sizeWidth,
                    height: sizeHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: _buildIcon(
                            0,
                            selectedColor,
                            AppIcons.homeOutlined,
                            Icons.home_rounded,
                            isWebPlatform,
                          ),
                          onPressed: () {
                            setBottomBarIndex(0);
                          },
                        ),

                        // SEARCH
                        IconButton(
                          icon: _buildIcon(
                            1,
                            selectedColor,
                            AppIcons.searchOutlined,
                            Icons.search_rounded,
                            isWebPlatform,
                          ),
                          onPressed: () {
                            setBottomBarIndex(1);
                          },
                        ),

                        // Spacer for FAB
                        Container(width: sizeWidth * 0.20),

                        // SETTINGS
                        IconButton(
                          icon: _buildIcon(
                            3,
                            selectedColor,
                            AppIcons.settingsOutlinedStyle2,
                            Icons.settings_rounded,
                            isWebPlatform,
                          ),
                          onPressed: () {
                            setBottomBarIndex(3);
                          },
                        ),

                        // PROFILE
                        IconButton(
                          icon: _buildIcon(
                            4,
                            selectedColor,
                            AppIcons.profileOutlined,
                            Icons.person_rounded,
                            isWebPlatform,
                          ),
                          onPressed: () {
                            setBottomBarIndex(4);
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
        const Spacer(),
      ],
    );
  }

  Widget _buildIcon(
    int index,
    Color color,
    String iconMobile,
    IconData iconWeb,
    bool isWebPlatform, {
    bool isHighlight = false,
  }) {
    if (_currentIndex != index) color = AppColors.grayDark;

    double size = isHighlight ? AppDimens.size28 : AppDimens.size24;
    if (isHighlight) {
      if (_currentIndex == index) {
        color = AppColors.whiteLight;
      } else {
        color = AppColors.deepPurple200;
      }
    }

    return isWebPlatform
        ? Icon(
            iconWeb,
            color: color,
            size: size,
          )
        : SvgPicture.asset(
            iconMobile,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            width: size,
            height: size,
          );
  }
}
