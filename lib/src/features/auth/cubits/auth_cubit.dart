import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyxa_live/src/core/di/service_locator.dart';
import 'package:lyxa_live/src/core/assets/app_images.dart';
import 'package:lyxa_live/src/core/resources/app_strings.dart';
import 'package:lyxa_live/src/core/utils/logger.dart';
import 'package:lyxa_live/src/features/auth/data/models/app_user_model.dart';
import 'package:lyxa_live/src/features/auth/domain/entities/app_user_entity.dart';
import 'package:lyxa_live/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_state.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/features/profile/data/services/profile_service.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user_entity.dart';
import 'package:lyxa_live/src/features/storage/domain/repositories/storage_repository.dart';
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
  AppUserEntity? _currentUser;
  final ProfileService _profileService = getIt<ProfileService>();

  AuthCubit({
    required AuthRepository authRepository,
    required StorageRepository storageRepository,
  })  : _authRepository = authRepository,
        _storageRepository = storageRepository,
        super(AuthInitial());

  AppUserEntity? get currentUser => _currentUser;

  Future<void> checkAuth() async {
    _showLoading();

    final currentUserResult = await _authRepository.getCurrentUser();

    _hideLoading();
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

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _showLoading();

    final loginResult = await _authRepository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );

    _hideLoading();

    switch (loginResult.status) {
      case Status.success:
        _profileService.assignEntity(loginResult.data!);
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

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _showLoading();

    final registerResult = await _authRepository.registerWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );

    _hideLoading();

    switch (registerResult.status) {
      case Status.success:
        _showLoading();
        if (registerResult.isDataNotNull()) {
          _currentUser = registerResult.data as AppUserEntity;
          await _uploadDeafultUserAvatar(_currentUser!.uid);

          checkAuth();
          //  emit(Authenticated(_currentUser!));
        } else {
          emit(Unauthenticated());
        }
        _hideLoading();
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
    _currentUser = null;
    getIt<ProfileCubit>().resetUser();
    emit(Unauthenticated());
  }

  Future<AppUserEntity?> getSavedUser({
    required String storageKey,
  }) async {
    final savedUserResult =
        await _authRepository.getSavedUser(storageKey: storageKey);

    if (savedUserResult.status == Status.success &&
        savedUserResult.isDataNotNull()) {
      return savedUserResult.data!;
    }
    return null;
  }

  Future<void> saveUserToLocalStorage({
    required String storageKey,
    required AppUserEntity user,
  }) async {
    await _authRepository.saveUserToLocalStorage(
      storageKey: storageKey,
      user: user,
    );
  }

  Future<AppUserEntity> getSavedUserOrDefault({
    required String storageKey,
  }) async {
    AppUserEntity? savedUser = await getSavedUser(
      storageKey: storageKey,
    );
    savedUser ??= AppUserModel.createWith();

    Logger.logDebug(savedUser.toString());
    return savedUser as AppUserEntity;
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

  Future<bool> _uploadDeafultUserAvatar(String userId) async {
    Uint8List imageBytes =
        await _getImageBytesFromAssets(AppImages.defaultAvatar);

    final imageUploadResult = await _storageRepository.uploadProfileImage(
      imageFileBytes: imageBytes,
      fileName: userId,
    );

    final imageUrl = imageUploadResult.data ?? '';

    if (imageUploadResult.status == Status.error) {
      _handleErrors(
        result: imageUploadResult,
        tag: '$debugTag: _uploadDeafultUserAvatar()::imageUploadResult',
      );
      return false;
    } else if (imageUrl.isEmpty) {
      return false;
    }

    final updateUrlResult = await _authRepository.updateProfileImageUrl(
      userId: userId,
      profileImageUrl: imageUrl,
    );
    if (updateUrlResult.status == Status.error) {
      _handleErrors(
        result: imageUploadResult,
        tag: '$debugTag: _uploadDeafultUserAvatar()::updateUrlResult',
      );
      return false;
    }
    return true;
  }

  Future<Uint8List> _getImageBytesFromAssets(String assetPath) async {
    try {
      final ByteData byteData = await rootBundle.load(assetPath);

      return byteData.buffer.asUint8List();
    } catch (e) {
      throw Exception('Failed to load asset: $e');
    }
  }

  void _handleAuthStatus({required ProfileUserEntity? userData}) {
    if (userData != null) {
      _currentUser = userData;
      _profileService.assignEntity(userData);
      emit(Authenticated(_currentUser!));
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
