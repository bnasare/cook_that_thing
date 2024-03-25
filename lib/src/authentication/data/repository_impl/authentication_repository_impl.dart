import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/chef/domain/entities/chef.dart';
import '../../../../shared/error/failure.dart';
import '../../../../shared/platform/network_info.dart';
import '../database/authentication_remote_database.dart';

import '../../../../shared/error/exception.dart';
import '../../domain/repository/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  NetworkInfo networkInfo;
  AuthenticationRemoteDatabase remoteDatabase;

  AuthenticationRepositoryImpl({
    required this.networkInfo,
    required this.remoteDatabase,
  });

  @override
  Future<Either<Failure, Chef>> signUp(
      String email, String password, String name) async {
    try {
      await networkInfo.hasInternet();
      final results = await remoteDatabase.signUp(email, password, name);
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
  Future<Either<Failure, Chef>> logout() async {
    try {
      await networkInfo.hasInternet();
      await remoteDatabase.logout();
      return Right(Chef.initial());
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
  Future<Either<Failure, Chef>> login(String email, String password) async {
    try {
      await networkInfo.hasInternet();
      final results = await remoteDatabase.login(email, password);
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
  Future<Either<Failure, Chef>> googleSignIn() async {
    try {
      await networkInfo.hasInternet();
      final results = await remoteDatabase.googleSignIn();
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
