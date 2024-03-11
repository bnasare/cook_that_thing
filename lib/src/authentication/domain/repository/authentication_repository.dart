import 'package:dartz/dartz.dart';
import 'package:recipe_hub/core/chef/domain/entities/chef.dart';
import 'package:recipe_hub/shared/error/failure.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, Chef>> signUp(
      String email, String password, String name);
  Future<Either<Failure, Chef>> logout();
  Future<Either<Failure, Chef>> login(String email, String password);
  Future<Either<Failure, Chef>> googleSignIn();
}
