import 'package:dartz/dartz.dart';

import '../../../../shared/error/failure.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/recipe.dart';
import '../repository/recipe_repository.dart';

class ListRecipes implements UseCase<List<Recipe>, ObjectParams<List<String>>> {
  final RecipeRepository repository;

  ListRecipes(this.repository);

  @override
  Future<Either<Failure, List<Recipe>>> call(
      ObjectParams<List<String>> params) async {
    return await repository.list(params.value);
  }
}
