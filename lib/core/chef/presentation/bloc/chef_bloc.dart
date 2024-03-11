import 'package:dartz/dartz.dart';
import 'package:recipe_hub/core/chef/domain/usecase.dart/follow.dart';
import 'package:recipe_hub/core/chef/domain/usecase.dart/retrieve.dart';
import 'package:recipe_hub/shared/usecase/usecase.dart';

import '../../../../shared/error/failure.dart';
import '../../domain/entities/chef.dart';

class ChefBloc {
  final RetrieveChef retrieveChef;
  final FollowChef followChef;
  ChefBloc({required this.retrieveChef, required this.followChef});

  Future<Either<Failure, Chef>> retrieve(String chefId) async {
    return await retrieveChef(ObjectParams<String>(chefId));
  }

  Future<Either<Failure, Chef>> follow(
      String chefId, List<String> followers, List<String> token) async {
    return await followChef(
        FollowChefParams(value: chefId, params: followers, params2: token));
  }
}
