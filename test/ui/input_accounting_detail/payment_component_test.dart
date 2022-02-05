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
        equals("Lunch at the nice cafe"),
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
        equals("Lunch at the nice cafe"),
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

    test(
        'PaymentComponentsExt_hasOnlyDefaultElements_要素数が1つでプロパティがデフォルトと同じ時true',
        () {
      expect(
        [
          PaymentComponent(participants: [testParticipant1, testParticipant2])
            ..title = "Lunch at the nice cafe"
            ..payer = testParticipant1
            ..price = 0.0
            ..owners = {testParticipant1: true, testParticipant2: true}
        ].hasOnlyDefaultElements(
          onParticipants: [testParticipant1, testParticipant2],
        ),
        true,
      );
    });

    test('PaymentComponentsExt_hasOnlyDefaultElements_要素数が1つで支払名が異なる時false',
        () {
      expect(
        [
          PaymentComponent(participants: [testParticipant1, testParticipant2])
            ..title = "modified title"
        ].hasOnlyDefaultElements(
          onParticipants: [testParticipant1, testParticipant2],
        ),
        false,
      );
    });

    test('PaymentComponentsExt_hasOnlyDefaultElements_要素数が1つで支払者が異なる時false',
        () {
      expect(
        [
          PaymentComponent(participants: [testParticipant1, testParticipant2])
            ..payer = testParticipant2
        ].hasOnlyDefaultElements(
          onParticipants: [testParticipant1, testParticipant2],
        ),
        false,
      );
    });

    test('PaymentComponentsExt_hasOnlyDefaultElements_要素数が1つで価格が異なる時false', () {
      expect(
        [
          PaymentComponent(participants: [testParticipant1, testParticipant2])
            ..price = 0.01
        ].hasOnlyDefaultElements(
          onParticipants: [testParticipant1, testParticipant2],
        ),
        false,
      );
    });

    test('PaymentComponentsExt_hasOnlyDefaultElements_要素数が1つで精算対象者が異なる時false',
        () {
      expect(
        [
          PaymentComponent(participants: [testParticipant1, testParticipant2])
            ..owners = {testParticipant1: true, testParticipant2: false}
        ].hasOnlyDefaultElements(
          onParticipants: [testParticipant1, testParticipant2],
        ),
        false,
      );
    });

    test('PaymentComponentsExt_hasOnlyDefaultElements_要素数が1つだが参加者が異なる時false',
        () {
      expect(
        [
          PaymentComponent(participants: [testParticipant1, testParticipant2])
        ].hasOnlyDefaultElements(onParticipants: [testParticipant1]),
        false,
      );
    });

    test('PaymentComponentsExt_hasOnlyDefaultElements_要素数が2以上の時false', () {
      expect(
        [
          PaymentComponent(participants: [testParticipant1, testParticipant2]),
          PaymentComponent(participants: [testParticipant1, testParticipant2])
        ].hasOnlyDefaultElements(
          onParticipants: [testParticipant1, testParticipant2],
        ),
        false,
      );
    });
  });
}
