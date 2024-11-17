import 'package:get_it/get_it.dart';
import 'package:lyxa_live/src/core/utils/helper/hive_helper.dart';
import 'package:lyxa_live/src/features/auth/cubits/auth_cubit.dart';
import 'package:lyxa_live/src/features/auth/data/firebase_auth_repository.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Register services (e.g., APIs, databases)
  // getIt.registerLazySingleton<AuthService>(() => AuthService());
  // AuthCubit(getIt<AuthService>()));

  final FirebaseAuthRepository authRepository = FirebaseAuthRepository();

  // Register cubits or blocs
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(authRepository: authRepository),
  );

  getIt.registerFactoryParam<GradientBackgroundUnit, double, void>(
    (widthSize, _) => GradientBackgroundUnit(width: widthSize),
  );

  getIt.registerFactory(() => HiveHelper());
}
