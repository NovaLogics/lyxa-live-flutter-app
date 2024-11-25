import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_state.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';

/// AUTH CUBIT:
/// Handles authentication state management
/// ->
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  AppUser _currentUser = AppUser.getDefaultGuestUser();

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial());

  AppUser? get currentUser => _currentUser;

  Future<void> checkAuthentication() async {
    final currentUserResult = await _authRepository.getCurrentUser();

    switch (currentUserResult.status) {
      case Status.success:
        final user = currentUserResult.data;

        if (user != null) {
          _currentUser = user;
          emit(Authenticated(_currentUser));
        } else {
          emit(Unauthenticated());
        }
        break;

      case Status.error:
        _handleErrors(result: currentUserResult);
        emit(Unauthenticated());
        break;
    }
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    LoadingCubit.showLoading(message: AppStrings.authenticatingMsg);

    final loginResult = await _authRepository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );

    LoadingCubit.hideLoading();

    switch (loginResult.status) {
      case Status.success:
        final user = loginResult.data;

        if (user != null) {
          _currentUser = user;
          emit(Authenticated(_currentUser));
        } else {
          emit(Unauthenticated());
        }
        break;

      case Status.error:
        _handleErrors(result: loginResult);
        emit(Unauthenticated());
        break;
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    LoadingCubit.showLoading(message: AppStrings.authenticatingMsg);

    final registerResult = await _authRepository.registerWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );

    LoadingCubit.hideLoading();

    switch (registerResult.status) {
      case Status.success:
        final user = registerResult.data;

        if (user != null) {
          _currentUser = user;
          emit(Authenticated(_currentUser));
        } else {
          emit(Unauthenticated());
        }
        break;

      case Status.error:
        _handleErrors(result: registerResult);
        emit(Unauthenticated());
        break;
    }
  }

  Future<void> logout() async {
    await _authRepository.logOut();
    _currentUser = AppUser.getDefaultGuestUser();
    emit(Unauthenticated());
  }

  Future<AppUser?> getSavedUser({
    required String storageKey,
  }) async {
    final savedUserResult =
        await _authRepository.getSavedUser(storageKey: storageKey);

    if (savedUserResult.status == Status.success &&
        savedUserResult.isDataNotNull()) {
      return savedUserResult.data;
    }

    return null;
  }

  Future<void> saveUserToLocalStorage({
    required String storageKey,
    required AppUser user,
  }) async {
    await _authRepository.saveUserToLocalStorage(
      storageKey: storageKey,
      user: user,
    );
  }

  //-> HELPER FUNCTIONS ->

  void _handleErrors({required Result result, String? prefixMessage}) {
    // FIREBASE ERROR
    if (result.isFirebaseError()) {
      emit(AuthError(result.getFirebaseAlert()));
    }
    // GENERIC ERROR
    else if (result.isGenericError()) {
      ErrorHandler.handleError(
        result.getGenericErrorData(),
        prefixMessage: prefixMessage,
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
  }
}
