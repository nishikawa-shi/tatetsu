import 'package:tatetsu/model/entity/creditor.dart';
import 'package:tatetsu/model/entity/payment.dart';

class Transaction {
  Creditor creditor;

  Transaction({required List<Payment> payments})
      : creditor = Creditor(payments: payments);
}
