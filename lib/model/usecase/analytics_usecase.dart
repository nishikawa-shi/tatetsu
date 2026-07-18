import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsUsecase {
  static final AnalyticsUsecase _singleton = AnalyticsUsecase._internal();

  factory AnalyticsUsecase.shared() => _singleton;

  AnalyticsUsecase._internal();

  void initialize() {
    // モバイルはネイティブSDKが自動計測するが、webはFirebaseAnalyticsへの接触を
    // 契機にgtagが読み込まれるまで計測が始まらないため、全プラットフォームで明示的に有効化する
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  }
}
