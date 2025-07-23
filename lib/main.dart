import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:venure/app/app.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51RnkHPR4Wkf5f0qTR5r7cbM1BvXvubPTDsHOWGq849Ty3BlyGJF4kYEiVmpSv0H6OTJLkOIcXcFy6U63VEe1B66g00bS5x1oB6';

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await HiveService.instance.init();

  await initDependencies();

  runApp(const App());
}
