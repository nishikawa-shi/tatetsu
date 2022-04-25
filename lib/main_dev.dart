import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tatetsu/config/dev.dart';
import 'package:tatetsu/model/usecase/advertisement_usecase.dart';
import 'package:tatetsu/tatetsu.dart';

void main() {
  setConfig();
  WidgetsFlutterBinding.ensureInitialized(); // この処理を行わないとAdMobの初期化がうまくいかない
  AdvertisementUsecase.shared().initialize();
  Firebase.initializeApp();
  runApp(Tatetsu());
}
