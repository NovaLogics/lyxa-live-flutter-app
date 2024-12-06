import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lyxa_live/src/core/assets/app_icons.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_colors.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/utils/platform_util.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user_entity.dart';
import 'package:lyxa_live/src/features/home/ui/screens/home_screen.dart';
import 'package:lyxa_live/src/features/post/ui/screens/upload_post_screen.dart';
import 'package:lyxa_live/src/features/profile/cubits/self_profile_cubit.dart';
import 'package:lyxa_live/src/features/profile/ui/screens/self_profile_screen.dart';
import 'package:lyxa_live/src/features/search/ui/screens/search_screen.dart';
import 'package:lyxa_live/src/features/settings/ui/screens/settings_screen.dart';
import 'package:lyxa_live/src/shared/widgets/bottom_navigation_bar/nav_bar_custom_painter.dart';
import 'package:lyxa_live/src/shared/widgets/bottom_navigation_bar/rounded_corners_fab.dart';

class LyxaNavigationScreens extends StatefulWidget {
  final AppUserEntity appUser;

  const LyxaNavigationScreens({
    super.key,
    required this.appUser,
  });

  @override
  State<LyxaNavigationScreens> createState() => _LyxaNavigationScreensState();
}

class _LyxaNavigationScreensState extends State<LyxaNavigationScreens> {
  late final List<Widget> _screens;
  final PlatformUtil _platformUtil = getIt<PlatformUtil>();
  final SelfProfileCubit _selfProfileCubit = getIt<SelfProfileCubit>();

  final GlobalKey<SearchScreenState> _searchScreenKey =
      GlobalKey<SearchScreenState>();
  final GlobalKey<UploadPostScreenState> _postScreenKey =
      GlobalKey<UploadPostScreenState>();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
    _selfProfileCubit.loadSelfProfileById(userId: widget.appUser.uid);
  }

  @override
  void dispose() {
    _screens.clear();
    super.dispose();
  }

  void _initializeScreens() {
    _screens = [
      const HomeScreen(),
      SearchScreen(key: _searchScreenKey),
      UploadPostScreen(
        key: _postScreenKey,
        onPostUploaded: _onPostUploaded,
      ),
      const SettingsScreen(),
      const SelfProfileScreen(),
    ];
  }

  void _onPostUploaded() {
    _setBottomBarIndex(0);
  }

  void _setBottomBarIndex(int index) {
    setState(() {
      _currentIndex = index;
      _searchScreenKey.currentState?.updateFocusState();
      _postScreenKey.currentState?.updateFocusState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final bool isWeb = _platformUtil.isWebPlatform();
    final Color selectedColor = Theme.of(context).colorScheme.onPrimary;
    final double width =
        isWeb ? AppDimens.containerSize430 : MediaQuery.of(context).size.width;
    const double height = 56.0;

    return Row(
      children: [
        const Spacer(),
        SizedBox(
          width: width,
          height: height,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              CustomPaint(
                size: Size(width, height),
                painter: NavBarCustomPainter(
                  context,
                  isWeb ? 0.5 : AppDimens.size16,
                ),
              ),
              _buildFAB(),
              _buildNavigationBarIcons(width, height, selectedColor, isWeb),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildNavigationBarIcons(
      double width, double height, Color selectedColor, bool isWeb) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavigationBarIcon(
            0, selectedColor, AppIcons.homeOutlined, Icons.home_rounded, isWeb),
        _buildNavigationBarIcon(1, selectedColor, AppIcons.searchOutlined,
            Icons.search_rounded, isWeb),
        Container(width: width * 0.20),
        _buildNavigationBarIcon(3, selectedColor,
            AppIcons.settingsOutlinedStyle2, Icons.settings_rounded, isWeb),
        _buildNavigationBarIcon(4, selectedColor, AppIcons.profileOutlined,
            Icons.person_rounded, isWeb, onTap: () {
          _selfProfileCubit.loadSelfProfileById(userId: widget.appUser.uid);
          _setBottomBarIndex(4);
        }),
      ],
    );
  }

  Widget _buildFAB() {
    return Center(
      heightFactor: 0.6,
      child: RoundedCornerFAB(
        onPressed: () => _setBottomBarIndex(2),
        child: _buildIcon(
          2,
          AppColors.deepPurple200,
          AppIcons.addPostOutlinedStyle3,
          Icons.add_photo_alternate_outlined,
          true,
          isHighlight: true,
        ),
      ),
    );
  }

  Widget _buildNavigationBarIcon(
    int index,
    Color color,
    String iconMobile,
    IconData iconWeb,
    bool isWebPlatform, {
    VoidCallback? onTap,
  }) {
    return IconButton(
      icon: _buildIcon(
        index,
        color,
        iconMobile,
        iconWeb,
        isWebPlatform,
      ),
      onPressed: onTap ?? () => _setBottomBarIndex(index),
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
    final double size =
        isHighlight ? AppDimens.size32 : AppDimens.actionIconSize26;
    final isSelected = _currentIndex == index;

    color = isSelected ? AppColors.whiteLight : color;

    return isWebPlatform
        ? Icon(iconWeb, color: color, size: size)
        : SvgPicture.asset(
            iconMobile,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            width: size,
            height: size,
          );
  }
}
