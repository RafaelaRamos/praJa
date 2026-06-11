import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';
import '../router/app_router.dart';
import '../session/auth_session.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/login_user.dart';
import '../../features/auth/domain/usecases/logout_user.dart';
import '../../features/auth/domain/usecases/register_user.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/home/data/datasources/home_local_datasource.dart';
import '../../features/requests/data/datasources/request_local_datasource.dart';
import '../../features/requests/data/repositories/request_repository_impl.dart';
import '../../features/requests/domain/repositories/request_repository.dart';
import '../../features/requests/domain/usecases/create_service_request.dart';
import '../../features/requests/domain/usecases/get_provider_requests.dart';
import '../../features/requests/domain/usecases/update_request_status.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  if (getIt.isRegistered<SharedPreferences>()) {
    return;
  }

  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  getIt.registerLazySingleton<DatabaseHelper>(
    () => DatabaseHelper(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<AuthSession>(AuthSession.new);

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(
      getIt<DatabaseHelper>(),
      getIt<SharedPreferences>(),
    ),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthLocalDataSource>()),
  );

  getIt.registerLazySingleton(() => RegisterUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LoginUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetCurrentUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUser(getIt<AuthRepository>()));

  getIt.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSource(getIt<DatabaseHelper>()),
  );

  getIt.registerLazySingleton<RequestLocalDataSource>(
    () => RequestLocalDataSource(getIt<DatabaseHelper>()),
  );

  getIt.registerLazySingleton<RequestRepository>(
    () => RequestRepositoryImpl(getIt<RequestLocalDataSource>()),
  );

  getIt.registerLazySingleton(
    () => CreateServiceRequest(getIt<RequestRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetProviderRequests(getIt<RequestRepository>()),
  );
  getIt.registerLazySingleton(
    () => UpdateRequestStatus(getIt<RequestRepository>()),
  );

  getIt.registerFactory(
    () => AuthBloc(
      registerUser: getIt<RegisterUser>(),
      loginUser: getIt<LoginUser>(),
      getCurrentUser: getIt<GetCurrentUser>(),
      logoutUser: getIt<LogoutUser>(),
      authSession: getIt<AuthSession>(),
    ),
  );

  await getIt<DatabaseHelper>().database;

  getIt.registerLazySingleton<GoRouter>(
    () => createAppRouter(getIt<AuthSession>()),
  );
}

Future<void> bootstrapAuthSession() async {
  final authSession = getIt<AuthSession>();
  final result = await getIt<GetCurrentUser>()();
  result.fold(
    (_) => authSession.setUser(null),
    (user) => authSession.setUser(user),
  );
}
