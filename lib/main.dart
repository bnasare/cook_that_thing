// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'firebase_options.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';
import 'shared/platform/network_info.dart';
import 'shared/platform/push_notification.dart';
import 'shared/presentation/theme/theme.dart';
import 'shared/utils/connectivity.dart';
import 'shared/widgets/fullscreen_dialog.dart';
import 'src/authentication/presentation/interface/pages/wrapper.dart';
import 'src/onboarding/presentation/bloc/onboarding_mixin.dart';
import 'src/onboarding/presentation/interface/pages/onboarding.dart';

Future<void> backgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    log('Message handled in the background!');
  }
}

void main() async {
  /// Initialize widgets binding
  WidgetsFlutterBinding.ensureInitialized();

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
  // final remoteMessage = FirebaseMessaging.instance.getInitialMessage();
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
    final connectivityStream = ref.watch(connectivityStreamProvider.stream);
    final modalNotifier = ref.watch(modalVisibleProvider.notifier);
    final networkInfo = NetworkInfoImpl();
    useEffect(() {
      log('Setting up stream listener');
      final subscription = connectivityStream.listen((result) async {
        log('Connectivity changed to: $result');
        if (result != ConnectivityResult.none) {
          // Perform additional internet check
          try {
            bool hasInternet = await networkInfo.hasInternet();
            modalNotifier.state = !hasInternet;
          } catch (e) {
            modalNotifier.state = true;
          }
        } else {
          modalNotifier.state = true;
        }
      });
      return () {
        log('Cancelling stream subscription');
        subscription.cancel();
      };
    }, [connectivityStream]);
    final modalVisible = ref.watch(modalVisibleProvider);
    void retry() async {
      log('Retry button pressed');
      var connectivityResult = await Connectivity().checkConnectivity();
      log('Manual connectivity check result: $connectivityResult');
      if (connectivityResult != ConnectivityResult.none) {
        try {
          final networkInfo = NetworkInfoImpl();
          bool hasInternet = await networkInfo.hasInternet();
          modalNotifier.state = !hasInternet;
        } catch (e) {
          modalNotifier.state = true;
        }
      } else {
        modalNotifier.state = true;
      }
    }

    log('Building widget tree, modalVisible: $modalVisible');

    return MaterialApp(
      theme: lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            if (modalVisible) ...[
              Positioned.fill(
                child: Builder(builder: (context) {
                  return FullscreenDialog(
                    title: 'No Connection',
                    content:
                        'You are currently not connected to any internet source.',
                    dialogType: DialogType.warning,
                    canPop: false,
                    primaryButtonLabel: 'Retry',
                    primaryAction: () {
                      retry();
                    },
                  );
                }),
              ),
            ],
          ],
        );
      },
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
