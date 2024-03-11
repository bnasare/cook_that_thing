import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipe_hub/firebase_options.dart';
import 'package:recipe_hub/shared/presentation/theme/theme.dart';
import 'package:recipe_hub/src/authentication/presentation/interface/pages/wrapper.dart';
import 'package:recipe_hub/src/onboarding/presentation/bloc/onboarding_mixin.dart';

import 'injection_container.dart' as di;
import 'injection_container.dart';
import 'shared/platform/push_notification.dart';
import 'src/onboarding/presentation/interface/pages/onboarding.dart';

Future<void> backgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    log('Message handled in the background!');
  }
}

void main() async {
  /// Initialize widgets binding
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Splash Screen
  ///
  /// e1tInqbVQiCYJp-z5CRMd9:APA91bFCBHSCuZiIsu1kClEa0P4UPiJW5P6GFgF0rF6TUT5zXe6aC53zzQXexeQSzG-vo39NpPONrS7o22lVO1HboE_75Y4fLynZoxJUeWhfUWOwOtUUR9t8jA3sBTcnvdd0zHCt4k9m

  /// Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Initialize Dependency Injection
  await di.init();

  // Initialize Push Notification
  await sl<PushNotification>().initializeNotification();
//
  // Register background handler
  FirebaseMessaging.onBackgroundMessage(backgroundMessage);

//
  // Get any messages which caused the application to open from terminated state
  final remoteMessage = FirebaseMessaging.instance.getInitialMessage();
//
  // Get any messages which caused the application to open from background state
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {});

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget with OnboardingMixin {
  MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingCompleteFuture =
        useMemoized(() => checkIfOnboardingIsComplete());
    final snapshot = useFuture(onboardingCompleteFuture);

    return MaterialApp(
      theme: lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: () {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: SizedBox.shrink(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (snapshot.data == true) {
          return const AuthWrapper();
        } else {
          return Onboarding();
        }
      }(),
    );
  }
}
