import 'package:dartz/dartz.dart';
import '../../../../shared/usecase/usecase.dart';

import '../../../../shared/error/failure.dart';
import '../entities/recipe.dart';
import '../repository/recipe_repository.dart';

class LikeRecipe implements UseCase<Recipe, LikeRecipeParams> {
  final RecipeRepository repository;

  LikeRecipe(this.repository);

  @override
  Future<Either<Failure, Recipe>> call(LikeRecipeParams params) async {
    return await repository.like(params.id, params.likers);
  }
}

class LikeRecipeParams extends ObjectParams<Recipe> {
  LikeRecipeParams({
    required String value,
    required List<String> params,
    DateTime? value2,
  }) : super(
          Recipe(
            diet: value,
            difficultyLevel: value,
            title: value,
            overview: value,
            duration: value,
            category: value,
            image: value,
            chef: value,
            chefID: value,
            id: value,
            chefToken: value,
            likes: params,
            createdAt: value2 ?? DateTime.now(),
            ingredients: [],
            instructions: [],
          ),
        );

  List<String> get likers => value.likes;
  String get id => value.id;
}
