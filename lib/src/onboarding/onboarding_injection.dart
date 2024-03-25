import 'package:get_it/get_it.dart';
import 'domain/repository/onboarding_repository.dart';

import 'data/database/onboarding_local_database.dart';
import 'data/repository/onboarding_repository_impl.dart';
import 'domain/usecase/complete_onboarding.dart';
import 'domain/usecase/is_onboarding_complete.dart';
import 'presentation/bloc/onboarding_bloc.dart';

void initOnboarding() {
  final sl = GetIt.instance;

  sl.registerFactory(() =>
      OnboardingBloc(completeOnboarding: sl(), checkOnboardingComplete: sl()));
  sl.registerLazySingleton<OnboardingLocalDatabase>(
      () => OnboardingLocalDatabaseImpl());

  sl.registerLazySingleton<OnboardingRepository>(() => OnboardingRepositoryImpl(
        localDatabase: sl(),
      ));

  sl.registerLazySingleton(() => CompleteOnboarding(sl()));
  sl.registerLazySingleton(() => CheckOnboardingComplete(sl()));
}
