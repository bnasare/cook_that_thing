import 'package:get_it/get_it.dart';
import 'data/database/review_remote_database.dart';
import 'data/repositories/review_repository_impl.dart';
import 'domain/usecases/create.dart';

import 'domain/repositories/review_repository.dart';
import 'domain/usecases/list.dart';
import 'presentation/bloc/review_bloc.dart';

void initReview() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<ReviewRemoteDatabase>(
      () => ReviewRemoteDatabaseImpl());
  sl.registerLazySingleton<ReviewRepository>(
      () => ReviewRepositoryImplementation(
            networkInfo: sl(),
            remoteDatabase: sl(),
          ));

  sl.registerFactory(() => ReviewBloc(createReview: sl(), listReview: sl()));

  sl.registerLazySingleton(() => CreateReview(sl()));

  sl.registerLazySingleton(() => ListReview(sl()));
}
