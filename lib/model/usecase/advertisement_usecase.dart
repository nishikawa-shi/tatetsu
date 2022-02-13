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
          listener: const BannerAdListener(),
          request: const AdRequest(),
        );

  void initialize() {
    MobileAds.instance.initialize();
    _loadAllAdBanner();
  }

  void _loadAllAdBanner() {
    settleAccountsTopBanner.load();
  }
}
