import 'package:tatetsu/model/entity/creditor.dart';
import 'package:tatetsu/model/entity/payment.dart';

class Transaction {
  Creditor creditor;
  List<Payment> payments;

  Transaction(this.payments) : creditor = Creditor(payments: payments);
}
