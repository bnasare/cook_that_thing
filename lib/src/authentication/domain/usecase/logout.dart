import 'package:dartz/dartz.dart';
import 'package:recipe_hub/shared/error/failure.dart';
import 'package:recipe_hub/shared/usecase/usecase.dart';
import 'package:recipe_hub/src/authentication/domain/repository/authentication_repository.dart';

import '../../../../core/chef/domain/entities/chef.dart';

class Logout implements UseCase<Chef, NoParams> {
  AuthenticationRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, Chef>> call(NoParams params) {
    return repository.logout();
  }
}
