import 'dart:math';

import 'package:tatetsu/model/core/no_debtors_exception.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';
import 'package:tatetsu/model/entity/settlement.dart';

class Creditor {
  Map<Participant, double> entries;

  Creditor({required List<Payment> payments})
      : entries = payments.toCreditorEntries();

  Settlement? extractSettlement({
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
    final double dealValue = dealTarget.floorAtSecondDecimal();
    if (dealValue == 0) {
      return null;
    }
    entries.update(from, (value) => value += dealValue);
    entries.update(to, (value) => value -= dealValue);
    return Settlement(from: from, to: to, amount: dealValue);
  }

  List<Participant> getCreditors() => ({...entries}
        ..removeWhere((key, value) => value.isNegative || value == 0))
      .keys
      .toList();

  List<Participant> getDebtors() =>
      ({...entries}..removeWhere((key, value) => !value.isNegative))
          .keys
          .toList();
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

extension DoubleExt on double {
  double floorAtSecondDecimal() =>
      this == 0 ? 0 : (this * 100).abs().floor() / 100 * (isNegative ? -1 : 1);
}

extension CreditorEntriesExt on Map<Participant, double> {
  void apply(Payment payment) {
    _addCredit(payment);
    _addDebut(payment);
  }

  void _addCredit(Payment payment) => update(
        payment.payer,
        (value) => (value += payment.price).floorAtSecondDecimal(),
      );

  void _addDebut(Payment payment) {
    final List<Participant> debtors = payment.owners.entries
        .where((element) => element.value)
        .map((e) => e.key)
        .toList();
    if (debtors.isEmpty) {
      throw NoDebtorsException();
    }
    final fee = payment.price / debtors.length;
    for (final debtor in debtors) {
      update(debtor, (value) => (value -= fee).floorAtSecondDecimal());
    }
  }
}
