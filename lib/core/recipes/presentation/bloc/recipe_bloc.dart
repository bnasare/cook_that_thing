import 'package:dartz/dartz.dart';
import 'package:recipe_hub/core/recipes/domain/entities/recipe.dart';
import 'package:recipe_hub/core/recipes/domain/usecase/create.dart';
import 'package:recipe_hub/core/recipes/domain/usecase/like.dart';
import 'package:recipe_hub/core/recipes/domain/usecase/list.dart';
import 'package:recipe_hub/shared/data/firebase_constants.dart';

import '../../../../shared/error/failure.dart';
import '../../../../shared/usecase/usecase.dart';

class RecipeBloc {
  CreateRecipe createRecipe;
  ListRecipes listRecipes;
  LikeRecipe likeRecipe;
  RecipeBloc(
      {required this.createRecipe,
      required this.listRecipes,
      required this.likeRecipe});

  Future<Either<Failure, Recipe>> createARecipe(
    String diet,
    String difficultyLevel,
    String title,
    String overview,
    String duration,
    String category,
    String image,
    List<String> ingredients,
    List<String> instructions,
  ) async {
    return await createRecipe(RecipeParams(
        diet: diet,
        difficultyLevel: difficultyLevel,
        title: title,
        overview: overview,
        duration: duration,
        category: category,
        image: image,
        ingredients: ingredients,
        instructions: instructions,
        chefTokenFuture: await FirebaseConsts.messaging.getToken() ?? ''));
  }

  Future<Either<Failure, List<Recipe>>> getRecipes(String documentID) async {
    return await listRecipes(ObjectParams<List<String>>([documentID]));
  }

  Future<Either<Failure, Recipe>> like(
      String recipeId, List<String> likers) async {
    return await likeRecipe(LikeRecipeParams(value: recipeId, params: likers));
  }
}
