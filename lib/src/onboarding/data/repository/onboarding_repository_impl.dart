import 'package:dartz/dartz.dart';
import 'package:recipe_hub/shared/error/failure.dart';
import 'package:recipe_hub/src/onboarding/data/database/onboarding_local_database.dart';

import '../../domain/repository/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingLocalDatabase localDatabase;
  OnboardingRepositoryImpl({required this.localDatabase});
  @override
  Future<Either<Failure, bool>> isOnboardingComplete() async {
    final results = await localDatabase.isOnboardingComplete();
    return Right(results);
  }

  @override
  Future<Either<Failure, Unit>> completeOnboarding() async {
    try {
      await localDatabase.completeOnboarding();
      return const Right(unit);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
