import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/features/home/cubits/home_state.dart';
import 'package:lyxa_live/src/features/post/cubits/post_state.dart';
import 'package:lyxa_live/src/features/post/domain/repositories/post_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';
import 'package:lyxa_live/src/shared/widgets/toast_messenger_unit.dart';

class HomeCubit extends Cubit<HomeState> {
  static const String debugTag = 'PostCubit';
  final PostRepository _postRepository;

  HomeCubit({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(HomeInitial());


 Future<void> getAllPosts() async {
    _showLoading(AppStrings.loadingMessage);

    final getPostsResult = await _postRepository.getAllPosts();

    switch (getPostsResult.status) {
      case Status.success:
        emit(HomeLoaded(getPostsResult.data ?? List.empty()));
        break;

      case Status.error:
        _handleErrors(
          result: getPostsResult,
          tag: '$debugTag: getAllPosts()',
        );
        break;
    }
    _hideLoading();
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
      emit(PostErrorToast(result.getFirebaseAlert()));
    }
    // GENERIC ERROR
    else if (result.isGenericError()) {
      _handleExceptionMessage(error:  result.getGenericErrorData());
    }
    // KNOWN ERRORS
    else if (result.isMessageError()) {
      _handleExceptionMessage(message:  result.getMessageErrorAlert());
    }
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

}
