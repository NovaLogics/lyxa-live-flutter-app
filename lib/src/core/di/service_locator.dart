import 'package:get_it/get_it.dart';
import 'package:lyxa_live/src/core/themes/cubits/theme_cubit.dart';
import 'package:lyxa_live/src/core/database/hive_storage.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/auth/data/firebase_auth_repository.dart';
import 'package:lyxa_live/src/features/photo_slider/cubits/slider_cubit.dart';
import 'package:lyxa_live/src/features/post/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/post/data/repositories/post_repository_impl.dart';
import 'package:lyxa_live/src/features/post/domain/repositories/post_repository.dart';
import 'package:lyxa_live/src/features/profile/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:lyxa_live/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:lyxa_live/src/features/search/cubits/search_cubit.dart';
import 'package:lyxa_live/src/features/search/data/repositories/search_repository_impl.dart';
import 'package:lyxa_live/src/features/search/domain/repositories/search_repository.dart';
import 'package:lyxa_live/src/features/storage/data/repositories/storage_repository_impl.dart';
import 'package:lyxa_live/src/features/storage/domain/repositories/storage_repository.dart';
import 'package:lyxa_live/src/shared/handlers/errors/cubits/error_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/cubits/loading_cubit.dart';
import 'package:lyxa_live/src/shared/handlers/loading/widgets/loading_unit.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Register Hive | LoaclDB Helper

  getIt.registerFactory(() => HiveStorage());

  // Register repositories as singletons

  getIt.registerLazySingleton<FirebaseAuthRepository>(
    () => FirebaseAuthRepository(),
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(),
  );

  getIt.registerLazySingleton<StorageRepository>(
    () => StorageRepositoryImpl(),
  );

  getIt.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(),
  );

  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(),
  );

  // Register Cubits

  getIt.registerSingleton<AuthCubit>(
    AuthCubit(
        authRepository: getIt<FirebaseAuthRepository>(),
        storageRepository: getIt<StorageRepository>()),
  );

  getIt.registerSingleton<SearchCubit>(
    SearchCubit(searchRepository: getIt<SearchRepository>()),
  );

  getIt.registerSingleton<ProfileCubit>(
    ProfileCubit(
      profileRepository: getIt<ProfileRepository>(),
      storageRepository: getIt<StorageRepository>(),
    ),
  );

  getIt.registerSingleton<PostCubit>(
    PostCubit(
      postRepository: getIt<PostRepository>(),
      storageRepository: getIt<StorageRepository>(),
    ),
  );

  getIt.registerSingleton<ThemeCubit>(ThemeCubit());

  getIt.registerSingleton<SliderCubit>(SliderCubit());

  getIt.registerSingleton<LoadingCubit>(LoadingCubit());

  getIt.registerSingleton<ErrorAlertCubit>(ErrorAlertCubit());

  // Register Widgets

  getIt.registerFactoryParam<GradientBackgroundUnit, double, BackgroundStyle>(
    (widthSize, style) => GradientBackgroundUnit(
      width: widthSize,
      style: style,
    ),
  );

  getIt.registerFactoryParam<LoadingUnit, String, void>(
    (message, _) => LoadingUnit(message: message),
  );
}
