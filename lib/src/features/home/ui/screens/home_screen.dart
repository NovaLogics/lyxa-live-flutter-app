import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/assets/app_fonts.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/styles/app_styles.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/home/cubits/home_cubit.dart';
import 'package:lyxa_live/src/features/home/cubits/home_state.dart';
import 'package:lyxa_live/src/features/home/ui/components/drawer_unit.dart';
import 'package:lyxa_live/src/features/home/ui/components/refresh_button_unit.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post_entity.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';
import 'package:lyxa_live/src/shared/widgets/post_tile/post_tile_unit.dart';
import 'package:lyxa_live/src/features/post/ui/screens/upload_post_screen.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/constrained_scaffold.dart';
import 'package:lyxa_live/src/shared/widgets/toast_messenger_unit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String debugTag = 'HomeScreen';
  late final HomeCubit _homeCubit;
  ProfileUser _currentUser = ProfileUser.getGuestUser();

  @override
  void initState() {
    super.initState();
    _homeCubit = getIt<HomeCubit>();
    _initScreen();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: _buildAppBar(context),
      drawer: _buildAppDrawer(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded) {
            if (state.errorMessage != null) {
              _handleErrorToast(state.errorMessage!);
            }
            return _buildPostList(state.posts);
          } else if (state is HomeError) {
            _handleExceptionMessage(error: state.error, message: state.message);
            return _buildDisplayMsgScreen(message: state.message);
          }
          return _buildDisplayMsgScreen();
        },
      ),
    );
  }

  void _initScreen() async {
    final profileUser = await _homeCubit.getCurrentUser();

    setState(() {
      _currentUser = profileUser;
    });
    _homeCubit.getAllPostsfromServer();
  }

  void _deletePost(PostEntity post) {
    _homeCubit.deletePost(post: post);
  }

  void _handleErrorToast(String message) {
    _hideKeyboard();
    ToastMessengerUnit.showErrorToast(
      context: context,
      message: message,
    );
  }

  void _handleExceptionMessage({Object? error, String? message}) {
    _hideKeyboard();
    ErrorHandler.handleError(
      error,
      tag: debugTag,
      customMessage: message,
      onRetry: () {},
    );
  }

  void _hideKeyboard() => FocusScope.of(context).unfocus();

  void _navigateToUploadPostScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadPostScreen(profileUser: _currentUser),
      ),
    );
  }

  Widget _buildAppDrawer() {
    return DrawerUnit(user: _currentUser);
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.3),
      title: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: AppDimens.size32),
          child: Text(
            AppStrings.homeTitle,
            style: AppStyles.textAppBarStatic.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              letterSpacing: AppDimens.letterSpacingPT01,
              fontSize: AppDimens.fontSizeXXL28,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.elMessiri,
            ),
          ),
        ),
      ),
      actions: [
        RefreshButtonUnit(
          onRefresh: _homeCubit.getAllPostsfromServer,
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppDimens.size2),
          child: IconButton(
            onPressed: _navigateToUploadPostScreen,
            icon: const Icon(Icons.add_box_outlined),
            tooltip: AppStrings.addNewPost,
          ),
        ),
      ],
    );
  }

  Widget _buildPostList(List<PostEntity> postList) {
    return (postList.isEmpty)
        ? _buildDisplayMsgScreen(
            message: AppStrings.noPostAvailableError,
          )
        : ListView.builder(
            itemCount: postList.length,
            itemBuilder: (context, index) {
              final post = postList[index];
              return PostTileUnit(
                post: post,
                currentUser: _currentUser,
                onDeletePressed: () => _deletePost(post),
              );
            },
          );
  }

  Widget _buildDisplayMsgScreen({String? message = ''}) {
    Logger.logDebug(message.toString());
    return Center(
      child: Text(
        message ?? '',
        style: AppStyles.titleSecondary.copyWith(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}
