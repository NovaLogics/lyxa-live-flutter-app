import 'package:flutter/material.dart';

class BottomNavigationBarUnit extends StatefulWidget {
  final Widget homeScreen;
  final Widget profileScreen;
  final Widget searchScreen;
  final Widget settingsScreen;
  final IconData homeWebIcon, homeMobileIcon;
  final IconData profileWebIcon, profileMobileIcon;
  final IconData searchWebIcon, searchMobileIcon;
  final IconData settingsWebIcon, settingsMobileIcon;

  const BottomNavigationBarUnit({
    super.key,
    required this.homeScreen,
    required this.profileScreen,
    required this.searchScreen,
    required this.settingsScreen,
    required this.homeWebIcon,
    required this.homeMobileIcon,
    required this.profileWebIcon,
    required this.profileMobileIcon,
    required this.searchWebIcon,
    required this.searchMobileIcon,
    required this.settingsWebIcon,
    required this.settingsMobileIcon,
  });

  @override
  State<BottomNavigationBarUnit> createState() =>
      _BottomNavigationBarUnitState();
}

class _BottomNavigationBarUnitState extends State<BottomNavigationBarUnit> {
  int _currentIndex = 0;

  bool _isWebPlatform() {
    return MediaQueryData.fromView(WidgetsBinding.instance.window).size.width >
        600;
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = _isWebPlatform();

    // Screen list to handle navigation.
    final screens = [
      widget.homeScreen,
      widget.searchScreen,
      widget.profileScreen,
      widget.settingsScreen,
    ];

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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(isWeb ? widget.homeWebIcon : widget.homeMobileIcon),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(isWeb ? widget.searchWebIcon : widget.searchMobileIcon),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(isWeb ? widget.profileWebIcon : widget.profileMobileIcon),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                isWeb ? widget.settingsWebIcon : widget.settingsMobileIcon),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
