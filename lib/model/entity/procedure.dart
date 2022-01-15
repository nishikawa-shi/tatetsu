import 'package:tatetsu/model/entity/participant.dart';

class Procedure {
  Participant from;
  Participant to;
  double amount;

  Procedure({required this.from, required this.to, required this.amount});
}
