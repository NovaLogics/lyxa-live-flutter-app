import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/features/search/domain/repositories/search_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';

class SearchUsers {
  final SearchRepository repository;

  SearchUsers(this.repository);

  Future<Result<List<ProfileUser?>>> call({required String query}) {
    final processedQuery = query.toLowerCase();
    return repository.searchUsers(processedQuery);
  }
}