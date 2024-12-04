import 'package:lyxa_live/src/features/post/domain/entities/post_entity.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';

abstract class HomeRepository {
  Future<Result<List<PostEntity>>> getAllPosts();
}
