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
import 'package:lyxa_live/src/features/home/ui/components/refresh_button_unit.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post_entity.dart';
import 'package:lyxa_live/src/features/profile/data/services/profile_service.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';
import 'package:lyxa_live/src/shared/widgets/post_tile/post_tile_unit.dart';
import 'package:lyxa_live/src/shared/widgets/responsive/constrained_scaffold.dart';
import 'package:lyxa_live/src/shared/widgets/toast_messenger_unit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String debugTag = 'HomeScreen';
  late final HomeCubit _homeCubit;
  late final ProfileService _profileService;

  @override
  void initState() {
    super.initState();
    _initScreen();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      //  appBar: _buildAppBar(context),
      showPhotoSlider: true,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded) {
            if (state.errorMessage != null) {
              _handleErrorToast(state.errorMessage!);
            }
            return _buildScreen(state.posts);
          } else if (state is HomeError) {
            _handleExceptionMessage(
              error: state.error,
              message: state.message,
            );
            return _buildDisplayMsgScreen1(message: state.message);
          }
          return _buildDisplayMsgScreen1();
        },
      ),
    );
  }

  void _initScreen() async {
    _profileService = getIt<ProfileService>();

    _homeCubit = getIt<HomeCubit>();
    _homeCubit.getAllPosts();
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

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    _homeCubit.getAllPosts();
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.3),
      title: Text(
        AppStrings.homeTitle,
        style: AppStyles.textAppBarStatic.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          letterSpacing: AppDimens.letterSpacingPT01,
          fontWeight: FontWeight.w600,
          fontFamily: AppFonts.elMessiri,
        ),
      ),
      toolbarHeight: AppDimens.size44,
      actions: [
        RefreshButtonUnit(
          onRefresh: _homeCubit.getAllPosts,
        ),
      ],
    );
  }

  Widget _buildScreen(List<PostEntity> postList) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: AppDimens.size52,
          floating: false,
          pinned: false,
          actions: [
            RefreshButtonUnit(
              onRefresh: _homeCubit.getAllPosts,
            ),
          ],
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor:
              Theme.of(context).colorScheme.surface.withOpacity(0.3),
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.all(AppDimens.size12),
            title: Text(
              AppStrings.homeTitle,
              style: AppStyles.textAppBarStatic.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                letterSpacing: AppDimens.letterSpacingPT01,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.elMessiri,
              ),
            ),
          ),
        ),
        postList.isEmpty
            ? _buildDisplayMsgScreen(
                context,
                message: AppStrings.noPostAvailableError,
              )
            : _buildPostList(context, postList),
      ],
    );
  }

  Widget _buildDisplayMsgScreen(BuildContext context, {String? message}) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text(
          message ?? '',
          style: AppStyles.titleSecondary.copyWith(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildPostList(BuildContext context, List<PostEntity> postList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = postList[index];
          return PostTileUnit(
            post: post,
            currentUser: _profileService
                .profileEntity, // Replace with your current user data
            onDeletePressed: () => _deletePost(post),
          );
        },
        childCount: postList.length,
      ),
    );
  }

  Widget _buildPostList1(List<PostEntity> postList) {
    return (postList.isEmpty)
        ? _buildDisplayMsgScreen1(
            message: AppStrings.noPostAvailableError,
          )
        : RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: postList.length,
              itemBuilder: (context, index) {
                final post = postList[index];

                return PostTileUnit(
                  post: post,
                  currentUser: _profileService.profileEntity,
                  onDeletePressed: () => _deletePost(post),
                );
              },
            ),
          );
  }

  Widget _buildDisplayMsgScreen1({String? message = ''}) {
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
