import 'package:dartz/dartz.dart';
import '../../../../shared/error/failure.dart';
import '../../../../shared/usecase/usecase.dart';
import '../repository/authentication_repository.dart';

import '../../../../core/chef/domain/entities/chef.dart';

class SignUp implements UseCase<Chef, SignUpParams> {
  final AuthenticationRepository repository;

  SignUp(this.repository);

  @override
  Future<Either<Failure, Chef>> call(SignUpParams params) {
    return repository.signUp(params.email, params.password, params.name);
  }
}
