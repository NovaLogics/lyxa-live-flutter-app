import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/constants/assets/app_fonts.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/constants/resources/app_dimensions.dart';
import 'package:lyxa_live/src/core/constants/resources/app_strings.dart';
import 'package:lyxa_live/src/core/constants/styles/app_styles.dart';
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
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      showPhotoSlider: true,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded) {
            return _buildHomeScreen(state);
          } else if (state is HomeError) {
            return _buildMessageScreen(errorState: state);
          }
          return _buildMessageScreen();
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
    final String debugTag = (HomeScreen).toString();
    ErrorHandler.handleError(
      error,
      tag: debugTag,
      customMessage: message,
      onRetry: () => _refresh,
    );
  }

  void _hideKeyboard() => FocusScope.of(context).unfocus();

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    _homeCubit.getAllPosts();
  }

  Widget _buildHomeScreen(HomeLoaded state) {
    if (state.errorMessage != null) {
      _handleErrorToast(state.errorMessage!);
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            backgroundColor: Theme.of(context).colorScheme.surface,
            toolbarHeight: AppDimens.size48,
            floating: true,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: AppDimens.size12,
                bottom: AppDimens.size8,
              ),
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
            actions: [
              RefreshButtonUnit(
                onRefresh: _homeCubit.getAllPosts,
              ),
            ],
          ),
          state.posts.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildMessageScreen(
                    message: AppStrings.noPostAvailableError,
                  ),
                )
              : _buildPostList(context, state.posts),
        ],
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
            currentUser: _profileService.profileEntity,
            onDeletePressed: () => _deletePost(post),
          );
        },
        childCount: postList.length,
      ),
    );
  }

  Widget _buildMessageScreen({String? message = '', HomeError? errorState}) {
    if (errorState != null) {
      _handleExceptionMessage(
        error: errorState.error,
        message: errorState.message,
      );
      message = errorState.message;
    }
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
