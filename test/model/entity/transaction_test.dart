import 'package:flutter/foundation.dart';
import 'package:tatetsu/model/entity/creditor.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';
import 'package:tatetsu/model/entity/procedure.dart';
import 'package:tatetsu/model/entity/transaction.dart';
import 'package:test/test.dart';

void main() {
  final Participant testParticipant1 = Participant("testName1");
  final Participant testParticipant2 = Participant("testName2");
  final Participant testParticipant3 = Participant("testName3");
  final Participant testParticipant4 = Participant("testName4");
  final Participant testParticipant5 = Participant("testName5");

  final fiveParticipantsTrueMap = {
    testParticipant1: true,
    testParticipant2: true,
    testParticipant3: true,
    testParticipant4: true,
    testParticipant5: true,
  };

  group('Transaction', () {
    test('Transaction_creditor属性が、Paymentが1つの時立替額が均等割される', () {
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
        Transaction(testPayments).creditor.entries,
        equals({
          testParticipant1: 4000.0,
          testParticipant2: -2000.0,
          testParticipant3: -2000.0
        }),
      );
    });

    test('Transaction_creditor属性が、Paymentが2つの時立替額が2会計の合算', () {
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
        Transaction(testPayments).creditor.entries,
        equals({
          testParticipant1: 4000.0,
          testParticipant2: -1550.0,
          testParticipant3: -2450.0
        }),
      );
    });

    test('Transaction_creditor属性が、Paymentが3つの時立替額が3会計の合算', () {
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
        Transaction(testPayments).creditor.entries,
        equals({
          testParticipant1: -6000.0,
          testParticipant2: -11550.0,
          testParticipant3: 17550.0
        }),
      );
    });

    test('Transaction_creditor属性が、Paymentに割り切れない値がある時、小数点まで含んだ合算値', () {
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
        Transaction(testPayments).creditor.entries,
        equals({
          testParticipant1: -9333.33,
          testParticipant2: -14883.33,
          testParticipant3: 24216.66
        }),
      );
    });

    test('getSettlement_与えたPaymentの精算結果に誤差が発生する際、手順及び精算結果誤差が含まれる', () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 20,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true,
          },
        )
      ];
      final testSettlement = Transaction(testPayments).getSettlement();
      expect(
        testSettlement.procedures.hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant2,
              to: testParticipant1,
              amount: 6.66,
            ),
            Procedure(
              from: testParticipant3,
              to: testParticipant1,
              amount: 6.66,
            )
          ],
        ),
        equals(true),
      );
      expect(
        mapEquals(testSettlement.errors, {testParticipant1: 0.01}),
        equals(true),
      );
    });

    test('CreditorExt_getSettlementProcedures_立替費0の参加者１人の時、空配列', () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {
            testParticipant1: true,
          },
        )
      ];

      expect(
        Creditor(payments: testPayments).getSettlementProcedures(),
        equals([]),
      );
    });

    test(
        'CreditorExt_getSettlementProcedures_プラス立替費者者1人とマイナス立替費者者1人の時、マイナス立替者からプラス立替者への精算1つ',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
          },
        )
      ];

      expect(
        Creditor(payments: testPayments)
            .getSettlementProcedures()
            .hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant2,
              to: testParticipant1,
              amount: 3000,
            )
          ],
        ),
        equals(true),
      );
    });

    test(
        'CreditorExt_getSettlementProcedures_プラス立替費者者4人とマイナス立替費者者1人の時、マイナス立替者からプラス立替者への精算4つ',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 100000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 110000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 101000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentD",
          payer: testParticipant4,
          price: 100100,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentE",
          payer: testParticipant5,
          price: 10,
          owners: fiveParticipantsTrueMap,
        ),
      ];

      expect(
        Creditor(payments: testPayments)
            .getSettlementProcedures()
            .hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant5,
              to: testParticipant1,
              amount: 17778,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant2,
              amount: 27778,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant3,
              amount: 18778,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant4,
              amount: 17878,
            ),
          ],
        ),
        equals(true),
      );
    });

    test(
        'CreditorExt_getSettlementProcedures_差の小さなプラス立替費者者3人と差の小さなマイナス立替費者者2人の時、マイナス立替者2人からの精算2件ずつ',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 100000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 110000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 1000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentD",
          payer: testParticipant4,
          price: 100100,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentE",
          payer: testParticipant5,
          price: 10,
          owners: fiveParticipantsTrueMap,
        ),
      ];

      expect(
        Creditor(payments: testPayments)
            .getSettlementProcedures()
            .hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant3,
              to: testParticipant1,
              amount: 37778,
            ),
            Procedure(
              from: testParticipant3,
              to: testParticipant2,
              amount: 23444,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant2,
              amount: 24334,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant4,
              amount: 37878,
            ),
          ],
        ),
        equals(true),
      );
    });

    test(
        'CreditorExt_getSettlementProcedures_差の小さなプラス立替費者者3人と差の大きなマイナス立替費者者2人(早順番者がマイナス大)の時、早順番マイナス立替者からの精算3件と遅順番マイナス立替者からの精算1件',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 100000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 110000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 1000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentD",
          payer: testParticipant4,
          price: 100100,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentE",
          payer: testParticipant5,
          price: 50010,
          owners: fiveParticipantsTrueMap,
        ),
      ];

      expect(
        Creditor(payments: testPayments)
            .getSettlementProcedures()
            .hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant3,
              to: testParticipant1,
              amount: 27778,
            ),
            Procedure(
              from: testParticipant3,
              to: testParticipant2,
              amount: 37778,
            ),
            Procedure(
              from: testParticipant3,
              to: testParticipant4,
              amount: 5666,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant4,
              amount: 22212,
            ),
          ],
        ),
        equals(true),
      );
    });

    test(
        'CreditorExt_getSettlementProcedures_差の小さなプラス立替費者者3人と差の大きなマイナス立替費者者2人(早順番者がマイナス小)の時、早順番マイナス立替者からの精算1件と遅順番マイナス立替者からの精算3件',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 100000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 110000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 51000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentD",
          payer: testParticipant4,
          price: 100100,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentE",
          payer: testParticipant5,
          price: 10,
          owners: fiveParticipantsTrueMap,
        )
      ];

      expect(
        Creditor(payments: testPayments)
            .getSettlementProcedures()
            .hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant3,
              to: testParticipant1,
              amount: 21222,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant1,
              amount: 6556,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant2,
              amount: 37778,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant4,
              amount: 27878,
            ),
          ],
        ),
        equals(true),
      );
    });

    test(
        'CreditorExt_getSettlementProcedures_1人(早順番者)が特に大きいプラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算1件と遅順番マイナス立替者からの精算3件',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 200000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 110000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 1000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentD",
          payer: testParticipant4,
          price: 100100,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentE",
          payer: testParticipant5,
          price: 10,
          owners: fiveParticipantsTrueMap,
        )
      ];

      expect(
        Creditor(payments: testPayments)
            .getSettlementProcedures()
            .hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant3,
              to: testParticipant1,
              amount: 81222,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant1,
              amount: 36556,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant2,
              amount: 27778,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant4,
              amount: 17878,
            ),
          ],
        ),
        equals(true),
      );
    });

    test(
        'CreditorExt_getSettlementProcedures_1人(中順番者)が特に大きいプラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算2件と遅順番マイナス立替者からの精算2件',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 100000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 210000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 1000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentD",
          payer: testParticipant4,
          price: 100100,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentE",
          payer: testParticipant5,
          price: 10,
          owners: fiveParticipantsTrueMap,
        )
      ];

      expect(
        Creditor(payments: testPayments)
            .getSettlementProcedures()
            .hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant3,
              to: testParticipant1,
              amount: 17778,
            ),
            Procedure(
              from: testParticipant3,
              to: testParticipant2,
              amount: 63444,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant2,
              amount: 64334,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant4,
              amount: 17878,
            ),
          ],
        ),
        equals(true),
      );
    });

    test(
        'CreditorExt_getSettlementProcedures_1人(遅順番者)が特に大きいプラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算3件と遅順番マイナス立替者からの精算1件',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 100000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 110000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 1000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentD",
          payer: testParticipant4,
          price: 200100,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentE",
          payer: testParticipant5,
          price: 10,
          owners: fiveParticipantsTrueMap,
        )
      ];

      expect(
        Creditor(payments: testPayments)
            .getSettlementProcedures()
            .hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant3,
              to: testParticipant1,
              amount: 17778,
            ),
            Procedure(
              from: testParticipant3,
              to: testParticipant2,
              amount: 27778,
            ),
            Procedure(
              from: testParticipant3,
              to: testParticipant4,
              amount: 35666,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant4,
              amount: 82212,
            ),
          ],
        ),
        equals(true),
      );
    });

    test(
        'CreditorExt_getSettlementProcedures_1人(早順番者)が特に小さいプラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算2件と遅順番マイナス立替者からの精算2件',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 150000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 210000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 1000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentD",
          payer: testParticipant4,
          price: 200100,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentE",
          payer: testParticipant5,
          price: 10,
          owners: fiveParticipantsTrueMap,
        )
      ];

      expect(
        Creditor(payments: testPayments)
            .getSettlementProcedures()
            .hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant3,
              to: testParticipant1,
              amount: 37778,
            ),
            Procedure(
              from: testParticipant3,
              to: testParticipant2,
              amount: 73444,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant2,
              amount: 24334,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant4,
              amount: 87878,
            ),
          ],
        ),
        equals(true),
      );
    });

    test(
        'CreditorExt_getSettlementProcedures_1人(中順番者)が特に小さいプラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算2件と遅順番マイナス立替者からの精算2件',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 200000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 160000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 1000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentD",
          payer: testParticipant4,
          price: 200100,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentE",
          payer: testParticipant5,
          price: 10,
          owners: fiveParticipantsTrueMap,
        )
      ];

      expect(
        Creditor(payments: testPayments)
            .getSettlementProcedures()
            .hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant3,
              to: testParticipant1,
              amount: 87778,
            ),
            Procedure(
              from: testParticipant3,
              to: testParticipant2,
              amount: 23444,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant2,
              amount: 24334,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant4,
              amount: 87878,
            ),
          ],
        ),
        equals(true),
      );
    });

    test(
        'CreditorExt_getSettlementProcedures_1人(遅順番者)が特に小さいプラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算2件と遅順番マイナス立替者からの精算2件',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 200000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 210000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 1000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentD",
          payer: testParticipant4,
          price: 150100,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentE",
          payer: testParticipant5,
          price: 10,
          owners: fiveParticipantsTrueMap,
        )
      ];

      expect(
        Creditor(payments: testPayments)
            .getSettlementProcedures()
            .hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant3,
              to: testParticipant1,
              amount: 87778,
            ),
            Procedure(
              from: testParticipant3,
              to: testParticipant2,
              amount: 23444,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant2,
              amount: 74334,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant4,
              amount: 37878,
            ),
          ],
        ),
        equals(true),
      );
    });

    test(
        'CreditorExt_getSettlementProcedures_差の大きな(早<中<遅)プラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算3件と遅順番マイナス立替者からの精算1件',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 100000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 160000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 1000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentD",
          payer: testParticipant4,
          price: 200100,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentE",
          payer: testParticipant5,
          price: 10,
          owners: fiveParticipantsTrueMap,
        )
      ];

      expect(
        Creditor(payments: testPayments)
            .getSettlementProcedures()
            .hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant3,
              to: testParticipant1,
              amount: 7778,
            ),
            Procedure(
              from: testParticipant3,
              to: testParticipant2,
              amount: 67778,
            ),
            Procedure(
              from: testParticipant3,
              to: testParticipant4,
              amount: 15666,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant4,
              amount: 92212,
            ),
          ],
        ),
        equals(true),
      );
    });

    test(
        'CreditorExt_getSettlementProcedures_差の大きな(早<遅<中)プラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算2件と遅順番マイナス立替者からの精算2件',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 100000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 210000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 1000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentD",
          payer: testParticipant4,
          price: 150100,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentE",
          payer: testParticipant5,
          price: 10,
          owners: fiveParticipantsTrueMap,
        )
      ];

      expect(
        Creditor(payments: testPayments)
            .getSettlementProcedures()
            .hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant3,
              to: testParticipant1,
              amount: 7778,
            ),
            Procedure(
              from: testParticipant3,
              to: testParticipant2,
              amount: 83444,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant2,
              amount: 34334,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant4,
              amount: 57878,
            ),
          ],
        ),
        equals(true),
      );
    });

    test(
        'CreditorExt_getSettlementProcedures_差の大きな(中<早<遅)プラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算3件と遅順番マイナス立替者からの精算1件',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 150000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 110000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 1000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentD",
          payer: testParticipant4,
          price: 200100,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentE",
          payer: testParticipant5,
          price: 10,
          owners: fiveParticipantsTrueMap,
        )
      ];

      expect(
        Creditor(payments: testPayments)
            .getSettlementProcedures()
            .hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant3,
              to: testParticipant1,
              amount: 57778,
            ),
            Procedure(
              from: testParticipant3,
              to: testParticipant2,
              amount: 17778,
            ),
            Procedure(
              from: testParticipant3,
              to: testParticipant4,
              amount: 15666,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant4,
              amount: 92212,
            ),
          ],
        ),
        equals(true),
      );
    });

    test(
        'CreditorExt_getSettlementProcedures_差の大きな(中<遅<早)プラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算1件と遅順番マイナス立替者からの精算3件',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 200000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 110000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 1000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentD",
          payer: testParticipant4,
          price: 150100,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentE",
          payer: testParticipant5,
          price: 10,
          owners: fiveParticipantsTrueMap,
        )
      ];

      expect(
        Creditor(payments: testPayments)
            .getSettlementProcedures()
            .hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant3,
              to: testParticipant1,
              amount: 91222,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant1,
              amount: 16556,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant2,
              amount: 17778,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant4,
              amount: 57878,
            ),
          ],
        ),
        equals(true),
      );
    });

    test(
        'CreditorExt_getSettlementProcedures_差の大きな(遅<早<中)プラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算2件と遅順番マイナス立替者からの精算2件',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 150000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 210000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 1000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentD",
          payer: testParticipant4,
          price: 100100,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentE",
          payer: testParticipant5,
          price: 10,
          owners: fiveParticipantsTrueMap,
        )
      ];

      expect(
        Creditor(payments: testPayments)
            .getSettlementProcedures()
            .hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant3,
              to: testParticipant1,
              amount: 57778,
            ),
            Procedure(
              from: testParticipant3,
              to: testParticipant2,
              amount: 33444,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant2,
              amount: 84334,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant4,
              amount: 7878,
            ),
          ],
        ),
        equals(true),
      );
    });

    test(
        'CreditorExt_getSettlementProcedures_差の大きな(遅<中<早)プラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算1件と遅順番マイナス立替者からの精算3件',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 200000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentB",
          payer: testParticipant2,
          price: 160000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentC",
          payer: testParticipant3,
          price: 1000,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentD",
          payer: testParticipant4,
          price: 100100,
          owners: fiveParticipantsTrueMap,
        ),
        Payment(
          title: "testPaymentE",
          payer: testParticipant5,
          price: 10,
          owners: fiveParticipantsTrueMap,
        )
      ];

      expect(
        Creditor(payments: testPayments)
            .getSettlementProcedures()
            .hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant3,
              to: testParticipant1,
              amount: 91222,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant1,
              amount: 16556,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant2,
              amount: 67778,
            ),
            Procedure(
              from: testParticipant5,
              to: testParticipant4,
              amount: 7878,
            ),
          ],
        ),
        equals(true),
      );
    });

    test('ProceduresExt_getSettlementErrors_精算手順が空の時、与えた立替の合算値と同じ', () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 30,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        ),
      ];
      final List<Procedure> testProcedures = [];

      expect(
        mapEquals(
          testProcedures.getSettlementErrors(
            toward: Creditor(payments: testPayments),
          ),
          Creditor(payments: testPayments).entries,
        ),
        equals(true),
      );
    });

    test('ProceduresExt_getSettlementErrors_精算手順が1つの時、与えた立替の合算値に反映された値', () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 30,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        ),
      ];
      final List<Procedure> testProcedures = [
        Procedure(from: testParticipant2, to: testParticipant1, amount: 5),
      ];

      expect(
        mapEquals(
          testProcedures.getSettlementErrors(
            toward: Creditor(payments: testPayments),
          ),
          {
            testParticipant1: 20 - 5,
            testParticipant2: -10 + 5,
            testParticipant3: -10
          },
        ),
        equals(true),
      );
    });

    test('ProceduresExt_getSettlementErrors_精算手順が2つ以上の時、与えた立替の合算値に反映された値', () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 30,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        ),
      ];
      final List<Procedure> testProcedures = [
        Procedure(from: testParticipant2, to: testParticipant1, amount: 5),
        Procedure(from: testParticipant2, to: testParticipant1, amount: 2),
        Procedure(from: testParticipant3, to: testParticipant1, amount: 9),
      ];

      expect(
        mapEquals(
          testProcedures.getSettlementErrors(
            toward: Creditor(payments: testPayments),
          ),
          {
            testParticipant1: 20 - 5 - 2 - 9,
            testParticipant2: -10 + 5 + 2,
            testParticipant3: -10 + 9
          },
        ),
        equals(true),
      );
    });

    test(
        'ProceduresExt_getSettlementErrors_0.01未満の精算値は切り捨てられて、与えた立替の合算値に反映された値',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 30,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        ),
      ];
      final List<Procedure> testProcedures = [
        Procedure(from: testParticipant2, to: testParticipant1, amount: 5.0099),
      ];

      expect(
        mapEquals(
          testProcedures.getSettlementErrors(
            toward: Creditor(payments: testPayments),
          ),
          {
            testParticipant1: 20 - 5,
            testParticipant2: -10 + 5,
            testParticipant3: -10
          },
        ),
        equals(true),
      );
    });

    test(
        'ProceduresExt_getSettlementErrors_反映させると0.01未満になる精算手順を与えた時、当該の参加者に関する要素が消える',
        () {
      final List<Payment> testPayments = [
        Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 30,
          owners: {
            testParticipant1: true,
            testParticipant2: true,
            testParticipant3: true
          },
        ),
      ];
      final List<Procedure> testProcedures = [
        Procedure(from: testParticipant2, to: testParticipant1, amount: 5),
        Procedure(from: testParticipant2, to: testParticipant1, amount: 2),
        Procedure(
          from: testParticipant3,
          to: testParticipant1,
          amount: 9.9999999999999999,
        ),
      ];

      expect(
        mapEquals(
          testProcedures.getSettlementErrors(
            toward: Creditor(payments: testPayments),
          ),
          {
            testParticipant1: 3,
            testParticipant2: -3,
          },
        ),
        equals(true),
      );
    });
  });

  group('ProceduresComparer', () {
    test('hasEquivalentElements_支払元のインスタンスと支払先のインスタンスと支払い量が等しい組み合わせの時true', () {
      expect(
        [
          Procedure(
            from: testParticipant1,
            to: testParticipant3,
            amount: 100,
          ),
          Procedure(
            from: testParticipant1,
            to: testParticipant5,
            amount: 1000,
          ),
          Procedure(
            from: testParticipant4,
            to: testParticipant2,
            amount: 10000,
          ),
        ].hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant4,
              to: testParticipant2,
              amount: 10000,
            ),
            Procedure(
              from: testParticipant1,
              to: testParticipant5,
              amount: 1000,
            ),
            Procedure(
              from: testParticipant1,
              to: testParticipant3,
              amount: 100,
            ),
          ],
        ),
        equals(true),
      );
    });

    test('hasEquivalentElements_不足している要素がある時false', () {
      expect(
        [
          Procedure(
            from: testParticipant1,
            to: testParticipant3,
            amount: 100,
          ),
          Procedure(
            from: testParticipant1,
            to: testParticipant5,
            amount: 1000,
          ),
          Procedure(
            from: testParticipant4,
            to: testParticipant2,
            amount: 10000,
          ),
        ].hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant4,
              to: testParticipant2,
              amount: 10000,
            ),
            Procedure(
              from: testParticipant1,
              to: testParticipant5,
              amount: 1000,
            ),
          ],
        ),
        equals(false),
      );
    });

    test('hasEquivalentElements_余分な要素がある時false', () {
      expect(
        [
          Procedure(
            from: testParticipant1,
            to: testParticipant3,
            amount: 100,
          ),
          Procedure(
            from: testParticipant1,
            to: testParticipant5,
            amount: 1000,
          ),
          Procedure(
            from: testParticipant4,
            to: testParticipant2,
            amount: 10000,
          ),
        ].hasEquivalentElements(
          to: [
            Procedure(
              from: testParticipant4,
              to: testParticipant2,
              amount: 10000,
            ),
            Procedure(
              from: testParticipant1,
              to: testParticipant5,
              amount: 1000,
            ),
            Procedure(
              from: testParticipant1,
              to: testParticipant3,
              amount: 100,
            ),
            Procedure(
              from: testParticipant4,
              to: testParticipant2,
              amount: 100000,
            ),
          ],
        ),
        equals(false),
      );
    });
  });
}

extension ProceduresComparer on List<Procedure> {
  bool hasEquivalentElements({required List<Procedure> to}) {
    if (length != to.length) {
      return false;
    }
    return map(
      (lhs) =>
          to.cast<Procedure?>().firstWhere(
                (rhs) =>
                    (lhs.from == rhs!.from) &&
                    (lhs.to == rhs.to) &&
                    (lhs.amount == rhs.amount),
                orElse: () => null,
              ) !=
          null,
    ).reduce((value, element) => value && element);
  }
}
