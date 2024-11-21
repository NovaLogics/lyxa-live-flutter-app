import 'package:get_it/get_it.dart';
import 'package:lyxa_live/src/core/utils/hive_helper.dart';
import 'package:lyxa_live/src/shared/widgets/center_loading_unit.dart';
import 'package:lyxa_live/src/shared/widgets/gradient_background_unit.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
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
