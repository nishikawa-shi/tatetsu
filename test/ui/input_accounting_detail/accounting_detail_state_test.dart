import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/transport/account_detail_dto.dart';
import 'package:tatetsu/model/transport/payment_dto.dart';
import 'package:tatetsu/ui/input_accounting_detail/accounting_detail_state.dart';
import 'package:tatetsu/ui/input_accounting_detail/payment_component.dart';
import 'package:test/test.dart';

void main() {
  final Participant testParticipant1 = Participant("testName1");
  final Participant testParticipant2 = Participant("testName2");

  group('AccountingDetailState', () {
    test('toUri_全属性が空配列の時、クエリストリングparamに空配列のものが入る', () {
      expect(
        AccountingDetailState(
          participants: [],
          payments: [],
        ).toUri(path: "/app/accounting_detail_test").toString(),
        "https://tatetsu.ntetz.com/app/accounting_detail_test?params=%7B%22pNm%22%3A%5B%5D%2C%22ps%22%3A%5B%5D%7D",
      );
    });

    test('toUri_participants属性が1つの値を含む時、クエリストリングparamに1つの値が入る', () {
      expect(
        AccountingDetailState(
          participants: [testParticipant1],
          payments: [],
        ).toUri(path: "/app/accounting_detail_test").toString(),
        "https://tatetsu.ntetz.com/app/accounting_detail_test?params=%7B%22pNm%22%3A%5B%22testName1%22%5D%2C%22ps%22%3A%5B%5D%7D",
      );
    });

    test('toUri_participants属性が複数個の値を含む時、クエリストリングparamに複数個の値が入る', () {
      expect(
        AccountingDetailState(
          participants: [testParticipant1, testParticipant2],
          payments: [],
        ).toUri(path: "/app/accounting_detail_test").toString(),
        "https://tatetsu.ntetz.com/app/accounting_detail_test?params=%7B%22pNm%22%3A%5B%22testName1%22%2C%22testName2%22%5D%2C%22ps%22%3A%5B%5D%7D",
      );
    });

    test('toUri_payments属性が1つの値を含む時、クエリストリングparamsに1つの値が入る', () {
      expect(
        AccountingDetailState(
          participants: [testParticipant1, testParticipant2],
          payments: [
            PaymentComponent.of(
              title: "paymentTitle1",
              payer: testParticipant1,
              price: 6780,
              owners: {testParticipant1: true, testParticipant2: true},
            )
          ],
        ).toUri(path: "/app/accounting_detail").toString(),
        "https://tatetsu.ntetz.com/app/accounting_detail?params=%7B%22pNm%22%3A%5B%22testName1%22%2C%22testName2%22%5D%2C%22ps%22%3A%5B%7B%22ttl%22%3A%22paymentTitle1%22%2C%22pN%22%3A%22testName1%22%2C%22prc%22%3A6780.0%2C%22ons%22%3A%7B%22testName1%22%3Atrue%2C%22testName2%22%3Atrue%7D%7D%5D%7D",
      );
    });

    test('toUri_payments属性が複数の値を含む時、クエリストリングparamsに複数の値が入る', () {
      expect(
        AccountingDetailState(
          participants: [testParticipant1, testParticipant2],
          payments: [
            PaymentComponent.of(
              title: "paymentTitle1",
              payer: testParticipant1,
              price: 6780,
              owners: {testParticipant1: true, testParticipant2: true},
            ),
            PaymentComponent.of(
              title: "paymentTitle123",
              payer: testParticipant2,
              price: 9000,
              owners: {testParticipant1: false, testParticipant2: true},
            )
          ],
        ).toUri(path: "/app/accounting_detail").toString(),
        "https://tatetsu.ntetz.com/app/accounting_detail?params=%7B%22pNm%22%3A%5B%22testName1%22%2C%22testName2%22%5D%2C%22ps%22%3A%5B%7B%22ttl%22%3A%22paymentTitle1%22%2C%22pN%22%3A%22testName1%22%2C%22prc%22%3A6780.0%2C%22ons%22%3A%7B%22testName1%22%3Atrue%2C%22testName2%22%3Atrue%7D%7D%2C%7B%22ttl%22%3A%22paymentTitle123%22%2C%22pN%22%3A%22testName2%22%2C%22prc%22%3A9000.0%2C%22ons%22%3A%7B%22testName1%22%3Afalse%2C%22testName2%22%3Atrue%7D%7D%5D%7D",
      );
    });

    test('toUri_payments属性が1つの不正な値を含む時、エラーせずクエリストリングparamsに1つの値が入る', () {
      expect(
        AccountingDetailState(
          participants: [testParticipant1, testParticipant2],
          payments: [
            PaymentComponent.of(
              title: "paymentTitle1",
              payer: testParticipant1,
              price: 6780,
              owners: {
                testParticipant1: true,
                testParticipant2: true,
                Participant("間違って入ってしまったユーザー"): true
              },
            )
          ],
        ).toUri(path: "/app/accounting_detail").toString(),
        "https://tatetsu.ntetz.com/app/accounting_detail?params=%7B%22pNm%22%3A%5B%22testName1%22%2C%22testName2%22%5D%2C%22ps%22%3A%5B%7B%22ttl%22%3A%22paymentTitle1%22%2C%22pN%22%3A%22testName1%22%2C%22prc%22%3A6780.0%2C%22ons%22%3A%7B%22testName1%22%3Atrue%2C%22testName2%22%3Atrue%2C%22%E9%96%93%E9%81%95%E3%81%A3%E3%81%A6%E5%85%A5%E3%81%A3%E3%81%A6%E3%81%97%E3%81%BE%E3%81%A3%E3%81%9F%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC%22%3Atrue%7D%7D%5D%7D",
      );
    });

    test('toUri_引数pathにスラッシュ1つのパスを渡した時、そのままURLに反映される', () {
      expect(
        AccountingDetailState(
          participants: [testParticipant1, testParticipant2],
          payments: [
            PaymentComponent.of(
              title: "paymentTitle1",
              payer: testParticipant1,
              price: 6780,
              owners: {testParticipant1: true, testParticipant2: true},
            )
          ],
        ).toUri(path: "koredake").toString(),
        "https://tatetsu.ntetz.com/koredake?params=%7B%22pNm%22%3A%5B%22testName1%22%2C%22testName2%22%5D%2C%22ps%22%3A%5B%7B%22ttl%22%3A%22paymentTitle1%22%2C%22pN%22%3A%22testName1%22%2C%22prc%22%3A6780.0%2C%22ons%22%3A%7B%22testName1%22%3Atrue%2C%22testName2%22%3Atrue%7D%7D%5D%7D",
      );
    });

    test('toAccountingDetailState_title属性にttl属性の値がそのまま設定される', () {
      expect(
        AccountDetailDto(
          pNm: ["suzuki", "tanaka", "sato"],
          ps: [
            PaymentDto(
              ttl: "会計タイトル",
              pN: "sato",
              prc: 49800,
              ons: {"suzuki": true, "tanaka": true, "sato": true},
            )
          ],
        ).toAccountingDetailState().payments[0].title,
        "会計タイトル",
      );
    });

    test(
        'toAccountingDetailState_payer属性に、ps.pn属性がpNm属性内に一致するものが存在する時、pNm属性に対応したインスタンスが設定される',
        () {
      final testState = AccountDetailDto(
        pNm: ["suzuki", "tanaka", "sato"],
        ps: [
          PaymentDto(
            ttl: "会計タイトル",
            pN: "sato",
            prc: 49800,
            ons: {"suzuki": true, "tanaka": true, "sato": true},
          )
        ],
      ).toAccountingDetailState();
      expect(
        testState.payments[0].payer,
        testState.participants[2],
      );
    });

    test('toAccountingDetailState_payer属性に関して、ps.pn属性がpNm属性内に一致するものが存在しない時、エラーする',
        () {
      expect(
        () => AccountDetailDto(
          pNm: ["suzuki", "tanaka", "sato"],
          ps: [
            PaymentDto(
              ttl: "会計タイトル",
              pN: "nakamoto",
              prc: 49800,
              ons: {"suzuki": true, "tanaka": true, "sato": true},
            )
          ],
        ).toAccountingDetailState(),
        throwsStateError,
      );
    });

    test('toAccountingDetailState_price属性にprc属性の値がそのまま設定される', () {
      expect(
        AccountDetailDto(
          pNm: ["suzuki", "tanaka", "sato"],
          ps: [
            PaymentDto(
              ttl: "会計タイトル",
              pN: "sato",
              prc: 49800,
              ons: {"suzuki": true, "tanaka": true, "sato": true},
            )
          ],
        ).toAccountingDetailState().payments[0].price,
        49800,
      );
    });

    test(
        'toAccountingDetailState_owners属性に、ps.ons属性がpNm属性と一致する時、own属性の値がそのまま設定される',
        () {
      final testState = AccountDetailDto(
        pNm: ["suzuki", "tanaka", "sato"],
        ps: [
          PaymentDto(
            ttl: "会計タイトル",
            pN: "sato",
            prc: 49800,
            ons: {"suzuki": true, "tanaka": true, "sato": true},
          )
        ],
      ).toAccountingDetailState();

      expect(
        testState.payments[0].owners,
        {
          testState.participants[0]: true,
          testState.participants[1]: true,
          testState.participants[2]: true,
        },
      );
    });

    test(
        'toAccountingDetailState_owners属性に、ps.ons属性がpNm属性より小さい時、own属性の値がそのまま設定される(エラーはしない仕様)',
        () {
      final testState = AccountDetailDto(
        pNm: ["suzuki", "tanaka", "sato"],
        ps: [
          PaymentDto(
            ttl: "会計タイトル",
            pN: "sato",
            prc: 49800,
            ons: {"suzuki": true, "tanaka": true},
          )
        ],
      ).toAccountingDetailState();

      expect(
        testState.payments[0].owners,
        {
          testState.participants[0]: true,
          testState.participants[1]: true,
        },
      );
    });

    test('toAccountingDetailState_owners属性に関して、ps.ons属性がpNm属性より大きい時、エラーする', () {
      expect(
        () => AccountDetailDto(
          pNm: ["suzuki", "tanaka", "sato"],
          ps: [
            PaymentDto(
              ttl: "会計タイトル",
              pN: "sato",
              prc: 49800,
              ons: {
                "suzuki": true,
                "tanaka": true,
                "sato": true,
                "murashita": true
              },
            )
          ],
        ).toAccountingDetailState(),
        throwsStateError,
      );
    });
  });
}
