import 'dart:math';

import 'package:tatetsu/model/core/double_ext.dart';
import 'package:tatetsu/model/core/no_debtors_exception.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';
import 'package:tatetsu/model/entity/procedure.dart';

class Creditor {
  Map<Participant, double> entries;
  List<Payment> payments;

  Creditor({required this.payments}) : entries = payments.toCreditorEntries();

  Procedure? extractSettlement({
    required Participant from,
    required Participant to,
  }) {
    final double? debt = entries[from];
    final double? credit = entries[to];
    if (debt == null || credit == null) {
      return null;
    }

    // 立替額がプラスなのに精算元として指定されたり、マイナスなのに精算先として指定された場合を弾きたい
    if (debt >= 0 || credit <= 0) {
      return null;
    }

    // 絶対値の大きなものが基準とされてしまい、払い過ぎや貰い過ぎが発生してややこしくなってしまうのを防ぎたい
    final double dealTarget = min(debt.abs(), credit.abs());

    // 精算額はドルにおけるセントまでと考え、0.01を下限とする。誤差は別途表示する
    final double dealValue = dealTarget.roundAtSecondDecimal();
    if (dealValue == 0) {
      return null;
    }
    entries.update(from, (value) => value += dealValue);
    entries.update(to, (value) => value -= dealValue);
    return Procedure(from: from, to: to, amount: dealValue);
  }

  List<Participant> getCreditors() => ({...entries}
        ..removeWhere((key, value) => value.isNegative || value == 0))
      .keys
      .toList();

  List<Participant> getDebtors() =>
      ({...entries}..removeWhere((key, value) => !value.isNegative))
          .keys
          .toList();

  double getError() => entries.values
      .reduce((value, element) => value.plusAtSecondDecimal(element));

  bool hasError() => getError() != 0;

  String toSummary(String label) => [
        "[$label]",
        ...entries.entries.map((e) => "${e.key.displayName}: ${e.value}")
      ].join("\n");
}

extension PaymentsExt on List<Payment> {
  Map<Participant, double> toCreditorEntries() {
    final Map<Participant, double> creditorEntries = Map.fromIterables(
      first.owners.keys,
      List.generate(first.owners.length, (_) => 0),
    );
    forEach((payment) => creditorEntries.apply(payment));
    return creditorEntries;
  }
}

extension CreditorEntriesExt on Map<Participant, double> {
  void apply(Payment payment) {
    _addCredit(payment);
    _addDebt(payment);
  }

  void _addCredit(Payment payment) => update(
        payment.payer,
        (value) =>
            (value.plusAtSecondDecimal(payment.price)).roundAtSecondDecimal(),
      );

  void _addDebt(Payment payment) {
    final List<Participant> debtors = payment.owners.entries
        .where((element) => element.value)
        .map((e) => e.key)
        .toList();
    if (debtors.isEmpty) {
      throw NoDebtorsException();
    }
    final fee = payment.price / debtors.length;
    for (final debtor in debtors) {
      update(debtor, (value) => (value - fee).roundAtSecondDecimal());
    }
  }
}
