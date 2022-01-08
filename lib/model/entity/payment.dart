import 'package:tatetsu/model/entity/participant.dart';

class Payment {
  String title;
  Participant payer;
  double price;
  Map<Participant, bool> owners;

  Payment({
    required this.title,
    required this.payer,
    required this.price,
    required this.owners,
  });
}
