import 'package:dartz/dartz.dart';

import '../../../../shared/error/failure.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/chef.dart';
import '../repository/chef_repository.dart';

class FollowChef implements UseCase<Chef, FollowChefParams> {
  ChefRepository repository;
  FollowChef(this.repository);
  @override
  Future<Either<Failure, Chef>> call(FollowChefParams params) {
    return repository.follow(params.id, params.followers, params.token);
  }
}

class FollowChefParams extends ObjectParams<Chef> {
  FollowChefParams({
    required String value,
    required List<String> params,
    required List<String> params2,
  }) : super(Chef(
          name: value,
          email: value,
          id: value,
          chefToken: value,
          followers: params,
          token: params2,
          favorites: [],
        ));

  List<String> get followers => value.followers;

  List<String> get token => value.token;

  String get id => value.id;
}
