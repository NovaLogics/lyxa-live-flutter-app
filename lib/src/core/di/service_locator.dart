import 'package:get_it/get_it.dart';
import 'package:lyxa_live/src/core/themes/cubits/theme_cubit.dart';
import 'package:lyxa_live/src/core/utils/hive_helper.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/auth/data/firebase_auth_repository.dart';
import 'package:lyxa_live/src/features/photo_slider/cubits/slider_cubit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/post/data/firebase_post_repository.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/features/profile/data/firebase_profile_repository.dart';
import 'package:lyxa_live/src/features/search/cubits/search_cubit.dart';
import 'package:lyxa_live/src/features/search/data/firebase_search_repository.dart';
import 'package:lyxa_live/src/features/storage/data/firebase_storage_repository.dart';
import 'package:lyxa_live/src/shared/handlers/errors/cubits/error_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/widgets/center_loading_unit.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Register repositories as singletons

  getIt.registerLazySingleton<FirebaseAuthRepository>(
    () => FirebaseAuthRepository(),
  );

  getIt.registerLazySingleton<FirebaseProfileRepository>(
    () => FirebaseProfileRepository(),
  );

  getIt.registerLazySingleton<FirebaseStorageRepository>(
    () => FirebaseStorageRepository(),
  );

  getIt.registerLazySingleton<FirebasePostRepository>(
    () => FirebasePostRepository(),
  );

  getIt.registerLazySingleton<FirebaseSearchRepository>(
    () => FirebaseSearchRepository(),
  );

  // Register Cubits

  getIt.registerSingleton<AuthCubit>(
    AuthCubit(authRepository: getIt<FirebaseAuthRepository>()),
  );

  getIt.registerSingleton<SearchCubit>(
    SearchCubit(searchRepository: getIt<FirebaseSearchRepository>()),
  );

  getIt.registerSingleton<ProfileCubit>(
    ProfileCubit(
      profileRepository: getIt<FirebaseProfileRepository>(),
      storageRepository: getIt<FirebaseStorageRepository>(),
    ),
  );

  getIt.registerSingleton<PostCubit>(
    PostCubit(
      postRepository: getIt<FirebasePostRepository>(),
      storageRepository: getIt<FirebaseStorageRepository>(),
    ),
  );

  getIt.registerSingleton<ThemeCubit>(ThemeCubit());

  getIt.registerSingleton<SliderCubit>(SliderCubit());

  getIt.registerSingleton<LoadingCubit>(LoadingCubit());

  getIt.registerSingleton<ErrorAlertCubit>(ErrorAlertCubit());

  getIt.registerFactory(() => HiveHelper());

  // Register Widgets

  getIt.registerFactoryParam<GradientBackgroundUnit, double, BackgroundStyle>(
    (widthSize, style) => GradientBackgroundUnit(
      width: widthSize,
      style: style,
    ),
  );

  getIt.registerFactoryParam<CenterLoadingUnit, String, void>(
    (message, _) => CenterLoadingUnit(message: message),
  );
}
