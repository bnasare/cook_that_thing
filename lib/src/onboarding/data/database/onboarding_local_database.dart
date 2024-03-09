abstract class OnboardingLocalDatabase {
  Future<bool> isOnboardingComplete();
  Future<void> completeOnboarding();
}

class OnboardingLocalDatabaseImpl implements OnboardingLocalDatabase {
  static const onboardingCompleteKey = 'onboardingComplete';
  @override
  Future<bool> isOnboardingComplete() async {
    throw UnimplementedError();

    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getBool(onboardingCompleteKey) ?? false;
  }

  @override
  Future<void> completeOnboarding() async {
    throw UnimplementedError();

    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool(onboardingCompleteKey, true);
  }
}
