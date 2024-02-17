import 'dart:convert';
import 'dart:io';

import 'package:bounz_revamp_app/app/bounz_app.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/constants/environment.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final appRouter = AppRouter();

Future<void> mainBounz(BounzEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides(environment: environment);
  await Firebase.initializeApp();
  await StorageManager.initializeSharedPreferences();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  GlobalSingleton.appVersion =
      environment.setupEnvironmentVariables().appVersion;
  GlobalSingleton.postbackURL =
      environment.setupEnvironmentVariables().postBackURL;
  GlobalSingleton.isProd = environment.setupEnvironmentVariables().isProd;
  ApiPath.setupAppBaseUrls(environment.setupEnvironmentVariables());
  MoenageManager.initialiseMoenage(environment.setupEnvironmentVariables());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  SystemChannels.textInput.invokeMethod('TextInput.hide');
  final String? encodeString =
      StorageManager.getStringValue(AppStorageKey.userInformation);
  if (encodeString != null) {
    GlobalSingleton.userInformation =
        UserInformation.fromJson(jsonDecode(encodeString));
  }
  await NetworkDio.setDynamicHeader(
    authorizationToken:
        environment.setupEnvironmentVariables().authorizationToken,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const BounzApp());
}

class MyHttpOverrides extends HttpOverrides {
  final BounzEnvironment environment;
  MyHttpOverrides({required this.environment});
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..getUrl(Uri.parse(environment.setupEnvironmentVariables().baseUrl))
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
