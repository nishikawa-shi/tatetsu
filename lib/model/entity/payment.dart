import 'package:tatetsu/model/entity/participant.dart';

class Payment {
  String title = "Some Payment";
  Participant payer;
  double price = 0.0;
  List<Participant> participants;
  Map<Participant, bool> owners = {};

  Payment({required this.participants})
      : payer = participants.first,
        owners = Map.fromIterables(participants, participants.map((_) => true));
}
