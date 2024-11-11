import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/features/post/domain/repositories/post_repository.dart';
import 'package:lyxa_live/features/post/presentation/cubits/post_state.dart';
import 'package:lyxa_live/features/storage/domain/storage_repository.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository postRepository;
  final StorageRepository storageRepository;

  PostCubit({
    required this.postRepository,
    required this.storageRepository,
  }) : super(PostInitial());
}
