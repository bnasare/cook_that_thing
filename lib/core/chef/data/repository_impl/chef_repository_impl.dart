import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/chef.dart';
import '../../../../shared/error/failure.dart';
import '../../../../shared/platform/network_info.dart';

import '../../../../shared/error/exception.dart';
import '../../domain/repository/chef_repository.dart';
import '../database/chef_remote_database.dart';

class ChefRepositoryImpl implements ChefRepository {
  final ChefRemoteDatabase remoteDatabase;
  final NetworkInfo networkInfo;

  ChefRepositoryImpl({required this.networkInfo, required this.remoteDatabase});

  @override
  Future<Either<Failure, Chef>> retrieve(String chefId) async {
    try {
      await networkInfo.hasInternet();
      final result = await remoteDatabase.retrieve(chefId);
      return Right(result);
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
  Future<Either<Failure, Chef>> follow(
      String chefId, List<String> followers, List<String> token) async {
    try {
      await networkInfo.hasInternet();
      final result = await remoteDatabase.follow(chefId, followers, token);
      return Right(result);
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
  Future<Either<Failure, List<Chef>>> list() async {
    try {
      await networkInfo.hasInternet();
      final result = await remoteDatabase.list();
      return Right(result);
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
