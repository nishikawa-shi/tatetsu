import 'package:flutter/material.dart';
import 'package:tatetsu/model/entity/payment.dart';

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
        body: Text(widget.payments.map((e) => e.title).toString()));
  }
}
