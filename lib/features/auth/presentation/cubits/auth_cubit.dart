import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/features/auth/domain/repositories/auth_repository.dart';
import 'package:lyxa_live/features/auth/presentation/cubits/auth_state.dart';

/*
Auth Cubit: State Management
*/

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AppUser? _currentUser;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  // Check user already authenticated
  void checkAuth() async {
    final AppUser? user = await authRepository.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  // Get current user
  AppUser? get currentUser => _currentUser;

  // Login with email & password
  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());

      final user = await authRepository.loginWithEmailPassword(email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (error) {
      emit(AuthError(error.toString()));
      emit(Unauthenticated());
    }
  }

  // Register with email & password
  Future<void> register(String name, String email, String password) async {
    try {
      emit(AuthLoading());

      final user =
          await authRepository.registerWithEmailPassword(name, email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (error) {
      emit(AuthError(error.toString()));
      emit(Unauthenticated());
    }
  }

  // Logout
  Future<void> logout() async {
    authRepository.logout();
    emit(Unauthenticated());
  }
}
