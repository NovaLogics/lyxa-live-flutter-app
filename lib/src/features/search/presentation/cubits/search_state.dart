import 'package:lyxa_live/src/features/profile/domain/entities/profile_user_entity.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<ProfileUserEntity?> users;

  SearchLoaded(this.users);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
