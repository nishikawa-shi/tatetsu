import 'package:tatetsu/model/transport/account_detail_dto.dart';
import 'package:tatetsu/model/transport/payment_dto.dart';
import 'package:tatetsu/ui/input_accounting_detail/accounting_detail_state.dart';
import 'package:test/test.dart';

void main() {
  group('AccountingDetailState', () {
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
