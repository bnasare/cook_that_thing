import 'package:get_it/get_it.dart';

import 'data/database/recipe_remote_database.dart';
import 'data/repository_impl.dart/recipe_repository_impl.dart';
import 'domain/repository/recipe_repository.dart';
import 'domain/usecase/create.dart';
import 'domain/usecase/like.dart';
import 'domain/usecase/list.dart';
import 'presentation/interface/bloc/recipe_bloc.dart';

void initRecipe() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<RecipeRemoteDatabase>(
      () => RecipeRemoteDatabaseImpl());
  sl.registerLazySingleton<RecipeRepository>(
      () => RecipeRepositoryImplementation(
            networkInfo: sl(),
            remoteDatabase: sl(),
          ));

  sl.registerFactory(() =>
      RecipeBloc(createRecipe: sl(), listRecipes: sl(), likeRecipe: sl()));

  sl.registerLazySingleton(() => CreateRecipe(sl()));

  sl.registerLazySingleton(() => ListRecipes(sl()));

  sl.registerLazySingleton(() => LikeRecipe(sl()));
}
