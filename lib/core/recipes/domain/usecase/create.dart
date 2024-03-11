import 'package:dartz/dartz.dart';
import 'package:recipe_hub/shared/data/firebase_constants.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/error/failure.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/recipe.dart';
import '../repository/recipe_repository.dart';

class CreateRecipe implements UseCase<Recipe, RecipeParams> {
  final RecipeRepository repository;

  CreateRecipe(this.repository);

  @override
  Future<Either<Failure, Recipe>> call(RecipeParams params) async {
    return await repository.createRecipe(
      params.title,
      params.overview,
      params.duration,
      params.category,
      params.image,
      params.chef,
      params.chefID,
      params.id,
      params.chefToken,
      params.likes,
      params.ingredients,
      params.instructions,
    );
  }
}

class RecipeParams extends ObjectParams<Recipe> {
  RecipeParams({
    required String title,
    required String overview,
    required String duration,
    required String category,
    required String image,
    String? chef,
    String? chefID,
    String? id,
    required String chefTokenFuture,
    List<String>? likes,
    required List<String> ingredients,
    required List<String> instructions,
  }) : super(
          Recipe(
            title: title,
            overview: overview,
            duration: duration,
            category: category,
            image: image,
            chef: FirebaseConsts.currentUser?.displayName ?? 'User',
            chefID: FirebaseConsts.currentUser?.uid ?? 'UserID',
            id: id ?? const Uuid().v4(),
            chefToken: chefTokenFuture,
            likes: [],
            ingredients: ingredients,
            instructions: instructions,
          ),
        );

  String get title => value.title;
  String get overview => value.overview;
  String get duration => value.duration;
  String get category => value.category;
  String get image => value.image;
  String get chef => value.chef;
  String get chefID => value.chefID;
  String get id => value.id;
  String get chefToken => value.chefToken;
  List<String> get likes => value.likes;
  List<String> get ingredients => value.ingredients;
  List<String> get instructions => value.instructions;
}
