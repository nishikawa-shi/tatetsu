import 'package:flutter/foundation.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';

class PaymentComponent {
  bool isExpanded = true;

  String title = "Some Payment";
  Participant payer;
  double price = 0.0;
  Map<Participant, bool> owners;

  PaymentComponent({required List<Participant> participants})
      : payer = participants.first,
        owners = Map.fromIterables(participants, participants.map((_) => true));

  Payment toPayment() =>
      Payment(title: title, payer: payer, price: price, owners: owners);
}

extension PaymentComponentsExt on List<PaymentComponent> {
  bool hasOnlyDefaultElements({required List<Participant> onParticipants}) {
    if (length != 1) {
      return false;
    }
    final defaultElement = PaymentComponent(participants: onParticipants);
    return first.title == defaultElement.title &&
        first.payer == defaultElement.payer &&
        first.price == defaultElement.price &&
        mapEquals(first.owners, defaultElement.owners);
  }
}
