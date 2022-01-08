import 'package:flutter/material.dart';
import 'package:tatetsu/model/entity/payment.dart';
import 'package:tatetsu/model/entity/transaction.dart';

class SettleAccountsPage extends StatefulWidget {
  const SettleAccountsPage({required this.payments}) : super();

  final List<Payment> payments;

  @override
  _SettleAccountsPageState createState() => _SettleAccountsPageState();
}

class _SettleAccountsPageState extends State<SettleAccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settle Accounts Result"),
        ),
        body: Text(Transaction(widget.payments)
            .creditor
            .entries
            .entries
            .map((e) => "\nperson: ${e.key.displayName}, credit: ${e.value}\n")
            .join()));
  }
}
