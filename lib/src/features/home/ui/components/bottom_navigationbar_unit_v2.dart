import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lyxa_live/src/core/assets/app_icons.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/features/home/ui/components/diamond_fab.dart';
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

  bool _isWebPlatform() {
    final MediaQueryData data = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single,
    );
    return data.size.shortestSide > 600;
  }

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
          backgroundColor: Colors.transparent,
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
    final selectedColor = Theme.of(context).colorScheme.onPrimary;
    final Size size = MediaQuery.of(context).size;
    final sizeWidth =
        _isWebPlatform() ? AppDimens.containerSize430 : size.width;
    const sizeHeight = 80.0;
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
                      heightFactor: 0.7,
                      child: DiamondFAB(
                        onPressed: () {
                          setBottomBarIndex(2);
                        },
                        child: _buildIcon(
                          2,
                          selectedColor,
                          AppIcons.addPostOutlinedStyle2,
                          Icons.add_photo_alternate_outlined,
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
    IconData iconWeb, {
    bool isHighlight = false,
  }) {
    if (_currentIndex != index) color = AppColors.grayDark;
    final isWeb = _isWebPlatform();
    double size = isHighlight ? AppDimens.size28 : AppDimens.size24;
    if (isHighlight) {
      if (_currentIndex == index) {
        color = AppColors.whiteLight;
      } else {
        color = AppColors.blackDark;
      }
    }

    return isWeb
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
