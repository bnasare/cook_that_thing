import 'package:dartz/dartz.dart';
import 'package:recipe_hub/shared/usecase/usecase.dart';

import '../../../../shared/error/failure.dart';
import '../entities/chef.dart';
import '../repository/chef_repository.dart';

class ListChef implements UseCase<List<Chef>, NoParams> {
  final ChefRepository repository;
  ListChef(this.repository);
  @override
  Future<Either<Failure, List<Chef>>> call(NoParams params) async {
    return await repository.list();
  }
}
