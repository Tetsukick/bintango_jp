import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:bintango_jp/config/color_config.dart';
import 'package:bintango_jp/screen/home_navigation.dart';
import 'package:bintango_jp/screen/lesson_selector/lesson_selector_screen.dart';
import 'package:bintango_jp/utils/analytics/firebase_analytics.dart';
import 'package:bintango_jp/utils/crash_reporter.dart';
import 'package:bintango_jp/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FirebaseAnalyticsUtils();
  MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runZonedGuarded(() async {
    await CrashReporter.instance.initialize();

    FlutterError.onError = (FlutterErrorDetails details) {
      CrashReporter.instance.report(details.exceptionAsString(), details.stack);
    };

    runApp(
      const ProviderScope(
        child: FlushCardApp(),
      ),
    );
  }, (error, stack) {
    CrashReporter.instance.report(error, stack);
  });
}

class FlushCardApp extends StatelessWidget {
  const FlushCardApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Utils.createMaterialColor(ColorConfig.primaryRed700),
      ),
      home: const HomeNavigation(),
    );
  }
}
