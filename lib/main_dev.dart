import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tatetsu/config/dev.dart';
import 'package:tatetsu/firebase_options_dev.dart';
import 'package:tatetsu/model/usecase/advertisement_usecase.dart';
import 'package:tatetsu/model/usecase/crashlytics_usecase.dart';
import 'package:tatetsu/tatetsu.dart';

void main() async {
  setConfig();
  WidgetsFlutterBinding.ensureInitialized(); // この処理を行わないとAdMobの初期化がうまくいかない
  await Firebase.initializeApp(
    // モバイルはネイティブ設定ファイルから解決されるため、optionsはweb限定
    options: kIsWeb ? DefaultFirebaseOptions.currentPlatform : null,
  );
  CrashlyticsUsecase.shared().initialize();
  AdvertisementUsecase.shared().initialize();
  runApp(Tatetsu());
}
