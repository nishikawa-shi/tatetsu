import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tatetsu/config/prd.dart';
import 'package:tatetsu/model/usecase/advertisement_usecase.dart';
import 'package:tatetsu/model/usecase/crashlytics_usecase.dart';
import 'package:tatetsu/tatetsu.dart';

void main() async {
  setConfig();
  WidgetsFlutterBinding.ensureInitialized(); // この処理を行わないとAdMobの初期化がうまくいかない
  await Firebase.initializeApp();
  CrashlyticsUsecase.shared().initialize();
  AdvertisementUsecase.shared().initialize();
  runApp(Tatetsu());
}
