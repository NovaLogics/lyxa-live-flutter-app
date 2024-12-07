import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lyxa_live/src/core/constants/assets/app_icons.dart';
import 'package:lyxa_live/src/core/dependency_injection/service_locator.dart';
import 'package:lyxa_live/src/core/constants/resources/app_colors.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user_entity.dart';
import 'package:lyxa_live/src/features/home/presentation/screens/home_screen.dart';
import 'package:lyxa_live/src/features/post/presentation/screens/upload_post_screen.dart';
import 'package:lyxa_live/src/features/profile/presentation/cubits/self_profile_cubit.dart';
import 'package:lyxa_live/src/features/profile/presentation/screens/self_profile_screen.dart';
import 'package:lyxa_live/src/features/search/ui/screens/search_screen.dart';
import 'package:lyxa_live/src/features/settings/ui/screens/settings_screen.dart';
import 'package:lyxa_live/src/shared/widgets/bottom_navigation_bar/nav_bar_custom_painter.dart';
import 'package:lyxa_live/src/shared/widgets/bottom_navigation_bar/rounded_corners_fab.dart';

class ScreenIndex {
  static const int home = 0;
  static const int search = 1;
  static const int uploadPost = 2;
  static const int settings = 3;
  static const int selfProfile = 4;
}

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
  final SelfProfileCubit _selfProfileCubit = getIt<SelfProfileCubit>();

  final GlobalKey<SearchScreenState> _searchScreenKey =
      GlobalKey<SearchScreenState>();
  final GlobalKey<UploadPostScreenState> _postScreenKey =
      GlobalKey<UploadPostScreenState>();

  int _currentIndex = ScreenIndex.home;

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
    _setBottomBarIndex(ScreenIndex.home);
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
    final Color color = Theme.of(context).colorScheme.onTertiaryFixedVariant;
    final double width =
        kIsWeb ? AppDimens.containerSize430 : MediaQuery.of(context).size.width;
    const double height = AppDimens.size56;

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
                  kIsWeb ? 0.5 : AppDimens.size16,
                ),
              ),
              _buildFAB(kIsWeb),
              _buildNavigationBarIcons(width, height, color, kIsWeb),
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
          ScreenIndex.home,
          selectedColor,
          AppIcons.homeOutlined,
          Icons.home_filled,
          isWeb,
        ),
        _buildNavigationBarIcon(
          ScreenIndex.search,
          selectedColor,
          AppIcons.searchOutlined,
          Icons.saved_search,
          isWeb,
        ),
        Container(width: width * 0.20),
        _buildNavigationBarIcon(
          ScreenIndex.settings,
          selectedColor,
          AppIcons.settingsOutlinedStyle2,
          Icons.dashboard_sharp,
          isWeb,
        ),
        _buildNavigationBarIcon(
          ScreenIndex.selfProfile,
          selectedColor,
          AppIcons.profileOutlined,
          Icons.person_rounded,
          isWeb,
          onTap: () {
            _selfProfileCubit.loadSelfProfileById(
              userId: widget.appUser.uid,
            );
            _setBottomBarIndex(ScreenIndex.selfProfile);
          },
        ),
      ],
    );
  }

  Widget _buildFAB(bool isWebPlatform) {
    return Center(
      heightFactor: 0.6,
      child: RoundedCornerFAB(
        onPressed: () => _setBottomBarIndex(ScreenIndex.uploadPost),
        child: _buildIcon(
          ScreenIndex.uploadPost,
          AppColors.deepPurple200,
          AppIcons.addPostOutlinedStyle3,
          Icons.add_photo_alternate_outlined,
          isWebPlatform,
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

    color = isSelected ? Theme.of(context).colorScheme.inversePrimary : color;

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
