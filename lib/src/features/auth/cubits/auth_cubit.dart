import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/utils/helper/firebase_error_util.dart';
import 'package:lyxa_live/src/core/utils/helper/logger.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_state.dart';

/// AuthCubit: Handles authentication state management
/// ->
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  AppUser? _currentUser;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial());

  /// Checks if a user is already authenticated
  Future<void> checkAuthentication() async {
    final AppUser? user = await _authRepository.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated(null));
    }
  }

  /// Retrieves the current authenticated user.
  AppUser? get currentUser => _currentUser;

  /// Logs in with email and password.
  Future<void> login(String email, String password) async {
    try {
      //  emit(AuthLoading());

      final user =
          await _authRepository.loginWithEmailPassword(email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
         emit(Unauthenticated(user));
      }
    } on FirebaseAuthException catch (error) {
      final errorData = FirebaseErrorUtil.getMessageFromErrorCode(error.code);
      _handleAuthError(errorData);
    } catch (error) {
      _handleAuthError(error);
    }
  }

  /// Registers a new user with email and password.
  Future<void> register(String name, String email, String password) async {
    try {
      //  emit(AuthLoading());

      final user = await _authRepository.registerWithEmailPassword(
          name, email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated(user));
      }
    } on FirebaseAuthException catch (error) {
      final errorData = FirebaseErrorUtil.getMessageFromErrorCode(error.code);
      _handleAuthError(errorData);
    } catch (error) {
      _handleAuthError(error);
    }
  }

  /// Logs out the current user.
  Future<void> logout() async {
    await _authRepository.logout();
    _currentUser = null;
    emit(Unauthenticated(null));
  }

  /// Helper ->
  /// Handles authentication errors by emitting an error state
  void _handleAuthError(dynamic error) {
    emit(AuthError(error.toString()));
    emit(Unauthenticated(null));
    Logger.logError(error.toString());
  }
}
