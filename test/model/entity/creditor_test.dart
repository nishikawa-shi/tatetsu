import 'package:tatetsu/model/entity/creditor.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';
import 'package:test/test.dart';

void main() {
  group('Creditor', () {
    test('PaymentsExt_toCreditorEntries_Paymentが空の時、エラー', () {
      final List<Payment> testPayments = [];

      expect(() => testPayments.toCreditorEntries(), throwsStateError);
    });

    test('PaymentsExt_toCreditorEntries_Paymentが1つの時立替額の合計値が0', () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final Participant testParticipant3 = Participant("testName3");
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
          testPayments
              .toCreditorEntries()
              .values
              .reduce((current, next) => current + next),
          equals(0.0));
    });

    test('PaymentsExt_toCreditorEntries_Paymentが1つの時立替額が均等割される', () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final Participant testParticipant3 = Participant("testName3");
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
          testPayments.toCreditorEntries(),
          equals({
            testParticipant1: 4000.0,
            testParticipant2: -2000.0,
            testParticipant3: -2000.0
          }));
    });

    test('PaymentsExt_toCreditorEntries_Paymentが2つの時立替額の合計値が0', () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final Participant testParticipant3 = Participant("testName3");
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
          testPayments
              .toCreditorEntries()
              .values
              .reduce((current, next) => current + next),
          equals(0.0));
    });

    test('PaymentsExt_toCreditorEntries_Paymentが2つの時立替額が2会計の合算', () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final Participant testParticipant3 = Participant("testName3");
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
          Creditor(payments: testPayments).entries,
          equals({
            testParticipant1: 4000.0,
            testParticipant2: -1550.0,
            testParticipant3: -2450.0
          }));
    });

    test('PaymentsExt_toCreditorEntries_Paymentが3つの時立替額の合計値が0', () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final Participant testParticipant3 = Participant("testName3");
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
              testParticipant1: true,
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
          testPayments
              .toCreditorEntries()
              .values
              .reduce((current, next) => current + next),
          equals(0.0));
    });

    test('PaymentsExt_toCreditorEntries_Paymentが3つの時立替額が3会計の合算', () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final Participant testParticipant3 = Participant("testName3");
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
          testPayments.toCreditorEntries(),
          equals({
            testParticipant1: -6000.0,
            testParticipant2: -11550.0,
            testParticipant3: 17550.0
          }));
    });

    test('PaymentsExt_toCreditorEntries_Paymentに割り切れない値がある時、小数点まで含んだ合算値', () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final Participant testParticipant3 = Participant("testName3");
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
          testPayments.toCreditorEntries(),
          equals({
            testParticipant1: -9333.333333333334,
            testParticipant2: -14883.333333333334,
            testParticipant3: 24216.666666666664
          }));
    });

    test('CreditorEntriesExt_apply_参加者1人支払者1人のPaymentを与えた時、0円の立替', () {
      final Participant testParticipant1 = Participant("testName1");
      final creditorEntries = {testParticipant1: 0.0};
      final testPayment = Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {testParticipant1: true});

      expect(
          creditorEntries..apply(testPayment), equals({testParticipant1: 0.0}));
    });

    test('CreditorEntriesExt_apply_参加者1人支払者0人のPaymentを与えた時、例外', () {
      final Participant testParticipant1 = Participant("testName1");
      final creditorEntries = {testParticipant1: 0.0};
      final testPayment = Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {testParticipant1: false});

      expect(() => creditorEntries..apply(testPayment), throwsException);
    });

    test('CreditorEntriesExt_apply_参加者2人支払者2人のPaymentを与えた時、半額移動の立替', () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final creditorEntries = {testParticipant1: 0.0, testParticipant2: 0.0};
      final testPayment = Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {testParticipant1: true, testParticipant2: true});

      expect(creditorEntries..apply(testPayment),
          equals({testParticipant1: 3000.0, testParticipant2: -3000.0}));
    });

    test(
        'CreditorEntriesExt_apply_参加者2人支払者2人のPaymentを、予め値を持つ立替に与えた時、半額移動の立替が追加',
        () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final creditorEntries = {
        testParticipant1: -500.0,
        testParticipant2: 500.0
      };
      final testPayment = Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {testParticipant1: true, testParticipant2: true});

      expect(creditorEntries..apply(testPayment),
          equals({testParticipant1: 2500.0, testParticipant2: -2500.0}));
    });

    test('CreditorEntriesExt_apply_参加者2人支払者1人(立替者)のPaymentを与えた時、0円の立替', () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final creditorEntries = {testParticipant1: 0.0, testParticipant2: 0.0};
      final testPayment = Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {testParticipant1: true, testParticipant2: false});

      expect(creditorEntries..apply(testPayment),
          equals({testParticipant1: 0.0, testParticipant2: 0.0}));
    });

    test('CreditorEntriesExt_apply_参加者2人支払者1人(非立替者)のPaymentを与えた時、全額移動の立替', () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final creditorEntries = {testParticipant1: 0.0, testParticipant2: 0.0};
      final testPayment = Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {testParticipant1: false, testParticipant2: true});

      expect(creditorEntries..apply(testPayment),
          equals({testParticipant1: 6000.0, testParticipant2: -6000.0}));
    });

    test('CreditorEntriesExt_apply_参加者2人支払者0人のPaymentを与えた時、例外', () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final creditorEntries = {testParticipant1: 0.0, testParticipant2: 0.0};
      final testPayment = Payment(
          title: "testPaymentA",
          payer: testParticipant1,
          price: 6000,
          owners: {testParticipant1: false, testParticipant2: false});

      expect(() => creditorEntries..apply(testPayment), throwsException);
    });

    test('CreditorEntriesExt_apply_参加者3人支払者3人のPaymentを与えた時、1/3額移動の立替', () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final Participant testParticipant3 = Participant("testName3");
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
          });

      expect(
          creditorEntries..apply(testPayment),
          equals({
            testParticipant1: 4000.0,
            testParticipant2: -2000.0,
            testParticipant3: -2000.0
          }));
    });

    test(
        'CreditorEntriesExt_apply_参加者3人支払者3人のPaymentを、予め値を持つ立替に与えた時、1/3額移動の立替が追加',
        () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final Participant testParticipant3 = Participant("testName3");
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
          });

      expect(
          creditorEntries..apply(testPayment),
          equals({
            testParticipant1: 3800.0,
            testParticipant2: -2200.0,
            testParticipant3: -1600.0
          }));
    });

    test('CreditorEntriesExt_apply_参加者3人支払者2人(立替者含む)のPaymentを与えた時、半額移動の立替', () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final Participant testParticipant3 = Participant("testName3");
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
          });

      expect(
          creditorEntries..apply(testPayment),
          equals({
            testParticipant1: 3000.0,
            testParticipant2: -3000.0,
            testParticipant3: 0.0
          }));
    });

    test('CreditorEntriesExt_apply_参加者3人支払者2人(立替者含まず)のPaymentを与えた時、合計全額移動の立替',
        () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final Participant testParticipant3 = Participant("testName3");
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
          });

      expect(
          creditorEntries..apply(testPayment),
          equals({
            testParticipant1: 6000.0,
            testParticipant2: -3000.0,
            testParticipant3: -3000.0
          }));
    });

    test('CreditorEntriesExt_apply_参加者3人支払者1人(立替者)のPaymentを与えた時、0円の立替', () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final Participant testParticipant3 = Participant("testName3");
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
          });

      expect(
          creditorEntries..apply(testPayment),
          equals({
            testParticipant1: 0.0,
            testParticipant2: 0.0,
            testParticipant3: 0.0
          }));
    });

    test('CreditorEntriesExt_apply_参加者3人支払者1人(非立替者)のPaymentを与えた時、全額移動の立替', () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final Participant testParticipant3 = Participant("testName3");
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
          });

      expect(
          creditorEntries..apply(testPayment),
          equals({
            testParticipant1: 6000.0,
            testParticipant2: -6000.0,
            testParticipant3: 0.0
          }));
    });

    test('CreditorEntriesExt_apply_参加者3人支払者0人のPaymentを与えた時、例外', () {
      final Participant testParticipant1 = Participant("testName1");
      final Participant testParticipant2 = Participant("testName2");
      final Participant testParticipant3 = Participant("testName3");
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
          });

      expect(() => creditorEntries..apply(testPayment), throwsException);
    });
  });
}
