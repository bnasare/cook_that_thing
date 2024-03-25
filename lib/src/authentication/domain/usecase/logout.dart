import 'package:dartz/dartz.dart';
import '../../../../shared/error/failure.dart';
import '../../../../shared/usecase/usecase.dart';
import '../repository/authentication_repository.dart';

import '../../../../core/chef/domain/entities/chef.dart';

class Logout implements UseCase<Chef, NoParams> {
  AuthenticationRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, Chef>> call(NoParams params) {
    return repository.logout();
  }
}
