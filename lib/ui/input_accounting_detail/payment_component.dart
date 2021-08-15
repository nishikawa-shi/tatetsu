import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';

class PaymentComponent {
  bool isExpanded = false;
  Payment data;

  PaymentComponent({required List<Participant> participants})
      : data = Payment(participants: participants);
}
