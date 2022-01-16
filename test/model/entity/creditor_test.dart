import 'package:flutter/foundation.dart';
import 'package:tatetsu/model/entity/creditor.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';
import 'package:tatetsu/model/entity/settlement.dart';
import 'package:test/test.dart';

void main() {
  final Participant testParticipant1 = Participant("testName1");
  final Participant testParticipant2 = Participant("testName2");
  final Participant testParticipant3 = Participant("testName3");

  final Map<Participant, double> oneZeroEntry = {
    testParticipant1: 0,
  };
  final Map<Participant, double> twoZeroEntries = {
    testParticipant1: 0,
    testParticipant2: 0,
  };
  final Map<Participant, double> oneMinusOnePlusEntries = {
    testParticipant1: 10,
    testParticipant2: -10,
  };
  final Map<Participant, double> twoMinusOnePlusEntries = {
    testParticipant1: 20,
    testParticipant2: -10,
    testParticipant3: -10
  };
  final Map<Participant, double> oneMinusTwoPlusEntries = {
    testParticipant1: 10,
    testParticipant2: 10,
    testParticipant3: -20
  };
  final Map<Participant, double> oneMinusOnePlusOneZeroEntries = {
    testParticipant1: 10,
    testParticipant2: -10,
    testParticipant3: 0
  };
  final Map<Participant, double> threeZeroEntries = {
    testParticipant1: 0,
    testParticipant2: 0,
    testParticipant3: 0
  };

  final List<Payment> dummyPayments = [
    Payment(
      title: "dummyPaymentA",
      payer: testParticipant1,
      price: 6000,
      owners: {
        testParticipant1: true,
      },
    )
  ];

  group('Creditor', () {
    test('extractSettlement_立替額の登録がない精算元を指定した時、nullで、プロパティに影響を与えない', () {
      final testCreditor = Creditor(payments: dummyPayments)
        ..entries = {...twoMinusOnePlusEntries};

      expect(
        testCreditor.extractSettlement(
          from: Participant("undefined"),
          to: testParticipant3,
        ),
        null,
      );
      expect(mapEquals(testCreditor.entries, twoMinusOnePlusEntries), true);
    });

    test('extractSettlement_立替額の登録がない精算先を指定した時、nullで、プロパティに影響を与えない', () {
      final testCreditor = Creditor(payments: dummyPayments)
        ..entries = {...twoMinusOnePlusEntries};

      expect(
        testCreditor.extractSettlement(
          from: testParticipant1,
          to: Participant("undefined"),
        ),
        null,
      );
      expect(mapEquals(testCreditor.entries, twoMinusOnePlusEntries), true);
    });

    test('extractSettlement_立替額が0の精算元を指定した時、nullで、プロパティに影響を与えない', () {
      final testCreditor = Creditor(payments: dummyPayments)
        ..entries = {...oneMinusOnePlusOneZeroEntries};

      expect(
        testCreditor.extractSettlement(
          from: testParticipant3,
          to: testParticipant1,
        ),
        null,
      );
      expect(
        mapEquals(testCreditor.entries, oneMinusOnePlusOneZeroEntries),
        true,
      );
    });

    test('extractSettlement_立替額がプラスの精算元を指定した時、nullで、プロパティに影響を与えない', () {
      final testCreditor = Creditor(payments: dummyPayments)
        ..entries = {...oneMinusTwoPlusEntries};

      expect(
        testCreditor.extractSettlement(
          from: testParticipant1,
          to: testParticipant2,
        ),
        null,
      );
      expect(mapEquals(testCreditor.entries, oneMinusTwoPlusEntries), true);
    });

    test('extractSettlement_立替額が0の精算先を指定した時、nullで、プロパティに影響を与えない', () {
      final testCreditor = Creditor(payments: dummyPayments)
        ..entries = {...oneMinusOnePlusOneZeroEntries};

      expect(
        testCreditor.extractSettlement(
          from: testParticipant2,
          to: testParticipant3,
        ),
        null,
      );
      expect(
        mapEquals(testCreditor.entries, oneMinusOnePlusOneZeroEntries),
        true,
      );
    });

    test('extractSettlement_立替額がマイナスの精算先を指定した時、nullで、プロパティに影響を与えない', () {
      final testCreditor = Creditor(payments: dummyPayments)
        ..entries = {...twoMinusOnePlusEntries};

      expect(
        testCreditor.extractSettlement(
          from: testParticipant2,
          to: testParticipant3,
        ),
        null,
      );
      expect(mapEquals(testCreditor.entries, twoMinusOnePlusEntries), true);
    });

    test('extractSettlement_立替費絶対値が精算先の方が大きい時、精算元基準の精算となり、プロパティに当該の精算結果が適用される',
        () {
      final testEntries = {
        testParticipant1: 300.0,
        testParticipant2: -180.0,
        testParticipant3: -120.0,
      };
      final testCreditor = Creditor(payments: dummyPayments)
        ..entries = testEntries;

      expect(
        testCreditor
            .extractSettlement(from: testParticipant2, to: testParticipant1)!
            .isEqualTo(
              Settlement(
                from: testParticipant2,
                to: testParticipant1,
                amount: 180,
              ),
            ),
        true,
      );
      expect(
        mapEquals(testCreditor.entries, {
          testParticipant1: 120.0,
          testParticipant2: 0,
          testParticipant3: -120.0
        }),
        true,
      );
    });

    test(
        'extractSettlement_立替費絶対値が精算元と精算先で同額の時、精算先基準の精算となり、プロパティに当該の精算結果が適用される',
        () {
      final testEntries = {
        testParticipant1: -500.0,
        testParticipant2: 500.0,
        testParticipant3: 0.0,
      };
      final testCreditor = Creditor(payments: dummyPayments)
        ..entries = testEntries;

      expect(
        testCreditor
            .extractSettlement(from: testParticipant1, to: testParticipant2)!
            .isEqualTo(
              Settlement(
                from: testParticipant1,
                to: testParticipant2,
                amount: 500,
              ),
            ),
        true,
      );
      expect(
        mapEquals(
          testCreditor.entries,
          {testParticipant1: 0, testParticipant2: 0, testParticipant3: 0},
        ),
        true,
      );
    });

    test('extractSettlement_立替費絶対値が精算元の方が大きい時、精算先基準の精算となり、プロパティに当該の精算結果が適用される',
        () {
      final testEntries = {
        testParticipant1: -500.0,
        testParticipant2: 270.0,
        testParticipant3: 230.0,
      };
      final testCreditor = Creditor(payments: dummyPayments)
        ..entries = testEntries;

      expect(
        testCreditor
            .extractSettlement(from: testParticipant1, to: testParticipant2)!
            .isEqualTo(
              Settlement(
                from: testParticipant1,
                to: testParticipant2,
                amount: 270,
              ),
            ),
        true,
      );
      expect(
        mapEquals(testCreditor.entries, {
          testParticipant1: -230.0,
          testParticipant2: 0,
          testParticipant3: 230.0
        }),
        true,
      );
    });

    test('extractSettlement_精算対象が0.01未満の時、nullで、プロパティに影響を与えない', () {
      final testEntries = {
        testParticipant1: -21.00999999999999999,
        testParticipant2: 0.00999999999999999,
        testParticipant3: 21.0,
      };
      final testCreditor = Creditor(payments: dummyPayments)
        ..entries = testEntries;

      expect(
        testCreditor.extractSettlement(
          from: testParticipant1,
          to: testParticipant2,
        ),
        null,
      );
      expect(mapEquals(testCreditor.entries, testEntries), true);
    });

    test(
        'extractSettlement_精算対象が0.01未満の値が含まれる浮動小数点の時、誤差の含まれる精算となり、プロパティに当該の精算結果が適用される',
        () {
      final testEntries = {
        testParticipant1: -28.00999999999997,
        testParticipant2: 28.00999999999998,
        testParticipant3: -0.00000000000001,
      };
      final testCreditor = Creditor(payments: dummyPayments)
        ..entries = testEntries;

      expect(
        testCreditor
            .extractSettlement(from: testParticipant1, to: testParticipant2)!
            .isEqualTo(
              Settlement(
                from: testParticipant1,
                to: testParticipant2,
                amount: 28,
              ),
            ),
        equals(true),
      );
      expect(
        mapEquals(testCreditor.entries, {
          testParticipant1: -0.009999999999969589,
          testParticipant2: 0.009999999999980247,
          testParticipant3: -1e-14,
        }),
        true,
      );
    });

    test(
        'extractSettlement_精算対象が0.01以上と判断される値が含まれる浮動小数点の時、切り上げた値による精算結果がプロパティに適用される',
        () {
      final testEntries = {
        testParticipant1: -28.009999999999997,
        testParticipant2: 28.009999999999998,
        testParticipant3: -0.000000000000001,
      };
      final testCreditor = Creditor(payments: dummyPayments)
        ..entries = testEntries;

      expect(
        testCreditor
            .extractSettlement(from: testParticipant1, to: testParticipant2)!
            .isEqualTo(
              Settlement(
                from: testParticipant1,
                to: testParticipant2,
                amount: 28.01,
              ),
            ),
        equals(true),
      );
      expect(
        mapEquals(testCreditor.entries, {
          testParticipant1: 3.552713678800501e-15,
          testParticipant2: -3.552713678800501e-15,
          testParticipant3: -1e-15,
        }),
        equals(true),
      );
    });

    test('getCreditors_立替額0が1人の時、空配列', () {
      expect(
        (Creditor(payments: dummyPayments)..entries = {...oneZeroEntry})
            .getCreditors(),
        [],
      );
    });

    test('getCreditors_立替額マイナスが1人でプラスが1人の時、プラスの1人', () {
      expect(
        (Creditor(payments: dummyPayments)
              ..entries = {...oneMinusOnePlusEntries})
            .getCreditors(),
        [testParticipant1],
      );
    });

    test('getCreditors_立替額0が2人の時、空配列', () {
      expect(
        (Creditor(payments: dummyPayments)..entries = {...twoZeroEntries})
            .getCreditors(),
        [],
      );
    });

    test('getCreditors_立替額マイナスが2人でプラスが1人の時、プラスの1人', () {
      expect(
        (Creditor(payments: dummyPayments)
              ..entries = {...twoMinusOnePlusEntries})
            .getCreditors(),
        [testParticipant1],
      );
    });

    test('getCreditors_立替額マイナスが1人でプラスが2人の時、プラスの2人', () {
      expect(
        (Creditor(payments: dummyPayments)
              ..entries = {...oneMinusTwoPlusEntries})
            .getCreditors(),
        [testParticipant1, testParticipant2],
      );
    });

    test('getCreditors_立替額マイナスが1人でプラスが1人で0が1人の時、プラスの1人', () {
      expect(
        (Creditor(payments: dummyPayments)
              ..entries = {...oneMinusOnePlusOneZeroEntries})
            .getCreditors(),
        [testParticipant1],
      );
    });

    test('getCreditors_立替額0が3人の時、空配列', () {
      expect(
        (Creditor(payments: dummyPayments)..entries = {...threeZeroEntries})
            .getCreditors(),
        [],
      );
    });

    test('getCreditors_実行前後で、インスタンスの持つ立替者プロパティが不変', () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        )
      ];
      final Creditor testCreditor = Creditor(payments: testPayments);

      expect((testCreditor..getCreditors()).entries, {
        testParticipant1: 4000,
        testParticipant2: -2000,
        testParticipant3: -2000
      });
    });

    test('getDebtors_立替額0が1人の時、空配列', () {
      expect(
        (Creditor(payments: dummyPayments)..entries = {...oneZeroEntry})
            .getDebtors(),
        [],
      );
    });

    test('getDebtors_立替額マイナスが1人でプラスが1人の時、マイナスの1人', () {
      expect(
        (Creditor(payments: dummyPayments)
              ..entries = {...oneMinusOnePlusEntries})
            .getDebtors(),
        [testParticipant2],
      );
    });

    test('getDebtors_立替額0が2人の時、空配列', () {
      expect(
        (Creditor(payments: dummyPayments)..entries = {...twoZeroEntries})
            .getDebtors(),
        [],
      );
    });

    test('getDebtors_立替額マイナスが2人でプラスが1人の時、マイナスの2人', () {
      expect(
        (Creditor(payments: dummyPayments)
              ..entries = {...twoMinusOnePlusEntries})
            .getDebtors(),
        [testParticipant2, testParticipant3],
      );
    });

    test('getDebtors_立替額マイナスが1人でプラスが2人の時、マイナスの1人', () {
      expect(
        (Creditor(payments: dummyPayments)
              ..entries = {...oneMinusTwoPlusEntries})
            .getDebtors(),
        [testParticipant3],
      );
    });

    test('getDebtors_立替額マイナスが1人でプラスが1人で0が1人の時、マイナスの1人', () {
      expect(
        (Creditor(payments: dummyPayments)
              ..entries = {...oneMinusOnePlusOneZeroEntries})
            .getDebtors(),
        [testParticipant2],
      );
    });

    test('getDebtors_立替額0が3人の時、空配列', () {
      expect(
        (Creditor(payments: dummyPayments)..entries = {...threeZeroEntries})
            .getDebtors(),
        [],
      );
    });

    test('getDebtors_実行前後で、インスタンスの持つ立替者プロパティが不変', () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        )
      ];
      final Creditor testCreditor = Creditor(payments: testPayments);

      expect((testCreditor..getDebtors()).entries, {
        testParticipant1: 4000,
        testParticipant2: -2000,
        testParticipant3: -2000
      });
    });

    test('PaymentsExt_toCreditorEntries_Paymentが空の時、エラー', () {
      final List<Payment> testPayments = [];

      expect(() => testPayments.toCreditorEntries(), throwsStateError);
    });

    test('PaymentsExt_toCreditorEntries_Paymentが1つの時立替額の合計値が0', () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        )
      ];

      expect(
        testPayments
            .toCreditorEntries()
            .values
            .reduce((current, next) => current + next),
        equals(0.0),
      );
    });

    test('PaymentsExt_toCreditorEntries_Paymentが1つの時立替額が均等割される', () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        )
      ];

      expect(
        testPayments.toCreditorEntries(),
        equals({
          testParticipant1: 4000.0,
          testParticipant2: -2000.0,
          testParticipant3: -2000.0
        }),
      );
    });

    test('PaymentsExt_toCreditorEntries_Paymentが2つの時立替額の合計値が0', () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 900,
          owners: {
            testParticipant1: false,
            testParticipant2: true,
            testParticipant3: true
          },
        )
      ];

      expect(
        testPayments
            .toCreditorEntries()
            .values
            .reduce((current, next) => current + next),
        equals(0.0),
      );
    });

    test('PaymentsExt_toCreditorEntries_Paymentが2つの時立替額が2会計の合算', () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 900,
          owners: {
            testParticipant1: false,
            testParticipant2: true,
            testParticipant3: true
          },
        )
      ];

      expect(
        Creditor(payments: testPayments).entries,
        equals({
          testParticipant1: 4000.0,
          testParticipant2: -1550.0,
          testParticipant3: -2450.0
        }),
      );
    });

    test('PaymentsExt_toCreditorEntries_Paymentが3つの時立替額の合計値が0', () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 900,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 30000,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        )
      ];

      expect(
        testPayments
            .toCreditorEntries()
            .values
            .reduce((current, next) => current + next),
        equals(0.0),
      );
    });

    test('PaymentsExt_toCreditorEntries_Paymentが3つの時立替額が3会計の合算', () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 900,
          owners: {
            testParticipant1: false,
            testParticipant2: true,
            testParticipant3: true
          },
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 30000,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        )
      ];

      expect(
        testPayments.toCreditorEntries(),
        equals({
          testParticipant1: -6000.0,
          testParticipant2: -11550.0,
          testParticipant3: 17550.0
        }),
      );
    });

    test('PaymentsExt_toCreditorEntries_Paymentに割り切れない値がある時、小数点まで含んだ合算値', () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 900,
          owners: {
            testParticipant1: false,
            testParticipant2: true,
            testParticipant3: true
          },
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 40000,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        )
      ];

      expect(
        testPayments.toCreditorEntries(),
        equals({
          testParticipant1: -9333.333333333334,
          testParticipant2: -14883.333333333334,
          testParticipant3: 24216.666666666664
        }),
      );
    });

    test('DoubleExt_floorAtSecondDecimal_0の時、0', () {
      expect(0.0.floorAtSecondDecimal(), equals(0));
    });

    test('DoubleExt_floorAtSecondDecimal_0.01未満と判断される値が切り捨てられる', () {
      expect(28.009999999999996.floorAtSecondDecimal(), equals(28));
    });

    test('DoubleExt_floorAtSecondDecimal_演算の結果0.01未満と判断される負の値が切り捨てられる', () {
      expect((-10 + 9.9900001).floorAtSecondDecimal(), equals(0));
    });

    test('DoubleExt_floorAtSecondDecimal_0.01以上と判断される値は残る', () {
      expect(28.009999999999997.floorAtSecondDecimal(), equals(28.01));
    });

    test('CreditorEntriesExt_apply_参加者1人支払者1人のPaymentを与えた時、0円の立替', () {
      final creditorEntries = {testParticipant1: 0.0};
      final testPayment = Payment(
        title: "testPaymentA",
        payer: testParticipant1,
        price: 6000,
        owners: {testParticipant1: true},
      );

      expect(
        creditorEntries..apply(testPayment),
        equals({testParticipant1: 0.0}),
      );
    });

    test('CreditorEntriesExt_apply_参加者1人支払者0人のPaymentを与えた時、例外', () {
      final creditorEntries = {testParticipant1: 0.0};
      final testPayment = Payment(
        title: "testPaymentA",
        payer: testParticipant1,
        price: 6000,
        owners: {testParticipant1: false},
      );

      expect(() => creditorEntries..apply(testPayment), throwsException);
    });

    test('CreditorEntriesExt_apply_参加者2人支払者2人のPaymentを与えた時、半額移動の立替', () {
      final creditorEntries = {testParticipant1: 0.0, testParticipant2: 0.0};
      final testPayment = Payment(
        title: "testPaymentA",
        payer: testParticipant1,
        price: 6000,
        owners: {testParticipant1: true, testParticipant2: true},
      );

      expect(
        creditorEntries..apply(testPayment),
        equals({testParticipant1: 3000.0, testParticipant2: -3000.0}),
      );
    });

    test(
        'CreditorEntriesExt_apply_参加者2人支払者2人のPaymentを、予め値を持つ立替に与えた時、半額移動の立替が追加',
        () {
      final creditorEntries = {
        testParticipant1: -500.0,
        testParticipant2: 500.0
      };
      final testPayment = Payment(
        title: "testPaymentA",
        payer: testParticipant1,
        price: 6000,
        owners: {testParticipant1: true, testParticipant2: true},
      );

      expect(
        creditorEntries..apply(testPayment),
        equals({testParticipant1: 2500.0, testParticipant2: -2500.0}),
      );
    });

    test('CreditorEntriesExt_apply_参加者2人支払者1人(立替者)のPaymentを与えた時、0円の立替', () {
      final creditorEntries = {testParticipant1: 0.0, testParticipant2: 0.0};
      final testPayment = Payment(
        title: "testPaymentA",
        payer: testParticipant1,
        price: 6000,
        owners: {testParticipant1: true, testParticipant2: false},
      );

      expect(
        creditorEntries..apply(testPayment),
        equals({testParticipant1: 0.0, testParticipant2: 0.0}),
      );
    });

    test('CreditorEntriesExt_apply_参加者2人支払者1人(非立替者)のPaymentを与えた時、全額移動の立替', () {
      final creditorEntries = {testParticipant1: 0.0, testParticipant2: 0.0};
      final testPayment = Payment(
        title: "testPaymentA",
        payer: testParticipant1,
        price: 6000,
        owners: {testParticipant1: false, testParticipant2: true},
      );

      expect(
        creditorEntries..apply(testPayment),
        equals({testParticipant1: 6000.0, testParticipant2: -6000.0}),
      );
    });

    test('CreditorEntriesExt_apply_参加者2人支払者0人のPaymentを与えた時、例外', () {
      final creditorEntries = {testParticipant1: 0.0, testParticipant2: 0.0};
      final testPayment = Payment(
        title: "testPaymentA",
        payer: testParticipant1,
        price: 6000,
        owners: {testParticipant1: false, testParticipant2: false},
      );

      expect(() => creditorEntries..apply(testPayment), throwsException);
    });

    test('CreditorEntriesExt_apply_参加者3人支払者3人のPaymentを与えた時、1/3額移動の立替', () {
      final creditorEntries = {
        testParticipant1: 0.0,
        testParticipant2: 0.0,
        testParticipant3: 0.0
      };
      final testPayment = Payment(
        title: "testPaymentA",
        payer: testParticipant1,
        price: 6000,
        owners: {
          testParticipant1: true,
          testParticipant2: true,
          testParticipant3: true
        },
      );

      expect(
        creditorEntries..apply(testPayment),
        equals({
          testParticipant1: 4000.0,
          testParticipant2: -2000.0,
          testParticipant3: -2000.0
        }),
      );
    });

    test(
        'CreditorEntriesExt_apply_参加者3人支払者3人のPaymentを、予め値を持つ立替に与えた時、1/3額移動の立替が追加',
        () {
      final creditorEntries = {
        testParticipant1: -200.0,
        testParticipant2: -200.0,
        testParticipant3: 400.0
      };
      final testPayment = Payment(
        title: "testPaymentA",
        payer: testParticipant1,
        price: 6000,
        owners: {
          testParticipant1: true,
          testParticipant2: true,
          testParticipant3: true
        },
      );

      expect(
        creditorEntries..apply(testPayment),
        equals({
          testParticipant1: 3800.0,
          testParticipant2: -2200.0,
          testParticipant3: -1600.0
        }),
      );
    });

    test('CreditorEntriesExt_apply_参加者3人支払者2人(立替者含む)のPaymentを与えた時、半額移動の立替', () {
      final creditorEntries = {
        testParticipant1: 0.0,
        testParticipant2: 0.0,
        testParticipant3: 0.0
      };
      final testPayment = Payment(
        title: "testPaymentA",
        payer: testParticipant1,
        price: 6000,
        owners: {
          testParticipant1: true,
          testParticipant2: true,
          testParticipant3: false
        },
      );

      expect(
        creditorEntries..apply(testPayment),
        equals({
          testParticipant1: 3000.0,
          testParticipant2: -3000.0,
          testParticipant3: 0.0
        }),
      );
    });

    test('CreditorEntriesExt_apply_参加者3人支払者2人(立替者含まず)のPaymentを与えた時、合計全額移動の立替',
        () {
      final creditorEntries = {
        testParticipant1: 0.0,
        testParticipant2: 0.0,
        testParticipant3: 0.0
      };
      final testPayment = Payment(
        title: "testPaymentA",
        payer: testParticipant1,
        price: 6000,
        owners: {
          testParticipant1: false,
          testParticipant2: true,
          testParticipant3: true
        },
      );

      expect(
        creditorEntries..apply(testPayment),
        equals({
          testParticipant1: 6000.0,
          testParticipant2: -3000.0,
          testParticipant3: -3000.0
        }),
      );
    });

    test('CreditorEntriesExt_apply_参加者3人支払者1人(立替者)のPaymentを与えた時、0円の立替', () {
      final creditorEntries = {
        testParticipant1: 0.0,
        testParticipant2: 0.0,
        testParticipant3: 0.0
      };
      final testPayment = Payment(
        title: "testPaymentA",
        payer: testParticipant1,
        price: 6000,
        owners: {
          testParticipant1: true,
          testParticipant2: false,
          testParticipant3: false
        },
      );

      expect(
        creditorEntries..apply(testPayment),
        equals({
          testParticipant1: 0.0,
          testParticipant2: 0.0,
          testParticipant3: 0.0
        }),
      );
    });

    test('CreditorEntriesExt_apply_参加者3人支払者1人(非立替者)のPaymentを与えた時、全額移動の立替', () {
      final creditorEntries = {
        testParticipant1: 0.0,
        testParticipant2: 0.0,
        testParticipant3: 0.0
      };
      final testPayment = Payment(
        title: "testPaymentA",
        payer: testParticipant1,
        price: 6000,
        owners: {
          testParticipant1: false,
          testParticipant2: true,
          testParticipant3: false
        },
      );

      expect(
        creditorEntries..apply(testPayment),
        equals({
          testParticipant1: 6000.0,
          testParticipant2: -6000.0,
          testParticipant3: 0.0
        }),
      );
    });

    test('CreditorEntriesExt_apply_参加者3人支払者0人のPaymentを与えた時、例外', () {
      final creditorEntries = {
        testParticipant1: 0.0,
        testParticipant2: 0.0,
        testParticipant3: 0.0
      };
      final testPayment = Payment(
        title: "testPaymentA",
        payer: testParticipant1,
        price: 6000,
        owners: {
          testParticipant1: false,
          testParticipant2: false,
          testParticipant3: false
        },
      );

      expect(() => creditorEntries..apply(testPayment), throwsException);
    });
  });

  group('SettlementComparer', () {
    test('isEqualTo_支払元のインスタンスと支払先のインスタンスと支払い量が等しい時true', () {
      final fromTestParticipant = Participant("testFromName");
      final toTestParticipant = Participant("testToName");

      expect(
        Settlement(
          from: fromTestParticipant,
          to: toTestParticipant,
          amount: 30,
        ).isEqualTo(
          Settlement(
            from: fromTestParticipant,
            to: toTestParticipant,
            amount: 30,
          ),
        ),
        equals(true),
      );
    });

    test('isEqualTo_支払元のインスタンスが異なる時false', () {
      final fromTestParticipant = Participant("testFromName");
      final toTestParticipant = Participant("testToName");

      expect(
        Settlement(
          from: fromTestParticipant,
          to: toTestParticipant,
          amount: 30,
        ).isEqualTo(
          Settlement(
            from: Participant("testFromName"),
            to: toTestParticipant,
            amount: 30,
          ),
        ),
        equals(false),
      );
    });

    test('isEqualTo_支払先のインスタンスが異なる時false', () {
      final fromTestParticipant = Participant("testFromName");
      final toTestParticipant = Participant("testToName");

      expect(
        Settlement(from: fromTestParticipant, to: toTestParticipant, amount: 30)
            .isEqualTo(
          Settlement(
            from: fromTestParticipant,
            to: Participant("testToName"),
            amount: 30,
          ),
        ),
        equals(false),
      );
    });

    test('isEqualTo_支払い量が異なる時false', () {
      final fromTestParticipant = Participant("testFromName");
      final toTestParticipant = Participant("testToName");

      expect(
        Settlement(from: fromTestParticipant, to: toTestParticipant, amount: 30)
            .isEqualTo(
          Settlement(
            from: fromTestParticipant,
            to: toTestParticipant,
            amount: 30.01,
          ),
        ),
        equals(false),
      );
    });
  });
}

extension SettlementComparer on Settlement {
  bool isEqualTo(Settlement target) =>
      target.from == from && target.to == to && target.amount == amount;
}
