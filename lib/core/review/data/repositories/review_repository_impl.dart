import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../shared/error/exception.dart';
import '../../../../shared/error/failure.dart';
import '../../../../shared/platform/network_info.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../database/review_remote_database.dart';

class ReviewRepositoryImplementation implements ReviewRepository {
  NetworkInfo networkInfo;
  ReviewRemoteDatabase remoteDatabase;

  ReviewRepositoryImplementation({
    required this.networkInfo,
    required this.remoteDatabase,
  });

  @override
  Future<Either<Failure, Review>> createReview(
    String name,
    String review,
    DateTime time,
    String recipeID,
    double rating,
    String chefToken,
  ) async {
    try {
      await networkInfo.hasInternet();
      final results = await remoteDatabase.createReview(
        name,
        review,
        time,
        recipeID,
        rating,
        chefToken,
      );
      return Right(results);
    } on FirebaseAuthException catch (error) {
      return Left(Failure(
          error.message ?? 'Unexpected error occurred... Please try again'));
    } on DeviceException catch (error) {
      return Left(Failure(error.message));
    } on FirebaseException catch (error) {
      return Left(Failure(
          error.message ?? 'Unexpected error occurred... Please try again'));
    } catch (error) {
      return const Left(Failure('Something went wrong... Please try again'));
    }
  }

  @override
  Future<Either<Failure, List<Review>>> list(List<String> documentID) async {
    try {
      await networkInfo.hasInternet();
      final results = await remoteDatabase.list(documentID);
      return Right(results);
    } on FirebaseAuthException catch (error) {
      return Left(Failure(
          error.message ?? 'Unexpected error occurred... Please try again'));
    } on DeviceException catch (error) {
      return Left(Failure(error.message));
    } on FirebaseException catch (error) {
      return Left(Failure(
          error.message ?? 'Unexpected error occurred... Please try again'));
    } catch (error) {
      return const Left(Failure('Something went wrong... Please try again'));
    }
  }
}
