import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_state.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';

/// AuthCubit: Handles authentication state management
/// ->
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  AppUser _currentUser = AppUser.getDefaultGuestUser();

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial());

  /// Retrieves the current authenticated user.
  AppUser? get currentUser => _currentUser;

  /// (ƒ) :: Check Authentication
  ///
  /// Emits [Authenticated] if a user is found, otherwise [Unauthenticated].
  Future<void> checkAuthentication() async {
    final result = await _authRepository.getCurrentUser();

    switch (result.status) {
      case Status.success:
        if (result.isDataNotNull()) {
          _currentUser = result.data as AppUser;
          emit(Authenticated(_currentUser));
        } else {
          // No user logged in
          emit(Unauthenticated());
        }
        break;

      case Status.error:
        // FIREBASE ERROR
        if (result.isFirebaseError()) {
          emit(AuthError(result.getFirebaseAlert()));
        }
        // GENERIC ERROR
        else if (result.isGenericError()) {
          ErrorHandler.handleError(
            result.getGenericErrorData(),
            onRetry: () {},
          );
        }
        // KNOWN ERRORS
        else if (result.isMessageError()) {
          ErrorHandler.handleError(
            null,
            customMessage: result.getMessageErrorAlert(),
            onRetry: () {},
          );
        }
        emit(Unauthenticated());
        break;
    }
  }

  /// (ƒ) :: Login
  ///
  /// Emits [Authenticated] on success,
  /// or [Unauthenticated] / [AuthError] on failure.
  Future<void> login(
    String email,
    String password,
  ) async {
    LoadingCubit.showLoading(message: AppStrings.authenticatingMsg);

    final result = await _authRepository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );

    LoadingCubit.hideLoading();

    switch (result.status) {
      case Status.success:
        if (result.isDataNotNull()) {
          _currentUser = result.data as AppUser;

          emit(Authenticated(_currentUser));
        } else {
          emit(Unauthenticated());
        }
        break;

      case Status.error:
        // FIREBASE ERROR
        if (result.isFirebaseError()) {
          emit(AuthError(result.getFirebaseAlert()));
        }
        // GENERIC ERROR
        else if (result.isGenericError()) {
          ErrorHandler.handleError(
            result.getGenericErrorData(),
            onRetry: () {},
          );
        }
        // KNOWN ERRORS
        else if (result.isMessageError()) {
          ErrorHandler.handleError(
            null,
            customMessage: result.getMessageErrorAlert(),
            onRetry: () {},
          );
        }
        emit(Unauthenticated());
        break;
    }
  }

  /// (ƒ) :: Register
  ///
  /// Emits [Authenticated] on success,
  /// or [Unauthenticated] / [AuthError] on failure.
  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    LoadingCubit.showLoading(message: AppStrings.authenticatingMsg);

    final result = await _authRepository.registerWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );

    LoadingCubit.hideLoading();

    switch (result.status) {
      case Status.success:
        if (result.isDataNotNull()) {
          _currentUser = result.data as AppUser;
          emit(Authenticated(_currentUser));
        } else {
          emit(Unauthenticated());
        }
        break;

      case Status.error:
        // FIREBASE ERROR
        if (result.isFirebaseError()) {
          emit(AuthError(result.getFirebaseAlert()));
        }
        // GENERIC ERROR
        else if (result.isGenericError()) {
          ErrorHandler.handleError(
            result.getGenericErrorData(),
            onRetry: () {},
          );
        }
        // KNOWN ERRORS
        else if (result.isMessageError()) {
          ErrorHandler.handleError(
            null,
            customMessage: result.getMessageErrorAlert(),
            onRetry: () {},
          );
        }
        emit(Unauthenticated());
        break;
    }
  }

  /// (ƒ) :: Logout
  ///
  /// Logs out the current user and emits [Unauthenticated].
  Future<void> logout() async {
    await _authRepository.logOut();
    _currentUser = AppUser.getDefaultGuestUser();
    emit(Unauthenticated());
  }

  /// (ƒ) :: Get Saved User | LocalDB
  ///
  /// Returns the [AppUser] if found, or null if not
  Future<AppUser?> getSavedUser({
    required String key,
  }) async {
    final result = await _authRepository.getSavedUser(key: key);

    if (result.status == Status.success && result.isDataNotNull()) {
      return result.data;
    }

    return null;
  }

  /// (ƒ) :: Save User To Local Storage | LocalDB
  ///
  /// Saves the [AppUser] to local storage with the specified key
  Future<void> saveUserToLocalStorage({
    required String key,
    required AppUser user,
  }) async {
    await _authRepository.saveUserToLocalStorage(user: user, key: key);
  }
}
