import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/features/home/cubits/home_state.dart';
import 'package:lyxa_live/src/features/post/domain/repositories/post_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  static const String debugTag = 'PostCubit';
  final PostRepository _postRepository;

  HomeCubit({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(HomeInitial());

        
}
