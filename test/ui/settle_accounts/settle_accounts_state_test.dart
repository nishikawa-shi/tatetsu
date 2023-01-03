import 'package:tatetsu/model/transport/account_detail_dto.dart';
import 'package:tatetsu/model/transport/payment_dto.dart';
import 'package:tatetsu/ui/settle_accounts/settle_accounts_state.dart';
import 'package:test/test.dart';

void main() {
  group('SettleAccountState', () {
    test('toSettleAccountState_title属性にttl属性の値がそのまま設定される', () {
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
        ).toSettleAccountsState().payments[0].title,
        "会計タイトル",
      );
    });

    test(
        'toSettleAccountState_payer属性に、ps.pn属性がpNm属性内に一致するものが存在する時、pNm属性に対応したインスタンスが設定される',
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
      ).toSettleAccountsState();
      expect(
        testState.payments[0].payer,
        testState.payments[0].owners.keys.toList()[2],
      );
    });

    test('toSettleAccountState_payer属性に関して、ps.pn属性がpNm属性内に一致するものが存在しない時、エラーする',
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
        ).toSettleAccountsState(),
        throwsStateError,
      );
    });

    test('toSettleAccountState_price属性にprc属性の値がそのまま設定される', () {
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
        ).toSettleAccountsState().payments[0].price,
        49800,
      );
    });

    test(
        'toSettleAccountState_owners属性に、ps.ons属性がpNm属性と一致する時、own属性の値がそのまま設定される',
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
      ).toSettleAccountsState();

      expect(
        testState.payments[0].owners,
        {
          testState.payments[0].owners.keys.toList()[0]: true,
          testState.payments[0].owners.keys.toList()[1]: true,
          testState.payments[0].owners.keys.toList()[2]: true,
        },
      );
    });

    test(
        'toSettleAccountState_owners属性に、ps.ons属性がpNm属性より小さい時、own属性の値がそのまま設定される(エラーはしない仕様)',
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
      ).toSettleAccountsState();

      expect(
        testState.payments[0].owners,
        {
          testState.payments[0].owners.keys.toList()[0]: true,
          testState.payments[0].owners.keys.toList()[1]: true,
        },
      );
    });

    test('toSettleAccountState_owners属性に関して、ps.ons属性がpNm属性より大きい時、エラーする', () {
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
        ).toSettleAccountsState(),
        throwsStateError,
      );
    });
  });
}
