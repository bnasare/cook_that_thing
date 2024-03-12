import 'package:dartz/dartz.dart';

import '../../../../shared/error/failure.dart';
import '../entities/chef.dart';

abstract class ChefRepository {
  Future<Either<Failure, Chef>> retrieve(String chefId);
  Future<Either<Failure, Chef>> follow(
    String chefId,
    List<String> followers,
    List<String> token,
  );
  Future<Either<Failure, List<Chef>>> list();
}
