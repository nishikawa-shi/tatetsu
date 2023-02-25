import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tatetsu/l10n/built/app_localizations.dart';
import 'package:tatetsu/model/core/double_ext.dart';
import 'package:tatetsu/model/entity/creditor.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';
import 'package:tatetsu/model/entity/procedure.dart';
import 'package:tatetsu/model/entity/settlement.dart';
import 'package:tatetsu/model/entity/summary_message.dart';

class Transaction {
  List<Payment> payments;
  Creditor creditor;
  Settlement settlement;

  Transaction(this.payments)
      : creditor = payments.toCreditor(),
        settlement = payments.toCreditor().toSettlement();

  SummaryMessage toSummaryMessage({
    required BuildContext context,
    DateTime? datetime,
  }) =>
      SummaryMessage(
        title: [
          AppLocalizations.of(context)?.summaryMessageTitle ??
              "Settlements summary",
          "[ ${DateFormat.yMd(Localizations.localeOf(context).languageCode).add_Hm().format(datetime ?? DateTime.now())} ]"
        ].join(" "),
        body: [
          payments.toSummary(
            AppLocalizations.of(context)?.summaryMessagePaymentsLabel ??
                "Payments",
          ),
          creditor.toSummary(
            AppLocalizations.of(context)?.summaryMessageCreditorsLabel ??
                "Creditors",
          ),
          settlement.toSummary(
            AppLocalizations.of(context)?.summaryMessageSettlementLabel ??
                "Settlement",
          )
        ].join("\n\n"),
      );
}

extension PaymentsExt on List<Payment> {
  Creditor toCreditor() => Creditor(payments: this);

  String toSummary(String label) => [
        "[$label]",
        ...map(
          (e) => "${e.title}(${e.payer.displayName}): ${e.price}",
        ),
      ].join("\n");
}

extension CreditorExt on Creditor {
  Settlement toSettlement() {
    final procedures = _getSettlementProcedures();
    final errors = procedures.getSettlementErrors(toward: this);

    return Settlement(procedures: procedures, errors: errors);
  }

  List<Procedure> _getSettlementProcedures() {
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
            value.plusAtSecondDecimal(procedure.amount.roundAtSecondDecimal()),
      );
      settlementBaseCreditor.entries.update(
        procedure.to,
        (value) =>
            value.minusAtSecondDecimal(procedure.amount.roundAtSecondDecimal()),
      );
    }

    return Map.fromEntries(
      settlementBaseCreditor.entries.entries
          .toList()
          .map((e) => MapEntry(e.key, e.value.roundAtSecondDecimal()))
          .where((element) => element.value.abs() != 0),
    );
  }
}
