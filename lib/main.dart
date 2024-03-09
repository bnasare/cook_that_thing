// ignore_for_file: deprecated_member_use

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipe_hub/firebase_options.dart';
import 'package:recipe_hub/shared/presentation/theme/theme.dart';
import 'package:recipe_hub/src/home/presentation/interface/pages/nav_bar.dart';

import 'injection_container.dart' as di;

Future<void> backgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    debugPrint('Message handled in the background!');
  }
}

void main() async {
  /// Initialize widgets binding
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Splash Screen

  /// Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Initialize Dependency Injection
  await di.init();

  // Initialize Push Notification
  // await sl<PushNotification>().initializeNotification();
//
  // Register background handler
  // FirebaseMessaging.onBackgroundMessage(backgroundMessage);
//
  // Get any messages which caused the application to open from terminated state
  // final remoteMessage = FirebaseMessaging.instance.getInitialMessage();
//
  // Get any messages which caused the application to open from background state
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {});

  /// Record any errors that occur in the app
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final connectivityStream = ref.watch(connectivityStreamProvider.stream);
    // final modalNotifier = ref.watch(modalVisibleProvider.notifier);
    // final networkInfo =
    // NetworkInfoImpl(); // Create an instance of NetworkInfoImpl

    // useEffect(() {
    // log('Setting up stream listener');
    // final subscription = connectivityStream.listen((result) async {
    // log('Connectivity changed to: $result');
    // if (result != ConnectivityResult.none) {
    // Perform additional internet check
    // try {
    // bool hasInternet = await networkInfo.hasInternet();
    // modalNotifier.state =
    // !hasInternet; // Show dialog if there is no internet
    // } catch (e) {
    // modalNotifier.state =
    // true; // Show dialog if an exception occurs (e.g., no internet)
    // }
    // } else {
    // modalNotifier.state = true; // Show dialog if there is no connectivity
    // }
    // });

    // return () {
    // log('Cancelling stream subscription');
    // subscription.cancel();
    // };
    // }, [connectivityStream]);

    // final modalVisible = ref.watch(modalVisibleProvider);

    // void retry() async {
    // log('Retry button pressed');
    // var connectivityResult = await Connectivity().checkConnectivity();
    // log('Manual connectivity check result: $connectivityResult');

    // if (connectivityResult != ConnectivityResult.none) {
    // Perform additional internet check using NetworkInfoImpl
    // try {
    // final networkInfo =
    // NetworkInfoImpl(); // Create an instance of NetworkInfoImpl
    // bool hasInternet = await networkInfo.hasInternet();
    // modalNotifier.state =
    // !hasInternet; // Show dialog if there is no internet
    // } catch (e) {
    // modalNotifier.state =
    // true; // Show dialog if an exception occurs (e.g., no internet)
    // }
    // } else {
    // modalNotifier.state = true; // Show dialog if there is no connectivity
    // }
    // }

    // log('Building widget tree, modalVisible: $modalVisible');
    return MaterialApp(
      theme: lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const NavBar(),
      // home: FutureBuilder<bool>(
      // future: checkIfOnboardingIsComplete(),
      // builder: (context, snapshot) {
      // if (snapshot.connectionState == ConnectionState.waiting) {
      // Show loading indicator while waiting for future to complete
      // return const Scaffold(
      // body: Center(
      // child: SizedBox.shrink(),
      // ),
      // );
      // } else if (snapshot.hasError) {
      // Handle error state
      // return Scaffold(
      // body: Center(
      // child: Text('Error: ${snapshot.error}'),
      // ),
      // );
      // } else if (snapshot.data == true) {
      // Onboarding is complete, show login page
      // return const LoginPage();
      // } else {
      // Onboarding is not complete, show onboarding screen
      // return Onboarding();
      // }
      // },
      // ),
      // builder: (context, child) {
      // return Stack(
      // children: [
      // if (child != null) child,
      // if (modalVisible) ...[
      // Positioned.fill(
      // child: Builder(builder: (context) {
      // return FullscreenDialog(
      // title: 'No Connection',
      // content:
      // 'You are currently not connected to any internet source.',
      // dialogType: DialogType.warning,
      // canPop: false,
      // primaryButtonLabel: 'Retry',
      // primaryAction: () {
      // retry();
      // },
      // );
      // }),
      // ),
      // ],
      // ],
      // );
      // },
    );
  }
}
