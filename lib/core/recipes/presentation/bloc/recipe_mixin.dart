// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../injection_container.dart';
import '../../../../shared/data/collection_ids.dart';
import '../../../../shared/data/firebase_constants.dart';
import '../../../../shared/platform/push_notification.dart';
import '../../../../shared/widgets/snackbar.dart';
import '../../../chef/domain/entities/chef.dart';
import '../../../chef/presentation/bloc/chef_bloc.dart';
import '../../../review/domain/entities/review.dart';
import '../../../review/presentation/bloc/review_bloc.dart';
import '../../domain/entities/recipe.dart';
import 'recipe_bloc.dart';

mixin RecipeMixin {
  final bloc = sl<RecipeBloc>();
  final reviewBloc = sl<ReviewBloc>();
  final chefBloc = sl<ChefBloc>();

  Future<void> createARecipe({
    required BuildContext context,
    required String diet,
    required String difficultyLevel,
    required String title,
    required String overview,
    required String duration,
    required String category,
    required String image,
    required DateTime createdAt,
    required List<String> ingredients,
    required List<String> instructions,
  }) async {
    final result = await bloc.createARecipe(
      diet,
      difficultyLevel,
      title,
      overview,
      duration,
      category,
      image,
      createdAt,
      ingredients,
      instructions,
    );
    return result.fold(
      (l) => SnackBarHelper.showErrorSnackBar(context, l.message),
      (r) {
        r;
        final String chefId = FirebaseConsts.currentUser!.uid;
        final tokenStream =
            retrieveChefStream(context: context, chefId: chefId);
        tokenStream.listen(
          (Chef chef) async {
            final PushNotification pushNotification = PushNotificationImpl(
              FlutterLocalNotificationsPlugin(),
            );
            final List<String> token = chef.token;
            if (token.isNotEmpty) {
              for (var singleToken in token) {
                await pushNotification.sendPushNotifs(
                  title: 'New Recipe Created',
                  body:
                      '${FirebaseConsts.currentUser!.displayName} created a new recipe!',
                  token: singleToken,
                );
              }
            } else {
              return;
            }
          },
          onError: (error) {
            log(error);
          },
        );
      },
    );
  }

  Stream<List<Recipe>> getRecipes({
    required BuildContext context,
    required String documentID,
  }) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = DatabaseCollections.recipes;

    Stream<DocumentSnapshot> documentStream =
        firestore.collection(collectionPath).doc(documentID).snapshots();

    await for (var snapshot in documentStream) {
      if (snapshot.exists && snapshot.data() != null) {
        List<Recipe> recipes = [
          Recipe.fromJson(snapshot.data() as Map<String, dynamic>)
        ];
        yield recipes;
      } else {
        yield <Recipe>[];
      }
    }
  }

  Stream<List<Recipe>> fetchAllRecipes(BuildContext context) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = DatabaseCollections.recipes;

    Stream<QuerySnapshot> querySnapshotStream = firestore
        .collection(collectionPath)
        .orderBy("createdAt", descending: true)
        .snapshots();

    await for (QuerySnapshot querySnapshot in querySnapshotStream) {
      List<Recipe> allRecipes = [];

      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        String documentId = snapshot.id;
        List<Recipe> recipes =
            await getRecipes(context: context, documentID: documentId).first;
        allRecipes.addAll(recipes);
      }

      yield allRecipes;
    }
  }

  Stream<List<Recipe>> fetchAllRecipesByCategory(
      BuildContext context, String category) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = DatabaseCollections.recipes;

    Stream<QuerySnapshot> querySnapshotStream = firestore
        .collection(collectionPath)
        .where('category', isEqualTo: category)
        .orderBy("createdAt", descending: true)
        .snapshots();

    await for (QuerySnapshot querySnapshot in querySnapshotStream) {
      List<Recipe> allRecipes = [];

      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        String documentId = snapshot.id;
        List<Recipe> recipes =
            await getRecipes(context: context, documentID: documentId).first;
        allRecipes.addAll(recipes);
      }
      yield allRecipes;
    }
  }

  Stream<List<Recipe>> fetchAllRecipesByPopular(BuildContext context) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = DatabaseCollections.recipes;
    Stream<QuerySnapshot> querySnapshotStream = firestore
        .collection(collectionPath)
        .orderBy(FieldPath.documentId, descending: true)
        .snapshots();

    await for (QuerySnapshot querySnapshot in querySnapshotStream) {
      List<Recipe> allRecipes = [];

      List<Future<List<Recipe>>> recipeFutures =
          querySnapshot.docs.map((snapshot) {
        String documentId = snapshot.id;
        return getRecipes(context: context, documentID: documentId).first;
      }).toList();

      List<List<Recipe>> recipesLists = await Future.wait(recipeFutures);

      allRecipes = recipesLists.expand((recipes) => recipes).toList();

      allRecipes.sort((a, b) => b.likes.length.compareTo(a.likes.length));

      yield allRecipes;
    }
  }

  Stream<List<Recipe>> fetchAllRecipesSortedByAverageRatingStream(
      BuildContext context) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String recipesCollectionPath = DatabaseCollections.recipes;

    QuerySnapshot recipeSnapshot =
        await firestore.collection(recipesCollectionPath).get();
    List<Recipe> recipes = recipeSnapshot.docs.map((doc) {
      return Recipe.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    Map<String, double> averageRatings = {};

    List<Future<void>> ratingFutures = [];

    for (Recipe recipe in recipes) {
      ratingFutures.add(
        getAverageReviewsRating(recipe.id, context).then((rating) {
          averageRatings[recipe.id] = rating;
        }),
      );
    }

    await Future.wait(ratingFutures);

    recipes
        .sort((a, b) => averageRatings[b.id]!.compareTo(averageRatings[a.id]!));

    yield recipes;
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

  Stream<List> fetchReviewsByRecipeID(
      BuildContext context, String recipeID) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = DatabaseCollections.reviews;
    QuerySnapshot querySnapshot = await firestore
        .collection(collectionPath)
        .where('recipeID', isEqualTo: recipeID)
        .get();

    List allReviews = [];

    for (DocumentSnapshot snapshot in querySnapshot.docs) {
      String documentId = snapshot.id;
      await for (List reviews
          in getReviews(context: context, documentID: documentId)) {
        allReviews.addAll(reviews);
      }
    }

    yield allReviews;
  }

  Future<void> like(
      {required BuildContext context,
      required String recipeId,
      required List<String> likers}) async {
    final result = await bloc.like(recipeId, likers);
    return result.fold(
      (l) => l,
      (r) => r,
    );
  }

  Future<void> follow(
      {required BuildContext context,
      required String chefId,
      required List<String> followers,
      required List<String> token}) async {
    final result = await chefBloc.follow(chefId, followers, token);
    return result.fold(
      (l) => l,
      (r) => r,
    );
  }

  Stream<int> retrieveFollowersCount(
      {required BuildContext context, required String chefId}) async* {
    while (true) {
      final result = await chefBloc.retrieve(chefId);
      yield result.fold(
        (l) {
          return 0;
        },
        (r) => r.followers.length,
      );
    }
  }

  Future<double> getAverageReviewsRating(
      String recipeId, BuildContext context) async {
    double sum = 0;
    int count = 0;
    await for (var reviews in fetchReviewsByRecipeID(context, recipeId)) {
      for (var review in reviews) {
        sum += review.rating;
        count++;
      }
    }
    return count != 0 ? sum / count : 0;
  }

  Future<Chef> retrieve(
      {required BuildContext context, required String chefId}) async {
    final result = await chefBloc.retrieve(chefId);
    return result.fold(
      (l) {
        return Chef.initial();
      },
      (r) => r,
    );
  }

  Future<List<String>> getCurrentUsersFollowers(
      BuildContext context, String currentChefId) async {
    try {
      Chef currentChef =
          await retrieve(context: context, chefId: currentChefId);
      return currentChef.followers;
    } catch (e) {
      return [];
    }
  }

  Stream<Chef> retrieveChefStream(
      {required BuildContext context, required String chefId}) async* {
    final result = await chefBloc.retrieve(chefId);
    yield* result.fold(
      (l) {
        return const Stream.empty();
      },
      (r) => Stream.value(r),
    );
  }

  Stream<List<Chef>> listChefStreams() async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = DatabaseCollections.chefs;
    Stream<QuerySnapshot> querySnapshotStream = firestore
        .collection(collectionPath)
        .orderBy(FieldPath.documentId, descending: true)
        .snapshots();
    await for (QuerySnapshot querySnapshot in querySnapshotStream) {
      List<Chef> chefs = [];
      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        Chef chef = Chef(
          id: snapshot.id,
          name: snapshot['name'],
          email: snapshot['email'],
          token: (snapshot['token'] as List<dynamic>).cast<String>(),
          chefToken: snapshot['chefToken'],
          followers: (snapshot['followers'] as List<dynamic>).cast<String>(),
          favorites: (snapshot['favorites'] as List<dynamic>).cast<String>(),
        );
        chefs.add(chef);
      }
      yield chefs;
    }
  }

  Stream<List<Chef>> listChefStream(String currentUserID) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = DatabaseCollections.chefs;

    Stream<QuerySnapshot> querySnapshotStream = firestore
        .collection(collectionPath)
        .where(FieldPath.documentId, isNotEqualTo: currentUserID)
        .orderBy(FieldPath.documentId, descending: true)
        .snapshots();

    await for (QuerySnapshot querySnapshot in querySnapshotStream) {
      List<Chef> chefs = [];
      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        Chef chef = Chef(
          id: snapshot.id,
          name: snapshot['name'],
          email: snapshot['email'],
          token: (snapshot['token'] as List<dynamic>).cast<String>(),
          chefToken: snapshot['chefToken'],
          followers: (snapshot['followers'] as List<dynamic>).cast<String>(),
          favorites: (snapshot['favorites'] as List<dynamic>).cast<String>(),
        );
        chefs.add(chef);
      }
      yield chefs;
    }
  }
}
