import '../../../../injection_container.dart';
import 'onboarding_bloc.dart';

mixin OnboardingMixin {
  final bloc = sl<OnboardingBloc>();

  Future<void> completeOnboardingChecks() async {
    final result = await bloc.completeOnboardingChecks();

    result.fold(
      (l) => l,
      (r) => r,
    );
  }

  Future<bool> checkIfOnboardingIsComplete() async {
    final result = await bloc.checkIfOnboardingIsComplete();

    return result.fold(
      (l) => false,
      (r) => r,
    );
  }
}
