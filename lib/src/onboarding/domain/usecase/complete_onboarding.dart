import 'package:dartz/dartz.dart';

import '../../../../shared/error/failure.dart';
import '../../../../shared/usecase/usecase.dart';
import '../repository/onboarding_repository.dart';

class CompleteOnboarding implements UseCase<Unit, NoParams> {
  final OnboardingRepository repository;
  CompleteOnboarding(this.repository);
  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.completeOnboarding();
  }
}
