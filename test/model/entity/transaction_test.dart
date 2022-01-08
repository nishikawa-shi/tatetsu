import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';
import 'package:tatetsu/model/entity/settlement.dart';
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
            })
      ];

      expect(
          Transaction(testPayments).creditor.entries,
          equals({
            testParticipant1: 4000.0,
            testParticipant2: -2000.0,
            testParticipant3: -2000.0
          }));
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
            }),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 900,
            owners: {
              testParticipant1: false,
              testParticipant2: true,
              testParticipant3: true
            })
      ];
      expect(
          Transaction(testPayments).creditor.entries,
          equals({
            testParticipant1: 4000.0,
            testParticipant2: -1550.0,
            testParticipant3: -2450.0
          }));
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
            }),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 900,
            owners: {
              testParticipant1: false,
              testParticipant2: true,
              testParticipant3: true
            }),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 30000,
            owners: {
              testParticipant1: true,
              testParticipant2: true,
              testParticipant3: true
            })
      ];

      expect(
          Transaction(testPayments).creditor.entries,
          equals({
            testParticipant1: -6000.0,
            testParticipant2: -11550.0,
            testParticipant3: 17550.0
          }));
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
            }),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 900,
            owners: {
              testParticipant1: false,
              testParticipant2: true,
              testParticipant3: true
            }),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 40000,
            owners: {
              testParticipant1: true,
              testParticipant2: true,
              testParticipant3: true
            })
      ];

      expect(
          Transaction(testPayments).creditor.entries,
          equals({
            testParticipant1: -9333.333333333334,
            testParticipant2: -14883.333333333334,
            testParticipant3: 24216.666666666664
          }));
    });

    test('getSettlements_立替費0の参加者１人の時、空配列', () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 6000,
            owners: {
              testParticipant1: true,
            })
      ];

      expect(Transaction(testPayments).getSettlements(), equals([]));
    });

    test('getSettlements_プラス立替費者者1人とマイナス立替費者者1人の時、マイナス立替者からプラス立替者への精算1つ', () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 6000,
            owners: {
              testParticipant1: true,
              testParticipant2: true,
            })
      ];

      expect(
          Transaction(testPayments).getSettlements().hasEquivalentElements(to: [
            Settlement(
                from: testParticipant2, to: testParticipant1, amount: 3000)
          ]),
          equals(true));
    });

    test('getSettlements_プラス立替費者者4人とマイナス立替費者者1人の時、マイナス立替者からプラス立替者への精算4つ', () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 100000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 110000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 101000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentD",
            payer: testParticipant4,
            price: 100100,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentE",
            payer: testParticipant5,
            price: 10,
            owners: fiveParticipantsTrueMap),
      ];

      expect(
          Transaction(testPayments).getSettlements().hasEquivalentElements(to: [
            Settlement(
                from: testParticipant5, to: testParticipant1, amount: 17778),
            Settlement(
                from: testParticipant5, to: testParticipant2, amount: 27778),
            Settlement(
                from: testParticipant5, to: testParticipant3, amount: 18778),
            Settlement(
                from: testParticipant5, to: testParticipant4, amount: 17878),
          ]),
          equals(true));
    });

    test('getSettlements_差の小さなプラス立替費者者3人と差の小さなマイナス立替費者者2人の時、マイナス立替者2人からの精算2件ずつ',
        () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 100000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 110000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 1000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentD",
            payer: testParticipant4,
            price: 100100,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentE",
            payer: testParticipant5,
            price: 10,
            owners: fiveParticipantsTrueMap),
      ];

      expect(
          Transaction(testPayments).getSettlements().hasEquivalentElements(to: [
            Settlement(
                from: testParticipant3, to: testParticipant1, amount: 37778),
            Settlement(
                from: testParticipant3, to: testParticipant2, amount: 23444),
            Settlement(
                from: testParticipant5, to: testParticipant2, amount: 24334),
            Settlement(
                from: testParticipant5, to: testParticipant4, amount: 37878),
          ]),
          equals(true));
    });

    test(
        'getSettlements_差の小さなプラス立替費者者3人と差の大きなマイナス立替費者者2人(早順番者がマイナス大)の時、早順番マイナス立替者からの精算3件と遅順番マイナス立替者からの精算1件',
        () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 100000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 110000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 1000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentD",
            payer: testParticipant4,
            price: 100100,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentE",
            payer: testParticipant5,
            price: 50010,
            owners: fiveParticipantsTrueMap),
      ];

      expect(
          Transaction(testPayments).getSettlements().hasEquivalentElements(to: [
            Settlement(
                from: testParticipant3, to: testParticipant1, amount: 27778),
            Settlement(
                from: testParticipant3, to: testParticipant2, amount: 37778),
            Settlement(
                from: testParticipant3, to: testParticipant4, amount: 5666),
            Settlement(
                from: testParticipant5, to: testParticipant4, amount: 22212),
          ]),
          equals(true));
    });

    test(
        'getSettlements_差の小さなプラス立替費者者3人と差の大きなマイナス立替費者者2人(早順番者がマイナス小)の時、早順番マイナス立替者からの精算1件と遅順番マイナス立替者からの精算3件',
        () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 100000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 110000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 51000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentD",
            payer: testParticipant4,
            price: 100100,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentE",
            payer: testParticipant5,
            price: 10,
            owners: fiveParticipantsTrueMap)
      ];

      expect(
          Transaction(testPayments).getSettlements().hasEquivalentElements(to: [
            Settlement(
                from: testParticipant3, to: testParticipant1, amount: 21222),
            Settlement(
                from: testParticipant5, to: testParticipant1, amount: 6556),
            Settlement(
                from: testParticipant5, to: testParticipant2, amount: 37778),
            Settlement(
                from: testParticipant5, to: testParticipant4, amount: 27878),
          ]),
          equals(true));
    });

    test(
        'getSettlements_1人(早順番者)が特に大きいプラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算1件と遅順番マイナス立替者からの精算3件',
        () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 200000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 110000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 1000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentD",
            payer: testParticipant4,
            price: 100100,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentE",
            payer: testParticipant5,
            price: 10,
            owners: fiveParticipantsTrueMap)
      ];

      expect(
          Transaction(testPayments).getSettlements().hasEquivalentElements(to: [
            Settlement(
                from: testParticipant3, to: testParticipant1, amount: 81222),
            Settlement(
                from: testParticipant5, to: testParticipant1, amount: 36556),
            Settlement(
                from: testParticipant5, to: testParticipant2, amount: 27778),
            Settlement(
                from: testParticipant5, to: testParticipant4, amount: 17878),
          ]),
          equals(true));
    });

    test(
        'getSettlements_1人(中順番者)が特に大きいプラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算2件と遅順番マイナス立替者からの精算2件',
        () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 100000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 210000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 1000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentD",
            payer: testParticipant4,
            price: 100100,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentE",
            payer: testParticipant5,
            price: 10,
            owners: fiveParticipantsTrueMap)
      ];

      expect(
          Transaction(testPayments).getSettlements().hasEquivalentElements(to: [
            Settlement(
                from: testParticipant3, to: testParticipant1, amount: 17778),
            Settlement(
                from: testParticipant3, to: testParticipant2, amount: 63444),
            Settlement(
                from: testParticipant5, to: testParticipant2, amount: 64334),
            Settlement(
                from: testParticipant5, to: testParticipant4, amount: 17878),
          ]),
          equals(true));
    });

    test(
        'getSettlements_1人(遅順番者)が特に大きいプラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算3件と遅順番マイナス立替者からの精算1件',
        () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 100000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 110000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 1000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentD",
            payer: testParticipant4,
            price: 200100,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentE",
            payer: testParticipant5,
            price: 10,
            owners: fiveParticipantsTrueMap)
      ];

      expect(
          Transaction(testPayments).getSettlements().hasEquivalentElements(to: [
            Settlement(
                from: testParticipant3, to: testParticipant1, amount: 17778),
            Settlement(
                from: testParticipant3, to: testParticipant2, amount: 27778),
            Settlement(
                from: testParticipant3, to: testParticipant4, amount: 35666),
            Settlement(
                from: testParticipant5, to: testParticipant4, amount: 82212),
          ]),
          equals(true));
    });

    test(
        'getSettlements_1人(早順番者)が特に小さいプラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算2件と遅順番マイナス立替者からの精算2件',
        () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 150000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 210000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 1000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentD",
            payer: testParticipant4,
            price: 200100,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentE",
            payer: testParticipant5,
            price: 10,
            owners: fiveParticipantsTrueMap)
      ];

      expect(
          Transaction(testPayments).getSettlements().hasEquivalentElements(to: [
            Settlement(
                from: testParticipant3, to: testParticipant1, amount: 37778),
            Settlement(
                from: testParticipant3, to: testParticipant2, amount: 73444),
            Settlement(
                from: testParticipant5, to: testParticipant2, amount: 24334),
            Settlement(
                from: testParticipant5, to: testParticipant4, amount: 87878),
          ]),
          equals(true));
    });

    test(
        'getSettlements_1人(中順番者)が特に小さいプラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算2件と遅順番マイナス立替者からの精算2件',
        () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 200000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 160000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 1000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentD",
            payer: testParticipant4,
            price: 200100,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentE",
            payer: testParticipant5,
            price: 10,
            owners: fiveParticipantsTrueMap)
      ];

      expect(
          Transaction(testPayments).getSettlements().hasEquivalentElements(to: [
            Settlement(
                from: testParticipant3, to: testParticipant1, amount: 87778),
            Settlement(
                from: testParticipant3, to: testParticipant2, amount: 23444),
            Settlement(
                from: testParticipant5, to: testParticipant2, amount: 24334),
            Settlement(
                from: testParticipant5, to: testParticipant4, amount: 87878),
          ]),
          equals(true));
    });

    test(
        'getSettlements_1人(遅順番者)が特に小さいプラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算2件と遅順番マイナス立替者からの精算2件',
        () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 200000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 210000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 1000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentD",
            payer: testParticipant4,
            price: 150100,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentE",
            payer: testParticipant5,
            price: 10,
            owners: fiveParticipantsTrueMap)
      ];

      expect(
          Transaction(testPayments).getSettlements().hasEquivalentElements(to: [
            Settlement(
                from: testParticipant3, to: testParticipant1, amount: 87778),
            Settlement(
                from: testParticipant3, to: testParticipant2, amount: 23444),
            Settlement(
                from: testParticipant5, to: testParticipant2, amount: 74334),
            Settlement(
                from: testParticipant5, to: testParticipant4, amount: 37878),
          ]),
          equals(true));
    });

    test(
        'getSettlements_差の大きな(早<中<遅)プラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算3件と遅順番マイナス立替者からの精算1件',
        () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 100000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 160000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 1000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentD",
            payer: testParticipant4,
            price: 200100,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentE",
            payer: testParticipant5,
            price: 10,
            owners: fiveParticipantsTrueMap)
      ];

      expect(
          Transaction(testPayments).getSettlements().hasEquivalentElements(to: [
            Settlement(
                from: testParticipant3, to: testParticipant1, amount: 7778),
            Settlement(
                from: testParticipant3, to: testParticipant2, amount: 67778),
            Settlement(
                from: testParticipant3, to: testParticipant4, amount: 15666),
            Settlement(
                from: testParticipant5, to: testParticipant4, amount: 92212),
          ]),
          equals(true));
    });

    test(
        'getSettlements_差の大きな(早<遅<中)プラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算2件と遅順番マイナス立替者からの精算2件',
        () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 100000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 210000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 1000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentD",
            payer: testParticipant4,
            price: 150100,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentE",
            payer: testParticipant5,
            price: 10,
            owners: fiveParticipantsTrueMap)
      ];

      expect(
          Transaction(testPayments).getSettlements().hasEquivalentElements(to: [
            Settlement(
                from: testParticipant3, to: testParticipant1, amount: 7778),
            Settlement(
                from: testParticipant3, to: testParticipant2, amount: 83444),
            Settlement(
                from: testParticipant5, to: testParticipant2, amount: 34334),
            Settlement(
                from: testParticipant5, to: testParticipant4, amount: 57878),
          ]),
          equals(true));
    });

    test(
        'getSettlements_差の大きな(中<早<遅)プラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算3件と遅順番マイナス立替者からの精算1件',
        () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 150000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 110000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 1000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentD",
            payer: testParticipant4,
            price: 200100,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentE",
            payer: testParticipant5,
            price: 10,
            owners: fiveParticipantsTrueMap)
      ];

      expect(
          Transaction(testPayments).getSettlements().hasEquivalentElements(to: [
            Settlement(
                from: testParticipant3, to: testParticipant1, amount: 57778),
            Settlement(
                from: testParticipant3, to: testParticipant2, amount: 17778),
            Settlement(
                from: testParticipant3, to: testParticipant4, amount: 15666),
            Settlement(
                from: testParticipant5, to: testParticipant4, amount: 92212),
          ]),
          equals(true));
    });

    test(
        'getSettlements_差の大きな(中<遅<早)プラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算1件と遅順番マイナス立替者からの精算3件',
        () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 200000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 110000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 1000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentD",
            payer: testParticipant4,
            price: 150100,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentE",
            payer: testParticipant5,
            price: 10,
            owners: fiveParticipantsTrueMap)
      ];

      expect(
          Transaction(testPayments).getSettlements().hasEquivalentElements(to: [
            Settlement(
                from: testParticipant3, to: testParticipant1, amount: 91222),
            Settlement(
                from: testParticipant5, to: testParticipant1, amount: 16556),
            Settlement(
                from: testParticipant5, to: testParticipant2, amount: 17778),
            Settlement(
                from: testParticipant5, to: testParticipant4, amount: 57878),
          ]),
          equals(true));
    });

    test(
        'getSettlements_差の大きな(遅<早<中)プラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算2件と遅順番マイナス立替者からの精算2件',
        () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 150000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 210000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 1000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentD",
            payer: testParticipant4,
            price: 100100,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentE",
            payer: testParticipant5,
            price: 10,
            owners: fiveParticipantsTrueMap)
      ];

      expect(
          Transaction(testPayments).getSettlements().hasEquivalentElements(to: [
            Settlement(
                from: testParticipant3, to: testParticipant1, amount: 57778),
            Settlement(
                from: testParticipant3, to: testParticipant2, amount: 33444),
            Settlement(
                from: testParticipant5, to: testParticipant2, amount: 84334),
            Settlement(
                from: testParticipant5, to: testParticipant4, amount: 7878),
          ]),
          equals(true));
    });

    test(
        'getSettlements_差の大きな(遅<中<早)プラス立替費者者3人と差の小さなマイナス立替費者者2人の時、早順番マイナス立替者からの精算1件と遅順番マイナス立替者からの精算3件',
        () {
      final List<Payment> testPayments = [
        Payment(
            title: "testPaymentA",
            payer: testParticipant1,
            price: 200000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentB",
            payer: testParticipant2,
            price: 160000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentC",
            payer: testParticipant3,
            price: 1000,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentD",
            payer: testParticipant4,
            price: 100100,
            owners: fiveParticipantsTrueMap),
        Payment(
            title: "testPaymentE",
            payer: testParticipant5,
            price: 10,
            owners: fiveParticipantsTrueMap)
      ];

      expect(
          Transaction(testPayments).getSettlements().hasEquivalentElements(to: [
            Settlement(
                from: testParticipant3, to: testParticipant1, amount: 91222),
            Settlement(
                from: testParticipant5, to: testParticipant1, amount: 16556),
            Settlement(
                from: testParticipant5, to: testParticipant2, amount: 67778),
            Settlement(
                from: testParticipant5, to: testParticipant4, amount: 7878),
          ]),
          equals(true));
    });
  });

  group('SettlementsComparer', () {
    test('hasEquivalentElements_支払元のインスタンスと支払先のインスタンスと支払い量が等しい組み合わせの時true', () {
      expect(
          [
            Settlement(
                from: testParticipant1, to: testParticipant3, amount: 100),
            Settlement(
                from: testParticipant1, to: testParticipant5, amount: 1000),
            Settlement(
                from: testParticipant4, to: testParticipant2, amount: 10000),
          ].hasEquivalentElements(to: [
            Settlement(
                from: testParticipant4, to: testParticipant2, amount: 10000),
            Settlement(
                from: testParticipant1, to: testParticipant5, amount: 1000),
            Settlement(
                from: testParticipant1, to: testParticipant3, amount: 100),
          ]),
          equals(true));
    });

    test('hasEquivalentElements_不足している要素がある時false', () {
      expect(
          [
            Settlement(
                from: testParticipant1, to: testParticipant3, amount: 100),
            Settlement(
                from: testParticipant1, to: testParticipant5, amount: 1000),
            Settlement(
                from: testParticipant4, to: testParticipant2, amount: 10000),
          ].hasEquivalentElements(to: [
            Settlement(
                from: testParticipant4, to: testParticipant2, amount: 10000),
            Settlement(
                from: testParticipant1, to: testParticipant5, amount: 1000),
          ]),
          equals(false));
    });

    test('hasEquivalentElements_余分な要素がある時false', () {
      expect(
          [
            Settlement(
                from: testParticipant1, to: testParticipant3, amount: 100),
            Settlement(
                from: testParticipant1, to: testParticipant5, amount: 1000),
            Settlement(
                from: testParticipant4, to: testParticipant2, amount: 10000),
          ].hasEquivalentElements(to: [
            Settlement(
                from: testParticipant4, to: testParticipant2, amount: 10000),
            Settlement(
                from: testParticipant1, to: testParticipant5, amount: 1000),
            Settlement(
                from: testParticipant1, to: testParticipant3, amount: 100),
            Settlement(
                from: testParticipant4, to: testParticipant2, amount: 100000),
          ]),
          equals(false));
    });
  });
}

extension SettlementsComparer on List<Settlement> {
  bool hasEquivalentElements({required List<Settlement> to}) {
    if (length != to.length) {
      return false;
    }
    return map((lhs) =>
        to.cast<Settlement?>().firstWhere(
              (rhs) =>
                  (lhs.from == rhs!.from) &&
                  (lhs.to == rhs.to) &&
                  (lhs.amount == rhs.amount),
              orElse: () => null,
            ) !=
        null).reduce((value, element) => value && element);
  }
}
