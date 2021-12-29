import 'package:tatetsu/model/entity/participant.dart';

class Payment {
  String title = "Some Payment";
  Participant payer;
  double price = 0.0;
  Map<Participant, bool> owners = {};

  Payment({required List<Participant> participants})
      : payer = participants.first,
        owners = Map.fromIterables(participants, participants.map((_) => true));
}
