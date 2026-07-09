import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsUsecase {
  static final CrashlyticsUsecase _singleton =
      CrashlyticsUsecase._internal();

  factory CrashlyticsUsecase.shared() => _singleton;

  CrashlyticsUsecase._internal();

  void initialize() {
    // firebase_crashlyticsはweb未対応のため、webではエラーハンドラを登録しない
    if (kIsWeb) return;

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
