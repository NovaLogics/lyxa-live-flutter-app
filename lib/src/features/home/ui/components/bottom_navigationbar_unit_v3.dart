import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lyxa_live/src/core/assets/app_icons.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';

class BottomNavigationBarUnitV3 extends StatefulWidget {
  final Widget homeScreen;
  final Widget profileScreen;
  final Widget searchScreen;
  final Widget settingsScreen;
  final Widget newPostScreen;

  const BottomNavigationBarUnitV3({
    super.key,
    required this.homeScreen,
    required this.profileScreen,
    required this.searchScreen,
    required this.settingsScreen,
    required this.newPostScreen,
  });

  @override
  State<BottomNavigationBarUnitV3> createState() =>
      _BottomNavigationBarUnitState();
}

class _BottomNavigationBarUnitState extends State<BottomNavigationBarUnitV3> {
  int _currentIndex = 0;

  bool _isWebPlatform() {
    return MediaQueryData.fromView(WidgetsBinding.instance.window).size.width >
        600;
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).colorScheme.onSecondary;
    // FocusScope.of(context).unfocus();

    // Screen list to handle navigation.
    final screens = [
      widget.homeScreen,
      widget.searchScreen,
      widget.newPostScreen,
      widget.settingsScreen,
      widget.profileScreen,
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        // backgroundColor: Theme.of(context).colorScheme.surface,
        color: Theme.of(context).colorScheme.surface,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          CurvedNavigationBarItem(
            child: _buildIcon(
              0,
              selectedColor,
              AppIcons.homeOutlined,
              Icons.home_rounded,
            ),
            label: AppStrings.titleHome,
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.search),
            label: 'Search',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.newspaper),
            label: 'Feed',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.perm_identity),
            label: 'Personal',
          ),
        ],
      ),
    );

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Theme.of(context).colorScheme.onError.withOpacity(0.7),
        selectedItemColor: selectedColor,
        unselectedItemColor: AppColors.grayNeutral,
        selectedLabelStyle: const TextStyle(
          fontSize: 0,
        ),
        elevation: 2.0,
        type: BottomNavigationBarType.fixed,
        items: [
          // HOME
          BottomNavigationBarItem(
            icon: _buildIcon(
              0,
              selectedColor,
              AppIcons.homeOutlined,
              Icons.home_rounded,
            ),
            tooltip: AppStrings.titleHome,
            label: AppStrings.titleHome,
          ),
          // SEARCH
          BottomNavigationBarItem(
            icon: _buildIcon(
              1,
              selectedColor,
              AppIcons.searchOutlined,
              Icons.search_rounded,
            ),
            tooltip: AppStrings.titleSearch,
            label: AppStrings.titleSearch,
          ),
          // ADD POST
          BottomNavigationBarItem(
            icon: _buildIcon(
              2,
              selectedColor,
              AppIcons.addPostOutlinedStyle2,
              Icons.add_box_outlined,
              isHighlight: true,
            ),
            tooltip: AppStrings.titlePost,
            label: AppStrings.titlePost,
          ),
          // SETTINGS
          BottomNavigationBarItem(
            icon: _buildIcon(
              3,
              selectedColor,
              AppIcons.settingsOutlinedStyle2,
              Icons.settings_rounded,
            ),
            tooltip: AppStrings.titleSettings,
            label: AppStrings.titleSettings,
          ),
          // PROFILE
          BottomNavigationBarItem(
            icon: _buildIcon(
              4,
              selectedColor,
              AppIcons.profileOutlined,
              Icons.person_rounded,
            ),
            tooltip: AppStrings.titleProfile,
            label: AppStrings.titleProfile,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(
    int index,
    Color color,
    String iconMobile,
    IconData iconWeb, {
    bool isHighlight = false,
  }) {
    if (_currentIndex != index) color = AppColors.grayNeutral;
    final isWeb = _isWebPlatform();
    double size = isHighlight ? AppDimens.size28 : AppDimens.size24;
    return isWeb
        ? Icon(
            iconWeb,
            color: color,
          )
        : SvgPicture.asset(
            iconMobile,
            colorFilter: ColorFilter.mode(
              color,
              BlendMode.srcIn,
            ),
            width: size,
            height: size,
          );
  }
}
