import 'dart:io';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notification/notification.dart';
import 'package:onesthrm/injection/app_injection.dart';
import 'package:onesthrm/page/app/app.dart';
import 'package:onesthrm/page/app/app_bloc_observer.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///initializeEasyLocalization
  await EasyLocalization.ensureInitialized();

  ///initializeFirebaseAtStatingPoint
  if (Firebase.apps.isEmpty) {
    try {
      await Firebase.initializeApp();
    } catch (_) {
      // Firebase channel may not be ready on first cold start; non-fatal
    }
  }
  ///initializeDependencyInjection
  await initAppModule();

  ///OtherDependencyInjection
  await AppInjection().initInjection();
  final appView = instance<AppFactory>();
  await instance<NotificationAppStartedHandlerService>().onAppStarted();

  HydratedBloc.storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());
  Bloc.observer = AppBlocObserver();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en', 'US'),
      Locale('bn', 'BN'),
      Locale('ar', 'AR'),
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
