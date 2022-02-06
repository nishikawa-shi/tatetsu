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

  PaymentComponent.sample({required List<Participant> participants})
      : title = "Lunch at the nice cafe",
        payer = participants.first,
        price = 66,
        owners = Map.fromIterables(participants, participants.map((_) => true));

  Payment toPayment() =>
      Payment(title: title, payer: payer, price: price, owners: owners);
}

extension PaymentComponentsExt on List<PaymentComponent> {
  bool hasOnlySampleElement({required List<Participant> onParticipants}) {
    if (length != 1) {
      return false;
    }
    final sampleElement = PaymentComponent.sample(participants: onParticipants);
    return first.title == sampleElement.title &&
        first.payer == sampleElement.payer &&
        first.price == sampleElement.price &&
        mapEquals(first.owners, sampleElement.owners);
  }
}
