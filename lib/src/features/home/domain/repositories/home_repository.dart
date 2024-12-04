import 'package:lyxa_live/src/features/post/domain/entities/post_entity.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user_entity.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';

abstract class HomeRepository {
  Future<Result<ProfileUser>> getCurrentAppUser();

  Future<Result<List<PostEntity>>> getAllPosts();
}
