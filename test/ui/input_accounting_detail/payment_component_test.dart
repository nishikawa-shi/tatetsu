import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/ui/input_accounting_detail/payment_component.dart';
import 'package:test/test.dart';

void main() {
  final Participant testParticipant1 = Participant("testName1");
  final Participant testParticipant2 = Participant("testName2");

  group('PaymentComponent', () {
    test('PaymentComponent_title属性に、クラス内で指定したデフォルト値が設定される', () {
      expect(
        PaymentComponent(participants: [Participant("testName")]).title,
        equals("Some Payment"),
      );
    });

    test('PaymentComponent_payer属性に、引数で渡した値の1番目が設定される', () {
      expect(
        PaymentComponent(participants: [testParticipant1, testParticipant2])
            .payer,
        equals(testParticipant1),
      );
    });

    test('PaymentComponent_引数に空配列を渡すとエラー', () {
      expect(() => PaymentComponent(participants: []), throwsStateError);
    });

    test('PaymentComponent_owners属性に、引数で渡した値に対してtrueのハッシュマップが設定される', () {
      expect(
        PaymentComponent(participants: [testParticipant1, testParticipant2])
            .owners,
        equals({testParticipant1: true, testParticipant2: true}),
      );
    });

    test('toPayment_プロパティを外部から操作しなかった時、クラス内で指定したデフォルト値を含むPaymentオブジェクトを返す', () {
      expect(
        PaymentComponent(participants: [testParticipant1, testParticipant2])
            .toPayment()
            .title,
        equals("Some Payment"),
      );
    });

    test('toPayment_プロパティを外部から操作した時、書き換え後の値を含むPaymentオブジェクトを返す', () {
      expect(
        (PaymentComponent(participants: [testParticipant1, testParticipant2])
              ..title = "Modified Test Payment")
            .toPayment()
            .title,
        equals("Modified Test Payment"),
      );
    });
  });
}
