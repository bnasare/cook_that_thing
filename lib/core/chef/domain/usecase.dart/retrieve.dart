import 'package:dartz/dartz.dart';

import '../../../../shared/error/failure.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/chef.dart';
import '../repository/chef_repository.dart';

class RetrieveChef implements UseCase<Chef, ObjectParams<String>> {
  ChefRepository repository;

  RetrieveChef(this.repository);
  @override
  Future<Either<Failure, Chef>> call(ObjectParams<String> params) {
    return repository.retrieve(params.value);
  }
}
