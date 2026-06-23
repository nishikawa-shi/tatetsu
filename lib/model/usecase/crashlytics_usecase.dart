import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class CrashlyticsUsecase {
  static final CrashlyticsUsecase _singleton =
      CrashlyticsUsecase._internal();

  factory CrashlyticsUsecase.shared() => _singleton;

  CrashlyticsUsecase._internal();

  void initialize() {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
