import 'package:dartz/dartz.dart';
import '../../../../shared/error/failure.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, bool>> isOnboardingComplete();
  Future<Either<Failure, Unit>> completeOnboarding();
}
