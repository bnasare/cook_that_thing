import 'package:get_it/get_it.dart';
import 'data/database/authentication_remote_database.dart';
import 'domain/repository/authentication_repository.dart';
import 'domain/usecase/google_sign_in.dart';
import 'domain/usecase/logout.dart';
import 'domain/usecase/sign_up.dart';

import 'data/repository_impl/authentication_repository_impl.dart';
import 'domain/usecase/login.dart';
import 'presentation/bloc/auth_bloc.dart';

void initAuth() {
  final sl = GetIt.instance;

  sl.registerFactory(() =>
      AuthBloc(signUp: sl(), login: sl(), logout: sl(), googleSignIn: sl()));

  sl.registerLazySingleton<AuthenticationRemoteDatabase>(
      () => AuthenticationRemoteDatabaseImpl());

  sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(
            networkInfo: sl(),
            remoteDatabase: sl(),
          ));

  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
}
