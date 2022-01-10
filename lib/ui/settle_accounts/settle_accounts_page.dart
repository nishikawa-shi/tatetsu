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
    final Transaction transaction = Transaction(widget.payments);
    final String creditorsText = transaction.creditor.entries.entries
        .map((e) => "\nperson: ${e.key.displayName}, credit: ${e.value}\n")
        .join();
    final String dealsText = transaction
        .getSettlements()
        .map(
          (e) =>
              "\nfrom: ${e.from.displayName}, to: ${e.to.displayName}, price: ${e.amount}\n",
        )
        .join();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Credit Summaries"),
      ),
      body: Text([creditorsText, "\n\n", dealsText].join()),
    );
  }
}
