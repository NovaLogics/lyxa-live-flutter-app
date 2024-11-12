import 'package:lyxa_live/src/features/profile/domain/entities/profile_user.dart';

abstract class SearchRepository {
  Future<List<ProfileUser?>> searchUsers(String query);
}
