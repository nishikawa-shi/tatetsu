import 'package:flutter_test/flutter_test.dart';
import 'package:tatetsu/config/dev.dart' as dev;
import 'package:tatetsu/model/usecase/advertisement_usecase.dart';

void main() {
  group('AdvertisementUsecase', () {
    test(
        'getSettleAccountsTopBanner_devのsetConfigとWidgetsFlutterBindingの初期化実施後に実行した時、IDがテスト用の広告を返す',
        () {
      dev.setConfig();
      TestWidgetsFlutterBinding.ensureInitialized();
      expect(
        AdvertisementUsecase().getSettleAccountsTopBanner().adUnitId,
        equals("ca-app-pub-3940256099942544/2934735716"),
      );
    });
  });
}
