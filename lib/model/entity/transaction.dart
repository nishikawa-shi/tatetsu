import 'package:collection/collection.dart';
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
    //TODO: 作り込み
    return {};
  }
}
