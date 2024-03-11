// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_hub/core/review/domain/entities/review.dart';
import 'package:recipe_hub/shared/data/collection_ids.dart';

import '../../../../../injection_container.dart';
import 'review_bloc.dart';

mixin ReviewMixin {
  final bloc = sl<ReviewBloc>();

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
      (r) => r,
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
    QuerySnapshot querySnapshot = await firestore
        .collection(collectionPath)
        .where('recipeID', isEqualTo: recipeID)
        .get();

    List<Review> allReviews = [];

    for (DocumentSnapshot snapshot in querySnapshot.docs) {
      String documentId = snapshot.id;
      List<Review> reviews =
          await getReviews(context: context, documentID: documentId);
      allReviews.addAll(reviews);
    }

    yield allReviews;
  }
}
