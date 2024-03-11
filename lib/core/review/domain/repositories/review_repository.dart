import 'package:dartz/dartz.dart';
import 'package:recipe_hub/core/review/domain/entities/review.dart';
import 'package:recipe_hub/shared/error/failure.dart';

abstract class ReviewRepository {
  Future<Either<Failure, Review>> createReview(
    String name,
    String review,
    DateTime time,
    String recipeID,
    double rating,
  );
  Future<Either<Failure, List<Review>>> list(List<String> documentID);
}
