import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/features/search/presentation/cubits/search_state.dart';
import 'package:lyxa_live/src/features/search/domain/usecases/search_users.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';

class SearchCubit extends Cubit<SearchState> {
  static const String debugTag = 'SearchCubit';
  final SearchUsers _searchUsers;

  SearchCubit({
    required SearchUsers searchUsers,
  })  : _searchUsers = searchUsers,
        super(SearchInitial());

  Future<void> searchUsers(String query) async {
    final trimmedQuery = query.trim();

    if (!_isQueryValid(trimmedQuery)) return;

    final userSearchResult = await _searchUsers(query: trimmedQuery);

    switch (userSearchResult.status) {
      case Status.success:
        emit(SearchLoaded(userSearchResult.data ?? []));
        break;

      case Status.error:
        _handleErrors(
          result: userSearchResult,
          tag: '$debugTag: searchUsers()',
        );
        break;
    }
  }

  bool _isQueryValid(String query) {
    if (query.isEmpty) {
      emit(SearchInitial());
      return false;
    }
    return true;
  }

  void _handleErrors({
    required Result result,
    String? prefixMessage,
    String? tag,
  }) {
    // FIREBASE ERROR
    if (result.isFirebaseError()) {
      emit(SearchError(result.getFirebaseAlert()));
    }
    // GENERIC ERROR
    else if (result.isGenericError()) {
      ErrorHandler.handleError(
        result.getGenericErrorData(),
        prefixMessage: prefixMessage,
        tag: tag ?? debugTag,
        onRetry: () {},
      );
    }
    // KNOWN ERRORS
    else if (result.isMessageError()) {
      ErrorHandler.handleError(
        null,
        tag: tag ?? debugTag,
        customMessage: result.getMessageErrorAlert(),
        onRetry: () {},
      );
    }
  }
}
