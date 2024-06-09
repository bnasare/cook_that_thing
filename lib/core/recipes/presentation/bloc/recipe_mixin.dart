// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../injection_container.dart';
import '../../../../shared/data/collection_ids.dart';
import '../../../../shared/data/firebase_constants.dart';
import '../../../../shared/platform/push_notification.dart';
import '../../../../shared/presentation/widgets/snackbar.dart';
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

            // Send notification to chefToken (if not empty)
            final String chefToken = chef.chefToken;
            if (chefToken.isNotEmpty) {
              await pushNotification.sendPushNotifs(
                title: 'Your Recipe is Live!',
                body: 'Your recipe "$title" has been created!',
                token: chefToken,
              );
            }

            // Send notifications to tokens array (if not empty)
            final List<String> tokens = chef.token;
            if (tokens.isNotEmpty) {
              for (final singleToken in tokens) {
                await pushNotification.sendPushNotifs(
                  title: 'New Recipe Created',
                  body:
                      '${FirebaseConsts.currentUser!.displayName} created a new recipe!',
                  token: singleToken,
                );
              }
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

  Stream<List<Recipe>> fetchAllRecipes(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = DatabaseCollections.recipes;

    BehaviorSubject<List<Recipe>> subject = BehaviorSubject<List<Recipe>>();

    Stream<QuerySnapshot> querySnapshotStream = firestore
        .collection(collectionPath)
        .orderBy("createdAt", descending: true)
        .snapshots();

    querySnapshotStream.listen((QuerySnapshot querySnapshot) async {
      List<Recipe> allRecipes = [];

      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        String documentId = snapshot.id;
        List<Recipe> recipes =
            await getRecipes(context: context, documentID: documentId).first;
        allRecipes.addAll(recipes);
      }

      subject.add(allRecipes);
    }, onError: subject.addError);

    return subject.stream;
  }

  Stream<List<Recipe>> fetchAllRecipess(BuildContext context) async* {
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

  // Stream<List<Recipe>> fetchAllRecipesByPopular(BuildContext context) async* {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   String collectionPath = DatabaseCollections.recipes;
  //   Stream<QuerySnapshot> querySnapshotStream = firestore
  //       .collection(collectionPath)
  //       .orderBy(FieldPath.documentId, descending: true)
  //       .snapshots();

  //   await for (QuerySnapshot querySnapshot in querySnapshotStream) {
  //     List<Recipe> allRecipes = [];

  //     List<Future<List<Recipe>>> recipeFutures =
  //         querySnapshot.docs.map((snapshot) {
  //       String documentId = snapshot.id;
  //       return getRecipes(context: context, documentID: documentId).first;
  //     }).toList();

  //     List<List<Recipe>> recipesLists = await Future.wait(recipeFutures);

  //     allRecipes = recipesLists.expand((recipes) => recipes).toList();

  //     allRecipes.sort((a, b) => b.likes.length.compareTo(a.likes.length));

  //     yield allRecipes;
  //   }
  // }

  // Stream<List<Recipe>> fetchAllRecipesSortedByAverageRatingStream(
  //     BuildContext context) {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   String recipesCollectionPath = DatabaseCollections.recipes;

  //   BehaviorSubject<List<Recipe>> subject = BehaviorSubject<List<Recipe>>();

  //   firestore.collection(recipesCollectionPath).snapshots().listen(
  //       (QuerySnapshot recipeSnapshot) async {
  //     List<Recipe> recipes = recipeSnapshot.docs.map((doc) {
  //       return Recipe.fromJson(doc.data() as Map<String, dynamic>);
  //     }).toList();

  //     Map<String, double> averageRatings = {};

  //     List<Future<void>> ratingFutures = [];

  //     for (Recipe recipe in recipes) {
  //       ratingFutures.add(
  //         getAverageReviewsRating(recipe.id, context).then((rating) {
  //           averageRatings[recipe.id] = rating;
  //         }),
  //       );
  //     }

  //     await Future.wait(ratingFutures);

  //     recipes.sort(
  //         (a, b) => averageRatings[b.id]!.compareTo(averageRatings[a.id]!));

  //     subject.add(List.from(recipes));
  //   }, onError: subject.addError);

  //   return subject.stream;
  // }

  Stream<List<Recipe>> fetchAllRecipesSortedByAverageRatingStream(
      BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = DatabaseCollections.recipes;

    BehaviorSubject<List<Recipe>> subject = BehaviorSubject<List<Recipe>>();

    Stream<QuerySnapshot> querySnapshotStream =
        firestore.collection(collectionPath).snapshots();

    querySnapshotStream.listen((QuerySnapshot querySnapshot) async {
      List<Recipe> allRecipes = [];

      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        String documentId = snapshot.id;
        List<Recipe> recipes =
            await getRecipes(context: context, documentID: documentId).first;
        allRecipes.addAll(recipes);
      }

      Map<String, double> averageRatings = {};

      List<Future<void>> ratingFutures = [];

      for (Recipe recipe in allRecipes) {
        ratingFutures.add(
          getAverageReviewsRatingStreamm(recipe.id, context)
              .first
              .then((rating) {
            // Only include recipes with non-zero ratings
            if (rating != 0) {
              averageRatings[recipe.id] = rating;
            }
          }),
        );
      }

      await Future.wait(ratingFutures);

      // Remove recipes with a rating of 0 from the list
      allRecipes.retainWhere((recipe) => averageRatings.containsKey(recipe.id));

      allRecipes.sort(
        (a, b) => averageRatings[b.id]!.compareTo(averageRatings[a.id]!),
      );

      subject.add(allRecipes);
    }, onError: subject.addError);

    return subject.stream;
  }

  Stream<double> getAverageReviewsRatingStreamm(
    String recipeId,
    BuildContext context,
  ) async* {
    double sum = 0;
    int count = 0;

    await for (var reviews in fetchReviewsByRecipeID(context, recipeId)) {
      for (var review in reviews) {
        sum += review.rating;
        count++;
      }
      yield count != 0 ? sum / count : 0;
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

  Stream<List> fetchReviewsByRecipeID(
      BuildContext context, String recipeID) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = DatabaseCollections.reviews;

    Stream<QuerySnapshot> querySnapshotStream = firestore
        .collection(collectionPath)
        .where('recipeID', isEqualTo: recipeID)
        .snapshots();

    await for (QuerySnapshot querySnapshot in querySnapshotStream) {
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

  Stream<double> getAverageReviewsRatingStream(
    String recipeId,
    BuildContext context,
  ) async* {
    double sum = 0;
    int count = 0;

    await for (var reviews in fetchReviewsByRecipeID(context, recipeId)) {
      for (var review in reviews) {
        sum += review.rating;
        count++;
      }
      yield count != 0 ? sum / count : 0;
    }
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

  Stream<List<Chef>> listChefStreams() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = DatabaseCollections.chefs;

    BehaviorSubject<List<Chef>> subject = BehaviorSubject<List<Chef>>();

    StreamSubscription<QuerySnapshot> subscription;

    Stream<QuerySnapshot> querySnapshotStream = firestore
        .collection(collectionPath)
        .orderBy(FieldPath.documentId, descending: true)
        .snapshots();

    subscription =
        querySnapshotStream.listen((QuerySnapshot querySnapshot) async {
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
      subject.add(List.from(chefs));
    }, onError: (error) {
      subject.addError(error);
    });

    Stream<List<Chef>> stream = subject.stream;

    stream.listen(null, onDone: () {
      subject.close();
      subscription.cancel();
    });

    return stream;
  }

  Stream<List<Chef>> listChefStream(String currentUserID) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = DatabaseCollections.chefs;

    // Create a BehaviorSubject to emit and listen to changes in the list of chefs
    BehaviorSubject<List<Chef>> chefSubject = BehaviorSubject<List<Chef>>();

    // Create a StreamSubscription to listen to changes in the list of chefs
    // ignore: unused_local_variable
    StreamSubscription<QuerySnapshot> querySnapshotSubscription;

    // Define the query snapshot stream
    Stream<QuerySnapshot> querySnapshotStream = firestore
        .collection(collectionPath)
        .where(FieldPath.documentId, isNotEqualTo: currentUserID)
        .orderBy(FieldPath.documentId, descending: true)
        .snapshots();

    // Listen to changes in the Firestore query snapshot
    querySnapshotSubscription = querySnapshotStream.listen((querySnapshot) {
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
      // Emit the list of chefs to the BehaviorSubject
      chefSubject.add(chefs);
    }, onError: (error) {
      // Handle errors by emitting an error event to the BehaviorSubject
      chefSubject.addError(error);
    });

    // Return the stream from the BehaviorSubject
    return chefSubject.stream;
  }
}
