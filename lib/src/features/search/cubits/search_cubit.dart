import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/features/search/cubits/search_state.dart';
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
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    final userSearchResult = await _searchUsers(queryText: query);

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

  void formatQuery(String query){
     if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
  }

  void _handleErrors(
      {required Result result, String? prefixMessage, String? tag}) {
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
