import 'package:dartz/dartz.dart';

import '../../../../shared/error/failure.dart';
import '../entities/recipe.dart';

abstract class RecipeRepository {
  Future<Either<Failure, Recipe>> createRecipe(
    String diet,
    String difficultyLevel,
    String title,
    String overview,
    String duration,
    String category,
    String image,
    String chef,
    String chefID,
    String id,
    String chefToken,
    DateTime createdAt,
    List<String> likes,
    List<String> ingredients,
    List<String> instructions,
  );
  Future<Either<Failure, List<Recipe>>> list(List<String> documentID);
  Future<Either<Failure, Recipe>> like(String recipeId, List<String> likers);
}
