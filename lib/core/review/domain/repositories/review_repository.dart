import 'package:dartz/dartz.dart';

import '../../../../shared/error/failure.dart';
import '../entities/review.dart';

abstract class ReviewRepository {
  Future<Either<Failure, Review>> createReview(
    String name,
    String review,
    DateTime time,
    String recipeID,
    double rating,
    String chefToken,
    String chefID,
  );
  Future<Either<Failure, List<Review>>> list(List<String> documentID);
}
