import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tatetsu/l10n/built/app_localizations.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';

class PaymentComponent {
  bool isExpanded = true;

  String title;
  Participant payer;
  double price = 0.0;
  Map<Participant, bool> owners;

  bool hasUserSpecifiedTitle = false;
  bool hasUserSpecifiedPrice = false;

  PaymentComponent({
    required List<Participant> participants,
    required BuildContext context,
  })  : title = AppLocalizations.of(context)?.sampleMeaninglessPaymentTitle ??
            "Some payment",
        payer = participants.first,
        owners = Map.fromIterables(participants, participants.map((_) => true));

  PaymentComponent.of({
    required this.title,
    required this.payer,
    required this.price,
    required this.owners,
  });

  PaymentComponent.sample({
    required List<Participant> participants,
    required BuildContext context,
  })  : title = AppLocalizations.of(context)?.samplePaymentTitle ??
            "Lunch at the nice cafe",
        payer = participants.first,
        price = double.parse(
          AppLocalizations.of(context)?.samplePaymentPrice ?? "66",
        ),
        owners = Map.fromIterables(participants, participants.map((_) => true));

  Payment toPayment() =>
      Payment(title: title, payer: payer, price: price, owners: owners);
}

extension PaymentComponentsExt on List<PaymentComponent> {
  bool hasOnlySampleElement({
    required List<Participant> onParticipants,
    required BuildContext context,
  }) {
    if (length != 1) {
      return false;
    }
    final sampleElement =
        PaymentComponent.sample(participants: onParticipants, context: context);
    return first.title == sampleElement.title &&
        first.payer == sampleElement.payer &&
        first.price == sampleElement.price &&
        mapEquals(first.owners, sampleElement.owners);
  }
}
