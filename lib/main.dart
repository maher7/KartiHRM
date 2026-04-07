import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:onesthrm/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notification/notification.dart';
import 'package:onesthrm/injection/app_injection.dart';
import 'package:onesthrm/page/app/app.dart';
import 'package:onesthrm/page/app/app_bloc_observer.dart';
import 'package:onesthrm/page/home/router/home__menu_router.dart';
import 'package:onesthrm/page/notice_details/view/notice_details_screen.dart';
import 'package:onesthrm/res/nav_utail.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///initializeEasyLocalization
  await EasyLocalization.ensureInitialized();

  ///initializeFirebaseAtStatingPoint
  // Native side initializes Firebase in MainApplication.onCreate().
  // Dart side syncs with a retry to allow Pigeon channels to settle.
  bool firebaseReady = false;
  for (int i = 0; i < 5; i++) {
    try {
      if (Firebase.apps.isNotEmpty) {
        firebaseReady = true;
        // Firebase ready
        break;
      }
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      firebaseReady = true;
      // Firebase initialized
      break;
    } catch (e) {
      await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
    }
  }
  // Wire Flutter's error handlers to Crashlytics so uncaught exceptions on
  // either the framework or platform side are reported. Only active when the
  // Firebase bootstrap above succeeded — otherwise the errors just fall back
  // to the default Flutter error widget.
  if (firebaseReady) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  ///initializeDependencyInjection
  await initAppModule();

  ///OtherDependencyInjection
  await AppInjection().initInjection();
  final appView = instance<AppFactory>();
  await instance<NotificationAppStartedHandlerService>().onAppStarted();

  // Register notification tap callback for deep linking
  NotificationAppStartedHandlerService.onTapCallback = (payload, type) {
    final navKey = instance<GlobalKey<NavigatorState>>();
    final context = navKey.currentState?.context;
    if (context == null) return;
    _handleNotificationTap(context, payload, type);
  };

  // Handle notification tap that opened the app from killed/background state
  try {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      final type = initialMessage.data['type']?.toString();
      // Delay to let the app fully render before navigating
      Future.delayed(const Duration(seconds: 4), () {
        final navKey = instance<GlobalKey<NavigatorState>>();
        final context = navKey.currentState?.context;
        if (context != null && type != null) {
          _handleNotificationTap(context, null, type);
        }
      });
    }
    // Handle notification tap when app is in background (not killed)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final type = message.data['type']?.toString();
      final navKey = instance<GlobalKey<NavigatorState>>();
      final context = navKey.currentState?.context;
      if (context != null && type != null) {
        _handleNotificationTap(context, null, type);
      }
    });
  } catch (e) {
  }

  HydratedBloc.storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());
  Bloc.observer = AppBlocObserver();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en', 'US'),
      Locale('ar', 'AR'),
      Locale('he', 'IL'),
    ],
    path: 'assets/translations',
    saveLocale: true,
    fallbackLocale: const Locale('en', 'US'),
    child: appView(),
  ));
}

Future<void> updateAppWidget({required bool isCheckedIn}) async {
  await HomeWidget.saveWidgetData<bool>('isCheckedIn', isCheckedIn);
  await HomeWidget.updateWidget(
      name: 'HomeScreenCheckInOutWidgetProvider',
      iOSName: 'HomeScreenCheckInOutWidgetProvider',
      qualifiedAndroidName: 'com.example.onesthrm.HomeScreenCheckInOutWidgetProvider');
}

/// Handle notification tap — route to the appropriate screen based on type/slug.
void _handleNotificationTap(BuildContext context, String? payload, String? type) {
  // debugPrint('Deep link: type=$type, payload=$payload');

  // If we have a known slug/type, route using the existing slug router
  if (type != null && type.isNotEmpty) {
    routeSlug(type, context);
    return;
  }

  // Otherwise, try to parse the payload and show the notification details
  if (payload != null && payload.isNotEmpty) {
    try {
      final data = json.decode(payload);
      if (data is Map) {
        // Check if there's a type in the payload data
        final slug = data['type']?.toString() ?? data['slag']?.toString() ?? '';
        if (slug.isNotEmpty) {
          routeSlug(slug, context);
          return;
        }
        // Fall back to showing notification details
        NavUtil.navigateScreen(
          context,
          NoticeDetailsScreen(
            title: data['title']?.toString(),
            body: data['body']?.toString() ?? data['message']?.toString(),
          ),
        );
        return;
      }
    } catch (_) {}
  }

  // Default: open the notifications tab
  NavUtil.navigateScreen(context, chooseNotification());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
