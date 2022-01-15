import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/procedure.dart';

class Settlement {
  List<Procedure> procedures;
  Map<Participant, double> errors;

  Settlement({required this.procedures, required this.errors});
}
