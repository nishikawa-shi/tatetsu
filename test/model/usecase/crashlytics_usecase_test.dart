import 'package:flutter_test/flutter_test.dart';
import 'package:tatetsu/model/usecase/crashlytics_usecase.dart';

void main() {
  group('CrashlyticsUsecase', () {
    test('shared_複数回呼び出した時、同一インスタンスを返す', () {
      TestWidgetsFlutterBinding.ensureInitialized();
      expect(
        CrashlyticsUsecase.shared(),
        same(CrashlyticsUsecase.shared()),
      );
    });
  });
}
