import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tatetsu/config/application_meta.dart';

class AdvertisementUsecase {
  BannerAd getSettleAccountsTopBanner() => BannerAd(
        size: AdSize.banner,
        adUnitId: getSettleAccountsTopBannerId(),
        listener: const BannerAdListener(),
        request: const AdRequest(),
      )..load();
}
