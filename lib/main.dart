import 'package:flutter/material.dart';
import 'package:venure/app/app.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await serviceLocator<HiveService>().init(); 
  runApp(const App());
}
