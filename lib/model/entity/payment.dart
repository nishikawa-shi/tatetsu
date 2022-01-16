import 'package:tatetsu/model/core/double_ext.dart';
import 'package:tatetsu/model/entity/participant.dart';

class Payment {
  String title;
  Participant payer;
  double price;
  Map<Participant, bool> owners;

  Payment({
    required this.title,
    required this.payer,
    required double price,
    required this.owners,
  }) : price = price.floorAtSecondDecimal();
}
