import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../shared/data/collection_ids.dart';
import '../../domain/entities/recipe.dart';

abstract class RecipeRemoteDatabase {
  Future<Recipe> createRecipe(
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

  Future<Recipe> like(String recipeId, List<String> likers);

  Future<List<Recipe>> list(List<String> documentIDs);
}

class RecipeRemoteDatabaseImpl implements RecipeRemoteDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Recipe> createRecipe(
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
  ) async {
    final Recipe recipe = Recipe(
      diet: diet,
      difficultyLevel: difficultyLevel,
      title: title,
      overview: overview,
      duration: duration,
      category: category,
      image: image,
      chef: chef,
      chefID: chefID,
      id: id,
      chefToken: chefToken,
      createdAt: createdAt,
      likes: likes,
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
    final user = FirebaseAuth.instance.currentUser;
    final chefDocRef =
        _firestore.collection(DatabaseCollections.chefs).doc(user!.uid);

    final favoriteRecipeDocRef = _firestore
        .collection(DatabaseCollections.favoriteRecipes)
        .doc('${user.uid}_$recipeId');

    // Get the current timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    if (likers.isNotEmpty) {
      await recipeDocRef.update({'likes': FieldValue.arrayUnion(likers)});
      await chefDocRef.update({
        'favorites': FieldValue.arrayUnion([recipeId])
      });

      // Add the favorite recipe document with timestamp
      await favoriteRecipeDocRef.set({
        'recipeId': recipeId,
        'userId': user.uid,
        'timestamp': DateTime.fromMillisecondsSinceEpoch(timestamp),
      });
    } else {
      await recipeDocRef.update({
        'likes': FieldValue.arrayRemove([user.uid])
      });
      await chefDocRef.update({
        'favorites': FieldValue.arrayRemove([recipeId])
      });

      // Delete the favorite recipe document
      await favoriteRecipeDocRef.delete();
    }

    return Recipe.fromJson((await recipeDocRef.get()).data() ?? {});
  }
}
