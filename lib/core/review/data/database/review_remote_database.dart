import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared/data/collection_ids.dart';

import '../../domain/entities/review.dart';

abstract class ReviewRemoteDatabase {
  Future<Review> createReview(
    String name,
    String review,
    DateTime time,
    String recipeID,
    double rating,
    String chefToken,
  );

  Future<List<Review>> list(List<String> documentIDs);
}

class ReviewRemoteDatabaseImpl implements ReviewRemoteDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Review> createReview(
    String name,
    String review,
    DateTime time,
    String recipeID,
    double rating,
    String chefToken,
  ) async {
    final Review revieww = Review(
      name: name,
      review: review,
      time: time,
      recipeID: recipeID,
      rating: rating,
      chefToken: chefToken,
    );
    final data = revieww.toJson();
    await _firestore.collection(DatabaseCollections.reviews).add(data);
    return revieww;
  }

  @override
  Future<List<Review>> list(List<String> documentIDs) async {
    final review = await FirebaseFirestore.instance
        .collection(DatabaseCollections.reviews)
        .where(FieldPath.documentId, whereIn: documentIDs)
        .get();
    return review.docs.map<Review>((e) => Review.fromJson(e.data())).toList();
  }
}
