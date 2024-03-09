import 'package:dartz/dartz.dart';
import 'package:recipe_hub/shared/error/failure.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, bool>> isOnboardingComplete();
  Future<Either<Failure, Unit>> completeOnboarding();
}
