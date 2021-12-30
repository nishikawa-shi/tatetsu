import 'package:tatetsu/model/core/no_debtors_exception.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';

class Creditor {
  Map<Participant, double> entries;

  Creditor({required List<Payment> payments})
      : entries = payments.toCreditorEntries();
}

extension PaymentsExt on List<Payment> {
  Map<Participant, double> toCreditorEntries() {
    final Map<Participant, double> creditorEntries = Map.fromIterables(
        first.owners.keys, List.generate(first.owners.length, (_) => 0));
    forEach((payment) => creditorEntries.apply(payment));
    return creditorEntries;
  }
}

extension CreditorEntriesExt on Map<Participant, double> {
  void apply(Payment payment) {
    _addCredit(payment);
    _addDebut(payment);
  }

  void _addCredit(Payment payment) =>
      update(payment.payer, (value) => value += payment.price);

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
      update(debtor, (value) => value -= fee);
    }
  }
}
