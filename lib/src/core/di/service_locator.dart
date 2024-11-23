import 'package:get_it/get_it.dart';
import 'package:lyxa_live/src/core/utils/hive_helper.dart';
import 'package:lyxa_live/src/features/auth/data/firebase_auth_repository.dart';
import 'package:lyxa_live/src/features/post/data/firebase_post_repository.dart';
import 'package:lyxa_live/src/features/profile/data/firebase_profile_repository.dart';
import 'package:lyxa_live/src/features/search/data/firebase_search_repository.dart';
import 'package:lyxa_live/src/features/storage/data/firebase_storage_repository.dart';
import 'package:lyxa_live/src/shared/event_handlers/loading/widgets/center_loading_unit.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {

  // Register repositories as singletons
  getIt.registerLazySingleton<FirebaseAuthRepository>(() => FirebaseAuthRepository());
  getIt.registerLazySingleton<FirebaseProfileRepository>(() => FirebaseProfileRepository());
  getIt.registerLazySingleton<FirebaseStorageRepository>(() => FirebaseStorageRepository());
  getIt.registerLazySingleton<FirebasePostRepository>(() => FirebasePostRepository());
  getIt.registerLazySingleton<FirebaseSearchRepository>(() => FirebaseSearchRepository());
  
  getIt.registerFactory(() => HiveHelper());

  getIt.registerFactoryParam<GradientBackgroundUnit, double, BackgroundStyle>(
    (widthSize, style) => GradientBackgroundUnit(width: widthSize, style: style,),
  );

  getIt.registerFactoryParam<CenterLoadingUnit, String, void>(
    (message, _) => CenterLoadingUnit(message: message),
  );

  // Register services (e.g., APIs, databases)
  // getIt.registerLazySingleton<AuthService>(() => AuthService());
  // AuthCubit(getIt<AuthService>()));

  // final FirebaseAuthRepository authRepository = FirebaseAuthRepository();

  // // Register cubits or blocs
  // getIt.registerFactory<AuthCubit>(
  //   () => AuthCubit(authRepository: authRepository),
  // );
}
