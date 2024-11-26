import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user.dart';
import 'package:lyxa_live/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_state.dart';
import 'package:lyxa_live/src/features/storage/domain/storage_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_handler.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';

/// AUTH CUBIT:
/// Handles authentication state management
/// ->
class AuthCubit extends Cubit<AuthState> {
  static const String debugTag = 'AuthCubit';
  final AuthRepository _authRepository;
  final StorageRepository _storageRepository;
  AppUser _currentUser = AppUser.getDefaultGuestUser();

  AuthCubit({
    required AuthRepository authRepository,
    required StorageRepository storageRepository,
  })  : _authRepository = authRepository,
        _storageRepository = storageRepository,
        super(AuthInitial());

  AppUser? get currentUser => _currentUser;

  Future<void> checkAuth() async {
    final currentUserResult = await _authRepository.getCurrentUser();

    switch (currentUserResult.status) {
      case Status.success:
        _handleAuthStatus(userData: currentUserResult.data);
        break;

      case Status.error:
        _handleErrors(
          result: currentUserResult,
          tag: '$debugTag: checkAuth()',
        );
        emit(Unauthenticated());
        break;
    }
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    _showLoading();

    final loginResult = await _authRepository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );

    _hideLoading();

    switch (loginResult.status) {
      case Status.success:
        _handleAuthStatus(userData: loginResult.data);
        break;

      case Status.error:
        _handleErrors(
          result: loginResult,
          tag: '$debugTag: login()',
        );
        emit(Unauthenticated());
        break;
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    _showLoading();

    final registerResult = await _authRepository.registerWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );

    _hideLoading();

    switch (registerResult.status) {
      case Status.success:
        _handleAuthStatus(userData: registerResult.data);
        break;

      case Status.error:
        _handleErrors(
          result: registerResult,
          tag: '$debugTag: register()',
        );
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

  Future<AppUser> getSavedUserOrDefault({
    required String storageKey,
  }) async {
    final savedUser = await getSavedUser(
      storageKey: storageKey,
    );
    if (savedUser == null) AppUser.createWith();

    Logger.logDebug(savedUser.toString());
    return savedUser as AppUser;
  }

  // HELPER FUNCTIONS ▼

  void _showLoading() {
    LoadingCubit.showLoading(
      message: AppStrings.authenticatingMsg,
    );
  }

  void _hideLoading() {
    LoadingCubit.hideLoading();
  }

  void uploadDeafultUserAvatar(String userId) async {
    const assetPath = 'assets/images/default_avatar.jpg';
    Uint8List imageBytes = await getImageBytesFromAssets(assetPath);

    final imageUploadResult = await _storageRepository.uploadProfileImage(
      imageFileBytes: imageBytes,
      fileName: userId,
    );

    if (imageUploadResult.status == Status.error) {
      _handleErrors(
        result: imageUploadResult,
        tag: '$debugTag: addPost()::imageUploadResult',
      );
      return;
    }
  }

  Future<Uint8List> getImageBytesFromAssets(String assetPath) async {
    try {
      final ByteData byteData = await rootBundle.load(assetPath);

      return byteData.buffer.asUint8List();
    } catch (e) {
      throw Exception('Failed to load asset: $e');
    }
  }

  void _handleAuthStatus({required AppUser? userData}) {
    if (userData != null) {
      _currentUser = userData;
      emit(Authenticated(_currentUser));
      uploadDeafultUserAvatar(_currentUser.uid);
    } else {
      emit(Unauthenticated());
    }
  }

  void _handleErrors(
      {required Result result, String? prefixMessage, String? tag}) {
    // FIREBASE ERROR
    if (result.isFirebaseError()) {
      emit(AuthError(result.getFirebaseAlert()));
    }
    // GENERIC ERROR
    else if (result.isGenericError()) {
      ErrorHandler.handleError(
        result.getGenericErrorData(),
        prefixMessage: prefixMessage,
        tag: tag ?? debugTag,
        onRetry: () {},
      );
    }
    // KNOWN ERRORS
    else if (result.isMessageError()) {
      ErrorHandler.handleError(
        null,
        tag: tag ?? debugTag,
        customMessage: result.getMessageErrorAlert(),
        onRetry: () {},
      );
    }
  }
}
