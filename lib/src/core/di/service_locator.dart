import 'package:get_it/get_it.dart';
import 'package:lyxa_live/src/core/utils/helper/hive_helper.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerFactoryParam<GradientBackgroundUnit, double, void>(
    (widthSize, _) => GradientBackgroundUnit(width: widthSize),
  );

  getIt.registerFactory(() => HiveHelper());

  // Register services (e.g., APIs, databases)
  // getIt.registerLazySingleton<AuthService>(() => AuthService());
  // AuthCubit(getIt<AuthService>()));

  // final FirebaseAuthRepository authRepository = FirebaseAuthRepository();

  // // Register cubits or blocs
  // getIt.registerFactory<AuthCubit>(
  //   () => AuthCubit(authRepository: authRepository),
  // );
}
