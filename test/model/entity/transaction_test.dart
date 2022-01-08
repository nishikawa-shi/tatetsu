import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';
import 'package:tatetsu/model/entity/transaction.dart';
import 'package:test/test.dart';

void main() {
  final Participant testParticipant1 = Participant("testName1");
  final Participant testParticipant2 = Participant("testName2");
  final Participant testParticipant3 = Participant("testName3");

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
  });
}
