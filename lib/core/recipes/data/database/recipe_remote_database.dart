import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_hub/shared/data/collection_ids.dart';

import '../../domain/entities/recipe.dart';

abstract class RecipeRemoteDatabase {
  Future<Recipe> createRecipe(
    String title,
    String overview,
    String duration,
    String category,
    String image,
    String chef,
    String chefID,
    String id,
    String chefToken,
    List<String> likes,
    List<String> ingredients,
    List<String> instructions,
  );

  Future<Recipe> like(String recipeId, List<String> likers);

  Future<List<Recipe>> list(List<String> documentIDs);
}

class RecipeRemoteDatabaseImpl implements RecipeRemoteDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Recipe> createRecipe(
    String title,
    String overview,
    String duration,
    String category,
    String image,
    String chef,
    String chefID,
    String id,
    String chefToken,
    List<String> likes,
    List<String> ingredients,
    List<String> instructions,
  ) async {
    final Recipe recipe = Recipe(
      title: title,
      overview: overview,
      duration: duration,
      category: category,
      image: image,
      chef: chef,
      id: id,
      chefToken: chefToken,
      likes: likes,
      chefID: chefID,
      ingredients: ingredients,
      instructions: instructions,
    );

    final data = recipe.toJson();
    await _firestore
        .collection(DatabaseCollections.recipes)
        .doc(recipe.id)
        .set(data);

    return recipe;
  }

  @override
  Future<List<Recipe>> list(List<String> documentIDs) async {
    final recipes = await FirebaseFirestore.instance
        .collection(DatabaseCollections.recipes)
        .where(FieldPath.documentId, whereIn: documentIDs)
        .get();
    return recipes.docs.map<Recipe>((e) => Recipe.fromJson(e.data())).toList();
  }

  @override
  Future<Recipe> like(String recipeId, List<String> likers) async {
    final recipeDocRef =
        _firestore.collection(DatabaseCollections.recipes).doc(recipeId);

    if (likers.isNotEmpty) {
      await recipeDocRef.update({'likes': FieldValue.arrayUnion(likers)});
    } else {
      await recipeDocRef.update({
        'likes':
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      });
    }

    return Recipe.fromJson((await recipeDocRef.get()).data() ?? {});
  }
}
