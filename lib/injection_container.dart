import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/chef/chef_injection.dart';
import 'core/recipes/recipe_injection.dart';
import 'core/review/review_injection.dart';
import 'shared/platform/network_info.dart';
import 'shared/platform/push_notification.dart';
import 'src/authentication/auth_injection.dart';
import 'src/onboarding/onboarding_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  initAuth();
  initChef();
  initRecipe();
  initReview();
  initOnboarding();

  sl
    ..registerLazySingleton(http.Client.new)
    ..registerLazySingleton<NetworkInfo>(NetworkInfoImpl.new)
    ..registerFactory<FirebaseMessaging>(() => FirebaseMessaging.instance)
    ..registerFactory<FlutterLocalNotificationsPlugin>(
        FlutterLocalNotificationsPlugin.new)
    ..registerLazySingleton<PushNotification>(() => PushNotificationImpl(sl()));

  sl.registerSingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance());

  await sl.allReady();
}
