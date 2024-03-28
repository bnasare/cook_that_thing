// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../injection_container.dart';
import '../../../../shared/data/collection_ids.dart';
import '../../../../shared/data/firebase_constants.dart';
import '../../../../shared/platform/push_notification.dart';
import '../../../recipes/domain/entities/recipe.dart';
import '../../../recipes/presentation/bloc/recipe_bloc.dart';
import '../../domain/entities/review.dart';
import 'review_bloc.dart';

mixin ReviewMixin {
  final bloc = sl<ReviewBloc>();
  final recipeBloc = sl<RecipeBloc>();

  Future<void> createAReview({
    required BuildContext context,
    required String name,
    required String review,
    required DateTime time,
    required String recipeID,
    required double rating,
  }) async {
    final result =
        await bloc.createAReview(name, review, time, recipeID, rating);
    return result.fold(
      (l) => l,
      (r) async {
        DocumentSnapshot recipeDoc = await FirebaseFirestore.instance
            .collection(DatabaseCollections.recipes)
            .doc(recipeID)
            .get();

        String chefToken = recipeDoc['chefToken'] ?? '';

        if (chefToken.isNotEmpty) {
          final PushNotification pushNotification =
              PushNotificationImpl(FlutterLocalNotificationsPlugin());

          String notificationTitle = 'New Review!';
          String notificationBody =
              '${FirebaseConsts.currentUser!.displayName} left a review!';

          if (recipeDoc['chefID'] == FirebaseAuth.instance.currentUser!.uid) {
            // User reviewed their own recipe
            notificationTitle = 'You reviewed your own recipe!';
            notificationBody = 'Check out your review.';
          }

          await pushNotification.sendPushNotifs(
            title: notificationTitle,
            body: notificationBody,
            token: chefToken,
          );
        }
      },
    );
  }

  Future<List<Review>> getReviews({
    required BuildContext context,
    required String documentID,
  }) async {
    final result = await bloc.getReviews(documentID);
    return result.fold(
      (l) {
        return <Review>[];
      },
      (r) => r,
    );
  }

  Stream<List<Review>> fetchReviewsByRecipeID(
      BuildContext context, String recipeID) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = DatabaseCollections.reviews;

    Stream<QuerySnapshot> querySnapshotStream = firestore
        .collection(collectionPath)
        .where('recipeID', isEqualTo: recipeID)
        .orderBy('time', descending: true)
        .snapshots();

    await for (QuerySnapshot querySnapshot in querySnapshotStream) {
      List<Review> allReviews = [];
      List<Future<List<Review>>> reviewFutures = [];

      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        String documentId = snapshot.id;
        reviewFutures.add(getReviews(context: context, documentID: documentId));
      }

      List<List<Review>> reviewsLists = await Future.wait(reviewFutures);
      allReviews = reviewsLists.expand((reviews) => reviews).toList();

      yield allReviews;
    }
  }

  Stream<List<Review>> fetchReviewsByChefID(
      BuildContext context, String recipeID) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = DatabaseCollections.reviews;

    Stream<QuerySnapshot> querySnapshotStream = firestore
        .collection(collectionPath)
        .where('chefID', isEqualTo: recipeID)
        .orderBy('time', descending: true)
        .snapshots();

    await for (QuerySnapshot querySnapshot in querySnapshotStream) {
      List<Review> allReviews = [];
      List<Future<List<Review>>> reviewFutures = [];

      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        String documentId = snapshot.id;
        reviewFutures.add(getReviews(context: context, documentID: documentId));
      }

      List<List<Review>> reviewsLists = await Future.wait(reviewFutures);
      allReviews = reviewsLists.expand((reviews) => reviews).toList();

      yield allReviews;
    }
  }

  Stream<Recipe> getRecipe({
    required BuildContext context,
    required String documentID,
  }) async* {
    final result = await recipeBloc.getRecipes(documentID);
    yield result.fold(
      (l) {
        return Recipe.initial();
      },
      (r) {
        return r.firstWhere((recipe) => recipe.id == documentID,
            orElse: () => Recipe.initial());
      },
    );
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

  Future<double> getAverageReviewsRatingForChef(
      String chefId, BuildContext context) async {
    double sum = 0;
    int count = 0;
    await for (var reviews in fetchReviewsByChefID(context, chefId)) {
      for (var review in reviews) {
        sum += review.rating;
        count++;
      }
    }
    return count != 0 ? sum / count : 0;
  }

  Future<double> getAverageReviewsRatingForRecipeAsync(
      Stream<List<Review>> reviewsStream, String recipeID) async {
    double totalRating = 0.0;
    int reviewCount = 0;

    await for (List<Review> reviews in reviewsStream) {
      // Filter reviews for the specific recipe ID
      List<Review> reviewsForRecipe =
          reviews.where((review) => review.recipeID == recipeID).toList();

      if (reviewsForRecipe.isNotEmpty) {
        for (Review review in reviewsForRecipe) {
          totalRating += review.rating;
        }
        reviewCount += reviewsForRecipe.length;
      }
    }

    return reviewCount > 0 ? totalRating / reviewCount : 0.0;
  }
}
