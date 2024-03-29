// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../injection_container.dart';
import '../../../../shared/data/collection_ids.dart';
import '../../../../shared/data/firebase_constants.dart';
import '../../../../shared/utils/navigation.dart';
import '../../../../src/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../src/authentication/presentation/interface/pages/wrapper.dart';
import '../../../recipes/domain/entities/recipe.dart';
import '../../../recipes/presentation/bloc/recipe_bloc.dart';
import '../../../review/domain/entities/review.dart';
import '../../../review/presentation/bloc/review_bloc.dart';
import '../../domain/entities/chef.dart';
import 'chef_bloc.dart';

mixin ChefMixin {
  final bloc = sl<ChefBloc>();
  final authBloc = sl<AuthBloc>();
  final recipeBloc = sl<RecipeBloc>();
  final reviewBloc = sl<ReviewBloc>();

  Stream<Chef> retrieve(
      {required BuildContext context, required String chefId}) async* {
    final result = await bloc.retrieve(chefId);
    yield result.fold(
      (l) {
        l;
        return Chef.initial();
      },
      (r) => r,
    );
  }

  Stream<Chef> retrieveChefStream(
      {required BuildContext context, required String chefId}) async* {
    final result = await bloc.retrieve(chefId);
    yield* result.fold(
      (l) {
        return const Stream.empty();
      },
      (r) => Stream.value(r),
    );
  }

  Future<void> follow(
      {required BuildContext context,
      required String chefId,
      required List<String> followers,
      required List<String> token}) async {
    final result = await bloc.follow(chefId, followers, token);
    return result.fold(
      (l) => l,
      (r) => r,
    );
  }

  Future<void> logoutUser({required BuildContext context}) async {
    final result = await authBloc.logoutUser();
    return result.fold(
      (l) => l,
      (r) => NavigationHelper.navigateToAndRemoveUntil(
          context, const AuthWrapper()),
    );
  }

  Stream<List<Recipe>> getRecipes({
    required BuildContext context,
    required String documentID,
  }) async* {
    final result = await recipeBloc.getRecipes(documentID);
    yield result.fold(
      (l) {
        return <Recipe>[];
      },
      (r) => r,
    );
  }

  BehaviorSubject<List<Recipe>> fetchAllRecipesByChefID(
      BuildContext context, String chefID) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = DatabaseCollections.recipes;
    Stream<QuerySnapshot> querySnapshotStream = firestore
        .collection(collectionPath)
        .where('chefID', isEqualTo: chefID)
        .orderBy("createdAt", descending: true)
        .snapshots();

    BehaviorSubject<List<Recipe>> subject = BehaviorSubject<List<Recipe>>();

    querySnapshotStream.listen((QuerySnapshot querySnapshot) async {
      List<Recipe> allRecipes = [];
      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        String documentId = snapshot.id;
        List<Recipe> recipesForDocumentId =
            await getRecipes(context: context, documentID: documentId).first;
        allRecipes.addAll(recipesForDocumentId);
      }
      subject.add(allRecipes);
    }, onError: subject.addError);

    return subject;
  }

  Stream<List<Recipe>> fetchFavorites(BuildContext context) {
    final user = FirebaseConsts.currentUser;

    if (user == null) {
      return Stream.value([]);
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String favoriteRecipesCollectionPath = DatabaseCollections.favoriteRecipes;

    return firestore
        .collection(favoriteRecipesCollectionPath)
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap<List<Recipe>>((favoriteRecipeSnapshot) async {
      List<String> favoriteIds = favoriteRecipeSnapshot.docs
          .map<String>((doc) => doc['recipeId'] as String)
          .toList();

      if (favoriteIds.isNotEmpty) {
        QuerySnapshot recipeSnapshot = await firestore
            .collection(DatabaseCollections.recipes)
            .where(FieldPath.documentId, whereIn: favoriteIds)
            .get();
        List<Recipe> favoriteRecipes = recipeSnapshot.docs
            .map<Recipe>(
                (doc) => Recipe.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
        return favoriteRecipes;
      } else {
        return [];
      }
    });
  }

  Stream<List<Recipe>> fetchFavoritess(BuildContext context) {
    final user = FirebaseConsts.currentUser;

    // If user is not authenticated, return an empty stream
    if (user == null) {
      return Stream.value([]);
    }

    // Create a BehaviorSubject to manage the stream of favorite recipes
    BehaviorSubject<List<Recipe>> subject = BehaviorSubject<List<Recipe>>();

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String favoriteRecipesCollectionPath = DatabaseCollections.favoriteRecipes;

    // Listen for changes in the favoriteRecipes collection
    firestore
        .collection(favoriteRecipesCollectionPath)
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((favoriteRecipeSnapshot) {
      List<String> favoriteIds = favoriteRecipeSnapshot.docs
          .map<String>((doc) => doc['recipeId'] as String)
          .toList();

      // Check if there are any favorite recipes
      if (favoriteIds.isNotEmpty) {
        // If there are favorite recipes, listen for changes in the recipes collection
        firestore
            .collection(DatabaseCollections.recipes)
            .where(FieldPath.documentId, whereIn: favoriteIds)
            .snapshots()
            .listen((recipeSnapshot) {
          // Convert each document snapshot into a Recipe object
          List<Recipe> favoriteRecipes = recipeSnapshot.docs
              .map<Recipe>((doc) => Recipe.fromJson(doc.data()))
              .toList()
              .where((recipe) => favoriteIds.contains(recipe.id))
              .toList();
          // Emit the list of favorite recipes through the stream
          subject.add(favoriteRecipes);
        });
      } else {
        // If there are no favorite recipes, emit an empty list through the stream
        subject.add([]);
      }
    }, onError: subject.addError);

    // Return the stream of favorite recipes
    return subject.stream;
  }

  Stream<int> retrieveRecipeLength(
    BuildContext context,
    String documentID,
  ) async* {
    final List<Recipe> recipes =
        await fetchAllRecipesByChefID(context, documentID).first;
    yield recipes.length;
  }

  Stream<int> retrieveFollowersCount(
      {required BuildContext context, required String chefId}) async* {
    while (true) {
      final result = await bloc.retrieve(chefId);
      yield result.fold(
        (l) {
          return 0;
        },
        (r) => r.followers.length,
      );
    }
  }

  Future<void> clearFavoriteRecipes() async {
    try {
      final user = FirebaseConsts.currentUser;
      if (user == null) return;

      final chefDocRef =
          FirebaseFirestore.instance.collection('chefs').doc(user.uid);
      final chefDocSnapshot = await chefDocRef.get();

      if (!chefDocSnapshot.exists) {
        log('Chef document does not exist.');
        return;
      }

      final chefData = chefDocSnapshot.data();
      if (chefData == null ||
          !chefData.containsKey('favorites') ||
          (chefData['favorites'] as List).isEmpty) {
        log('No favorites to clear or already cleared.');
        return;
      }

      final List<String> favoriteRecipes =
          List<String>.from(chefData['favorites']);

      // Create a batch to perform all writes efficiently
      final batch = FirebaseFirestore.instance.batch();

      // Clear favorite array inside the chef document
      batch.update(chefDocRef, {'favorites': []});

      // Track recipes to be removed from favoriteRecipes collection
      final recipesToDelete = <String>{};

      // Loop through favorites, checking existence in Recipes collection
      for (final recipeId in favoriteRecipes) {
        final recipeDocRef = FirebaseFirestore.instance
            .collection(DatabaseCollections.recipes)
            .doc(recipeId);
        final recipeDocSnapshot = await recipeDocRef.get();

        if (recipeDocSnapshot.exists) {
          recipesToDelete.add(recipeId);

          // Update the recipe's likes within the batch
          batch.update(recipeDocRef, {
            'likes': FieldValue.arrayRemove([user.uid])
          });
        } else {
          log('Recipe $recipeId does not exist. Skipping update.');
        }
      }

      // Delete only the relevant favorite recipe documents
      for (final recipeId in recipesToDelete) {
        batch.delete(FirebaseFirestore.instance
            .collection('favoriteRecipes')
            .doc('${user.uid}_$recipeId'));
      }

      // Commit the batch operation
      await batch.commit();
    } catch (error) {
      // Log or handle the error accordingly
      log('Error clearing favorites: $error');
    }
  }

  Stream<List<Review>> getReviews({
    required BuildContext context,
    required String documentID,
  }) async* {
    final result = await reviewBloc.getReviews(documentID);
    yield result.fold(
      (l) {
        return <Review>[];
      },
      (r) => r,
    );
  }

  Future<List<Review>> getReviewss({
    required BuildContext context,
    required String documentID,
  }) async {
    final result = await reviewBloc.getReviews(documentID);
    return result.fold(
      (l) {
        return <Review>[];
      },
      (r) => r,
    );
  }

  Stream<List<Review>> fetchReviewsByChefID(
      BuildContext context, String chefID) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = DatabaseCollections.reviews;

    Stream<QuerySnapshot> querySnapshotStream = firestore
        .collection(collectionPath)
        .where('chefID', isEqualTo: chefID)
        .orderBy('time', descending: true)
        .snapshots();

    await for (QuerySnapshot querySnapshot in querySnapshotStream) {
      List<Review> allReviews = [];
      List<Future<List<Review>>> reviewFutures = [];

      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        String documentId = snapshot.id;
        reviewFutures
            .add(getReviewss(context: context, documentID: documentId));
      }

      List<List<Review>> reviewsLists = await Future.wait(reviewFutures);
      allReviews = reviewsLists.expand((reviews) => reviews).toList();

      yield allReviews;
    }
  }

  Stream<double> getAverageChefReviewsRatingStream(
    String chefId,
    BuildContext context,
  ) async* {
    double sum = 0;
    int count = 0;

    await for (var reviews in fetchReviewsByChefID(context, chefId)) {
      for (var review in reviews) {
        sum += review.rating;
        count++;
      }
      yield count != 0 ? sum / count : 0;
    }
  }
}
