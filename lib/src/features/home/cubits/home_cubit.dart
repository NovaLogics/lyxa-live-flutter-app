import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/features/home/cubits/home_state.dart';
import 'package:lyxa_live/src/features/home/domain/repositories/home_repository.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_state.dart';
import 'package:lyxa_live/src/features/post/domain/entities/post_entity.dart';
import 'package:lyxa_live/src/features/profile/data/models/profile_user_model.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user_entity.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';

class HomeCubit extends Cubit<HomeState> {
  static const String debugTag = 'PostCubit';
  final PostCubit _postCubit;
  final HomeRepository _homeRepository;
  ProfileUserEntity? _currentUser;

  HomeCubit({
    required HomeRepository homeRepository,
    required PostCubit postCubit,
  })  : _homeRepository = homeRepository,
        _postCubit = postCubit,
        super(HomeInitial());

  Future<ProfileUserEntity> getCurrentUser() async {
    if (_currentUser != null) {
      return _currentUser as ProfileUserEntity;
    } else {
      return await getCurrentAppUser();
    }
  }

  Future<void> getAllPosts() async {
    await _postCubit.getAllPosts();
    emit(HomeLoaded(posts: _postCubit.postDataList));
  }

  List<PostEntity> getCachedPosts() {
    return _postCubit.postDataList;
  }

  Future<void> deletePost({
    required PostEntity post,
  }) async {
    _postCubit.locallyDeletePost(post);
    emit(HomeLoaded(posts: _postCubit.postDataList));

    final deleteResult = await _postCubit.deletePost(post: post);

    if (!deleteResult) {
      _postCubit.locallyAddPost(post);
      emit(HomeLoaded(posts: _postCubit.postDataList));
    }
  }

  Future<ProfileUserEntity> getCurrentAppUser() async {
    _showLoading(AppStrings.loadingMessage);

    final getUserResult = await _homeRepository.getCurrentAppUser();

    _hideLoading();
    switch (getUserResult.status) {
      case Status.success:
        return getUserResult.data!;

      case Status.error:
        _handleErrors(
          result: getUserResult,
          tag: '$debugTag: getAllPosts()',
        );
        return ProfileUserModel.getGuestUserAsEntity();
    }
  }

  // HELPER FUNCTIONS ▼

  void _showLoading(String message) {
    LoadingCubit.showLoading(message: message);
  }

  void _hideLoading() {
    LoadingCubit.hideLoading();
  }

  void _handleErrors(
      {required Result result, String? prefixMessage, String? tag}) {
    // FIREBASE ERROR
    if (result.isFirebaseError()) {
      emit(HomeLoaded(
        posts: (state as PostLoaded).posts,
        errorMessage: result.getFirebaseAlert(),
      ));
    }
    // GENERIC ERROR
    else if (result.isGenericError()) {
      emit(HomeError(error: result.getGenericErrorData()));
    }
    // KNOWN ERRORS
    else if (result.isMessageError()) {
      emit(HomeError(message: result.getMessageErrorAlert()));
    }
  }
}
