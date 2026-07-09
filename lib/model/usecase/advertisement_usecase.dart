import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tatetsu/config/application_meta.dart';

class AdvertisementUsecase {
  static final AdvertisementUsecase _singleton =
      AdvertisementUsecase._internal();

  factory AdvertisementUsecase.shared() => _singleton;

  BannerAd settleAccountsTopBanner;

  AdvertisementUsecase._internal()
      : settleAccountsTopBanner = BannerAd(
          size: AdSize.banner,
          adUnitId: getSettleAccountsTopBannerId(),
          listener: BannerAdListener(
            onAdFailedToLoad: (Ad ad, LoadAdError error) async {
              ad.dispose();
              await FirebaseCrashlytics.instance.recordError(
                error,
                StackTrace.current,
                reason: 'Ad failed to load: $error',
              );
            },
          ),
          request: const AdRequest(),
        );

  void initialize() {
    // google_mobile_adsはweb未対応のため、webでは初期化とバナー読込を行わない
    if (kIsWeb) return;

    MobileAds.instance.initialize();
    _loadAllAdBanner();
  }

  void _loadAllAdBanner() {
    settleAccountsTopBanner.load();
  }

  bool isSettleAccountsTopBannerSuccessfullyLoaded() =>
      settleAccountsTopBanner.responseInfo != null;
}
