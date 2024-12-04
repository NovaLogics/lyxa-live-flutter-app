import 'package:lyxa_live/src/features/post/domain/entities/post_entity.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<PostEntity> posts;
  final String? errorMessage;

  HomeLoaded({required this.posts, this.errorMessage});
}

class HomeError extends HomeState {
  final Object? error;
  final String? message;
  HomeError({this.message, this.error});
}
