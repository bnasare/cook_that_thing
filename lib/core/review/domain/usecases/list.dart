import 'package:dartz/dartz.dart';
import 'package:recipe_hub/core/review/domain/entities/review.dart';
import 'package:recipe_hub/core/review/domain/repositories/review_repository.dart';

import '../../../../shared/error/failure.dart';
import '../../../../shared/usecase/usecase.dart';

class ListReview implements UseCase<List<Review>, ObjectParams<List<String>>> {
  final ReviewRepository repository;

  ListReview(this.repository);

  @override
  Future<Either<Failure, List<Review>>> call(
      ObjectParams<List<String>> params) async {
    return await repository.list(params.value);
  }
}
