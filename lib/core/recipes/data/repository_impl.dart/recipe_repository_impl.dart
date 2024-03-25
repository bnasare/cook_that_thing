import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../database/recipe_remote_database.dart';
import '../../domain/entities/recipe.dart';
import '../../../../shared/error/failure.dart';
import '../../../../shared/platform/network_info.dart';

import '../../../../shared/error/exception.dart';
import '../../domain/repository/recipe_repository.dart';

class RecipeRepositoryImplementation implements RecipeRepository {
  NetworkInfo networkInfo;
  RecipeRemoteDatabase remoteDatabase;

  RecipeRepositoryImplementation({
    required this.networkInfo,
    required this.remoteDatabase,
  });
  @override
  Future<Either<Failure, Recipe>> createRecipe(
    String diet,
    String difficultyLevel,
    String title,
    String overview,
    String duration,
    String category,
    String image,
    String chef,
    String chefID,
    String id,
    String chefToken,
    DateTime createdAt,
    List<String> likes,
    List<String> ingredients,
    List<String> instructions,
  ) async {
    try {
      await networkInfo.hasInternet();
      final results = await remoteDatabase.createRecipe(
        diet,
        difficultyLevel,
        title,
        overview,
        duration,
        category,
        image,
        chef,
        chefID,
        id,
        chefToken,
        createdAt,
        likes,
        ingredients,
        instructions,
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
  Future<Either<Failure, List<Recipe>>> list(List<String> documentID) async {
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

  @override
  Future<Either<Failure, Recipe>> like(
      String recipeId, List<String> likers) async {
    try {
      await networkInfo.hasInternet();
      final reults = await remoteDatabase.like(recipeId, likers);
      return Right(reults);
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
