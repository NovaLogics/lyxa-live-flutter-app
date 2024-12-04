import 'package:lyxa_live/src/features/post/domain/entities/post_entity.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<PostEntity> posts;
  HomeLoaded(this.posts);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
