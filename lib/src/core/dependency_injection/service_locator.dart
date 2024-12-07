import 'package:get_it/get_it.dart';
import 'package:lyxa_live/src/core/themes/theme_cubit.dart';
import 'package:lyxa_live/src/core/services/storage/hive_storage.dart';
import 'package:lyxa_live/src/core/utils/platform_util.dart';
import 'package:lyxa_live/src/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lyxa_live/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:lyxa_live/src/features/home/presentation/cubits/home_cubit.dart';
import 'package:lyxa_live/src/features/home/data/repositories/home_repository_impl.dart';
import 'package:lyxa_live/src/features/home/domain/repositories/home_repository.dart';
import 'package:lyxa_live/src/features/previewer/cubits/slider_cubit.dart';
import 'package:lyxa_live/src/features/post/presentation/cubits/post_cubit.dart';
import 'package:lyxa_live/src/features/post/data/repositories/post_repository_impl.dart';
import 'package:lyxa_live/src/features/post/domain/repositories/post_repository.dart';
import 'package:lyxa_live/src/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:lyxa_live/src/features/profile/presentation/cubits/self_profile_cubit.dart';
import 'package:lyxa_live/src/features/profile/data/models/profile_user_model.dart';
import 'package:lyxa_live/src/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:lyxa_live/src/features/profile/data/services/profile_service.dart';
import 'package:lyxa_live/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:lyxa_live/src/features/search/presentation/cubits/search_cubit.dart';
import 'package:lyxa_live/src/features/search/data/repositories/search_repository_impl.dart';
import 'package:lyxa_live/src/features/search/domain/repositories/search_repository.dart';
import 'package:lyxa_live/src/features/search/domain/usecases/search_users.dart';
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

  getIt.registerSingleton<ProfileService>(
    ProfileService(
      ProfileUserModel.getGuestUser(),
    ),
  );

  // Register PlatformUtil
  getIt.registerLazySingleton(() => PlatformUtil());

  // Register repositories as singletons

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
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

  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(),
  );

  // Register Use Cases

  getIt.registerLazySingleton(() => SearchUsers(getIt<SearchRepository>()));

  // Register Cubits

  getIt.registerSingleton<AuthCubit>(
    AuthCubit(
        authRepository: getIt<AuthRepository>(),
        storageRepository: getIt<StorageRepository>()),
  );

  getIt.registerSingleton<SearchCubit>(
    SearchCubit(searchUsers: getIt<SearchUsers>()),
  );

  getIt.registerSingleton<ProfileCubit>(
    ProfileCubit(
      profileRepository: getIt<ProfileRepository>(),
      storageRepository: getIt<StorageRepository>(),
    ),
  );

  getIt.registerSingleton<SelfProfileCubit>(
    SelfProfileCubit(
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

  getIt.registerSingleton<HomeCubit>(
    HomeCubit(
      homeRepository: getIt<HomeRepository>(),
      postCubit: getIt<PostCubit>(),
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
