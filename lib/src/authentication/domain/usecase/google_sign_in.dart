import 'package:dartz/dartz.dart';
import '../../../../shared/usecase/usecase.dart';

import '../../../../core/chef/domain/entities/chef.dart';
import '../../../../shared/error/failure.dart';
import '../repository/authentication_repository.dart';

class SignInWithGoogle implements UseCase<Chef, NoParams> {
  final AuthenticationRepository repository;
  SignInWithGoogle(this.repository);

  @override
  Future<Either<Failure, Chef>> call(NoParams params) {
    return repository.googleSignIn();
  }
}
