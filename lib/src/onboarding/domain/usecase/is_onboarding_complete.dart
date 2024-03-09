import 'package:dartz/dartz.dart';

import '../../../../shared/error/failure.dart';
import '../../../../shared/usecase/usecase.dart';
import '../repository/onboarding_repository.dart';

class CheckOnboardingComplete implements UseCase<bool, NoParams> {
  final OnboardingRepository repository;
  CheckOnboardingComplete(this.repository);
  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.isOnboardingComplete();
  }
}
