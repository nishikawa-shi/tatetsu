import 'package:tatetsu/model/entity/participant.dart';

class Settlement {
  Participant from;
  Participant to;
  double amount;

  Settlement({required this.from, required this.to, required this.amount});
}
