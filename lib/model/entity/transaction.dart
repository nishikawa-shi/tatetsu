import 'package:collection/collection.dart';
import 'package:tatetsu/model/entity/creditor.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';
import 'package:tatetsu/model/entity/settlement.dart';

class Transaction {
  Creditor creditor;
  List<Payment> payments;

  Transaction(this.payments) : creditor = Creditor(payments: payments);

  List<Settlement> getSettlements() {
    final settlementBaseCreditor = Creditor(payments: payments);
    return creditor
        .getDebtors()
        .map(
          (debtor) => _createSettlements(
            withDebtor: debtor,
            fromCreditor: settlementBaseCreditor,
          ),
        )
        .expand((e) => e)
        .toList();
  }

  List<Settlement> _createSettlements({
    required Participant withDebtor,
    required Creditor fromCreditor,
  }) =>
      creditor
          .getCreditors()
          .map(
            (creditor) => fromCreditor.extractSettlement(
              from: withDebtor,
              to: creditor,
            ),
          )
          .whereNotNull()
          .toList();
}
