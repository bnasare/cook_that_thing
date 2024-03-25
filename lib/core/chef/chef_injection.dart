import 'package:get_it/get_it.dart';
import 'domain/usecase.dart/follow.dart';

import 'data/database/chef_remote_database.dart';
import 'data/repository_impl/chef_repository_impl.dart';
import 'domain/repository/chef_repository.dart';
import 'domain/usecase.dart/list.dart';
import 'domain/usecase.dart/retrieve.dart';
import 'presentation/bloc/chef_bloc.dart';

void initChef() {
  final sl = GetIt.instance;

  sl
    ..registerFactory(
        () => ChefBloc(retrieveChef: sl(), followChef: sl(), listChef: sl()))
    ..registerLazySingleton<ChefRepository>(
        () => ChefRepositoryImpl(networkInfo: sl(), remoteDatabase: sl()))
    ..registerLazySingleton<ChefRemoteDatabase>(() => ChefRemoteDatabaseImpl());

  sl.registerLazySingleton(() => RetrieveChef(sl()));
  sl.registerLazySingleton(() => FollowChef(sl()));
  sl.registerLazySingleton(() => ListChef(sl()));
}
