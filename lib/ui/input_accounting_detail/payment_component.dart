import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';

class PaymentComponent {
  bool isInputBodyExpanded = false;
  bool isOwnerChoiceBodyExpanded = false;

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
