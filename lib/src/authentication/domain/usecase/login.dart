import 'package:dartz/dartz.dart';
import 'package:recipe_hub/shared/usecase/usecase.dart';

import '../../../../core/chef/domain/entities/chef.dart';
import '../../../../shared/error/failure.dart';
import '../repository/authentication_repository.dart';

class Login implements UseCase<Chef, LoginParams> {
  final AuthenticationRepository repository;
  Login(this.repository);
  @override
  Future<Either<Failure, Chef>> call(LoginParams params) {
    return repository.login(params.email, params.password);
  }
}
