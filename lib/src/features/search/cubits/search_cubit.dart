import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/features/search/domain/search_repository.dart';
import 'package:lyxa_live/src/features/search/cubits/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository searchRepository;

  SearchCubit({required this.searchRepository}) : super(SearchInitial());

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    try {
      emit(SearchLoading());
      final users = await searchRepository.searchUsers(query);
      emit(SearchLoaded(users.data ?? []));
    } catch (error) {
         emit(SearchError('Error fetch search results'));
    }
  }
}
