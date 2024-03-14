// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:recipe_hub/core/review/domain/entities/review.dart';
import 'package:recipe_hub/shared/data/collection_ids.dart';

import '../../../../injection_container.dart';
import '../../../../shared/data/firebase_constants.dart';
import '../../../../shared/platform/push_notification.dart';
import '../../../recipes/domain/entities/recipe.dart';
import '../../../recipes/presentation/bloc/recipe_bloc.dart';
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

          await pushNotification.sendPushNotifs(
            title: 'New Review!',
            body: '${FirebaseConsts.currentUser!.displayName} left a review!',
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
      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        List<Review> reviews =
            await getReviews(context: context, documentID: snapshot.id);
        allReviews.addAll(reviews);
      }
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
}
