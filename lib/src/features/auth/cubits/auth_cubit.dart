import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/utils/hive_helper.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_state.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';

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
      emit(Unauthenticated());
    }
  }

  /// Retrieves the current authenticated user.
  AppUser? get currentUser => _currentUser;

  /// Logs in with email and password.
  Future<void> login(String email, String password) async {
    try {
      //emit(AuthLoading());
      LoadingCubit.showLoading(message: 'Loading data...');

      final user = await _authRepository.loginWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (error) {
      _handleAuthError(error);
    }
    LoadingCubit.hideLoading();
  }

  /// Registers a new user with email and password.
  Future<void> register(String name, String email, String password) async {
    try {
      emit(AuthLoading());

      final user = await _authRepository.registerWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (error) {
      _handleAuthError(error);
    }
  }

  /// Logs out the current user.
  Future<void> logout() async {
    await _authRepository.logOut();
    _currentUser = null;
    emit(Unauthenticated());
  }

  Future<AppUser?> getSavedUser({String key = HiveKeys.loginDataKey}) async {
    return await _authRepository.getSavedUser(key: key);
  }

  Future<void> saveUser({
    required AppUser user,
    String key = HiveKeys.loginDataKey,
  }) async {
    await _authRepository.saveUserToLocalStorage(user: user, key: key);
  }

  /// Helper ->
  /// Handles authentication errors by emitting an error state
  void _handleAuthError(dynamic error) {
    emit(AuthError(error.toString().replaceFirst('Exception: ', '')));
    emit(Unauthenticated());
    Logger.logError(error.toString());
  }
}
