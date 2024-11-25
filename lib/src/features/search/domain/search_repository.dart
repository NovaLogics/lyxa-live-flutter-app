import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';

abstract class SearchRepository {
  Future<Result<List<ProfileUser?>>> searchUsers(String query);
}
