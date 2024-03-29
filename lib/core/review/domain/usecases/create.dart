import 'package:dartz/dartz.dart';

import '../../../../shared/error/failure.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/review.dart';
import '../repositories/review_repository.dart';

class CreateReview implements UseCase<Review, ReviewParams> {
  final ReviewRepository repository;

  CreateReview(this.repository);

  @override
  Future<Either<Failure, Review>> call(ReviewParams params) async {
    return await repository.createReview(
      params.name,
      params.review,
      params.time,
      params.recipeID,
      params.rating,
      params.chefToken,
      params.chefID,
    );
  }
}

class ReviewParams extends ObjectParams<Review> {
  ReviewParams({
    required String name,
    required String review,
    required DateTime time,
    required String recipeID,
    required double rating,
    required String chefToken,
    required String chefID,
  }) : super(
          Review(
            name: name,
            review: review,
            time: time,
            recipeID: recipeID,
            rating: rating,
            chefToken: chefToken,
            chefID: chefID,
          ),
        );

  String get name => value.name;
  String get review => value.review;
  DateTime get time => value.time;
  String get recipeID => value.recipeID;
  double get rating => value.rating;
  String get chefToken => value.chefToken;
  String get chefID => value.chefID;
}
