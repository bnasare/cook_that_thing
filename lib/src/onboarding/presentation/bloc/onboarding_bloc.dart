import 'package:dartz/dartz.dart';
import 'package:recipe_hub/src/onboarding/domain/usecase/complete_onboarding.dart';
import 'package:recipe_hub/src/onboarding/domain/usecase/is_onboarding_complete.dart';

import '../../../../shared/error/failure.dart';
import '../../../../shared/usecase/usecase.dart';

class OnboardingBloc {
  final CompleteOnboarding completeOnboarding;
  final CheckOnboardingComplete checkOnboardingComplete;
  OnboardingBloc(
      {required this.completeOnboarding,
      required this.checkOnboardingComplete});

  Future<Either<Failure, Unit>> completeOnboardingChecks() async {
    return await completeOnboarding(NoParams());
  }

  Future<Either<Failure, bool>> checkIfOnboardingIsComplete() async {
    return await checkOnboardingComplete(NoParams());
  }
}
