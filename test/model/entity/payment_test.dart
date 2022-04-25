import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';
import 'package:test/test.dart';

void main() {
  group('Payment', () {
    test('Payment_title属性に、プロパティを外部から操作しなかった時引数で渡した値が設定される', () {
      expect(
        Payment(
          title: "tesutoTitle",
          payer: Participant("tesutoPart"),
          price: 12.34,
          owners: {},
        ).title,
        equals("tesutoTitle"),
      );
    });

    test('Payment_title属性に、プロパティを外部から操作した時書き換え後の値が設定される', () {
      expect(
        (Payment(
          title: "tesutoTitle",
          payer: Participant("tesutoPart"),
          price: 12.34,
          owners: {},
        )..title = "modified payment")
            .title,
        equals("modified payment"),
      );
    });

    test('Payment_price属性に、0.01未満の値を含む小数値を与えた時小数点第2位で切り捨てされる', () {
      expect(
        Payment(
          title: "tesutoTitle",
          payer: Participant("tesutoPart"),
          price: 12.341,
          owners: {},
        ).price,
        equals(12.34),
      );
    });
  });
}
