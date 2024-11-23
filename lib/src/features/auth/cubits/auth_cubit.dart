import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/utils/hive_helper.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_state.dart';
import 'package:lyxa_live/src/shared/entities/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/cubits/error_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_messages.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';

/// AuthCubit: Handles authentication state management
/// ->
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  AppUser _currentUser = AppUser.getDefaultGuestUser();

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
  Future<void> login(
    String email,
    String password,
  ) async {
    LoadingCubit.showLoading(message: AppStrings.authenticatingPleaseWait);

    final result = await _authRepository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );

    LoadingCubit.hideLoading();

    switch (result.status) {
      case Status.success:
        if (result.isDataNotEmpty()) {
          _currentUser = result.data as AppUser;

          emit(Authenticated(_currentUser));
        } else {
          emit(Unauthenticated());
        }
        break;

      case Status.errorMessage:
        emit(AuthError(getError(result.errorMessage)));
        break;

      case Status.error:
        ErrorHandler.handleError(
          result.error,
          stackTrace: null,
          onRetry: () {
            ErrorAlertCubit.hideErrorMessage();
          },
        );
        break;

      case Status.loading:
        break;
    }
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
    _currentUser = AppUser.getDefaultGuestUser();
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

  String getError(String? message) {
    if (message != null && message.isNotEmpty) {
      return message.toString().replaceFirst('Exception: ', '');
    } else {
      return ErrorMessages.authenticationError;
    }
  }
}
