import 'package:collection/collection.dart';
import 'package:tatetsu/model/core/double_ext.dart';
import 'package:tatetsu/model/entity/creditor.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';
import 'package:tatetsu/model/entity/procedure.dart';
import 'package:tatetsu/model/entity/settlement.dart';

class Transaction {
  Creditor creditor;
  List<Payment> payments;

  Transaction(this.payments) : creditor = Creditor(payments: payments);

  Settlement getSettlement() {
    final procedures = creditor.getSettlementProcedures();
    final errors = procedures.getSettlementErrors(toward: creditor);

    return Settlement(procedures: procedures, errors: errors);
  }
}

extension CreditorExt on Creditor {
  List<Procedure> getSettlementProcedures() {
    final settlementBaseCreditor = Creditor(payments: payments);
    return getDebtors()
        .map(
          (debtor) => _createSettlements(
            withDebtor: debtor,
            fromCreditor: settlementBaseCreditor,
          ),
        )
        .expand((e) => e)
        .toList();
  }

  List<Procedure> _createSettlements({
    required Participant withDebtor,
    required Creditor fromCreditor,
  }) =>
      getCreditors()
          .map(
            (creditor) => fromCreditor.extractSettlement(
              from: withDebtor,
              to: creditor,
            ),
          )
          .whereNotNull()
          .toList();
}

extension ProceduresExt on List<Procedure> {
  Map<Participant, double> getSettlementErrors({required Creditor toward}) {
    final settlementBaseCreditor = Creditor(payments: toward.payments);
    for (final procedure in this) {
      settlementBaseCreditor.entries.update(
        procedure.from,
        (value) =>
            value.plusAtSecondDecimal(procedure.amount.floorAtSecondDecimal()),
      );
      settlementBaseCreditor.entries.update(
        procedure.to,
        (value) =>
            value.minusAtSecondDecimal(procedure.amount.floorAtSecondDecimal()),
      );
    }

    return Map.fromEntries(
      settlementBaseCreditor.entries.entries
          .toList()
          .map((e) => MapEntry(e.key, e.value.floorAtSecondDecimal()))
          .where((element) => element.value.abs() != 0),
    );
  }
}
