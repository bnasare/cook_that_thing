import 'package:get_it/get_it.dart';
import 'package:recipe_hub/core/review/data/database/review_remote_database.dart';
import 'package:recipe_hub/core/review/data/repositories/review_repository_impl.dart';
import 'package:recipe_hub/core/review/domain/usecases/create.dart';

import 'domain/repositories/review_repository.dart';
import 'domain/usecases/list.dart';
import 'presentation/interface/bloc/review_bloc.dart';

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
