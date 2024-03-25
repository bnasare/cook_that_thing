import 'package:dartz/dartz.dart';

import '../../../../shared/error/failure.dart';
import '../../../../shared/usecase/usecase.dart';
import '../../domain/entities/chef.dart';
import '../../domain/usecase.dart/follow.dart';
import '../../domain/usecase.dart/list.dart';
import '../../domain/usecase.dart/retrieve.dart';

class ChefBloc {
  final RetrieveChef retrieveChef;
  final FollowChef followChef;
  final ListChef listChef;

  ChefBloc(
      {required this.retrieveChef,
      required this.followChef,
      required this.listChef});

  Future<Either<Failure, Chef>> retrieve(String chefId) async {
    return await retrieveChef(ObjectParams<String>(chefId));
  }

  Future<Either<Failure, Chef>> follow(
      String chefId, List<String> followers, List<String> token) async {
    return await followChef(
        FollowChefParams(value: chefId, params: followers, params2: token));
  }

  Future<Either<Failure, List<Chef>>> list() async {
    return await listChef(NoParams());
  }
}
