import 'package:dartz/dartz.dart';

import '../../../../shared/data/firebase_constants.dart';
import '../../../../shared/error/failure.dart';
import '../../../../shared/usecase/usecase.dart';
import '../../domain/entities/review.dart';
import '../../domain/usecases/create.dart';
import '../../domain/usecases/list.dart';

class ReviewBloc {
  CreateReview createReview;
  ListReview listReview;

  ReviewBloc({required this.createReview, required this.listReview});

  Future<Either<Failure, Review>> createAReview(
    String name,
    String review,
    DateTime time,
    String recipeID,
    double rating,
    String chefID,
  ) async {
    return await createReview(ReviewParams(
      name: name,
      review: review,
      time: time,
      recipeID: recipeID,
      rating: rating,
      chefToken: await FirebaseConsts.messaging.getToken() ?? '',
      chefID: chefID,
    ));
  }

  Future<Either<Failure, List<Review>>> getReviews(String documentID) async {
    return await listReview(ObjectParams<List<String>>([documentID]));
  }
}
