import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tatetsu/l10n/built/app_localizations.dart';
import 'package:tatetsu/model/core/double_ext.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';

class PaymentComponent {
  bool isExpanded = true;

  final String defaultTitle;
  final double defaultPrice;
  Participant payer;
  Map<Participant, bool> owners;

  final TextEditingController titleController;
  final TextEditingController priceController;

  PaymentComponent({
    required List<Participant> participants,
    required BuildContext context,
  })  : defaultTitle =
            AppLocalizations.of(context)?.sampleMeaninglessPaymentTitle ??
                "Some payment",
        defaultPrice = 0.0,
        payer = participants.first,
        owners = Map.fromIterables(participants, participants.map((_) => true)),
        titleController = TextEditingController(),
        priceController = TextEditingController();

  PaymentComponent.of({
    required String title,
    required this.payer,
    required double price,
    required this.owners,
  })  : defaultTitle = title,
        defaultPrice = price,
        titleController = TextEditingController(text: title),
        priceController = TextEditingController(text: price.toString());

  PaymentComponent.sample({
    required List<Participant> participants,
    required BuildContext context,
  })  : defaultTitle = AppLocalizations.of(context)?.samplePaymentTitle ??
            "Lunch at the nice cafe",
        defaultPrice = double.parse(
          AppLocalizations.of(context)?.samplePaymentPrice ?? "66",
        ),
        payer = participants.first,
        owners = Map.fromIterables(participants, participants.map((_) => true)),
        titleController = TextEditingController(),
        priceController = TextEditingController();

  String get title =>
      titleController.text.isNotEmpty ? titleController.text : defaultTitle;

  double get price => priceController.text.isNotEmpty
      ? (double.tryParse(priceController.text) ?? 0).roundAtSecondDecimal()
      : defaultPrice;

  Payment toPayment() =>
      Payment(title: title, payer: payer, price: price, owners: owners);

  void dispose() {
    titleController.dispose();
    priceController.dispose();
  }
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
