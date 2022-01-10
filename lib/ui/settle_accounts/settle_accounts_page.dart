import 'package:flutter/material.dart';
import 'package:tatetsu/model/entity/creditor.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';
import 'package:tatetsu/model/entity/settlement.dart';
import 'package:tatetsu/model/entity/transaction.dart';

class SettleAccountsPage extends StatefulWidget {
  SettleAccountsPage({required this.payments})
      : transaction = Transaction(payments),
        super();

  final List<Payment> payments;
  final Transaction transaction;

  @override
  _SettleAccountsPageState createState() => _SettleAccountsPageState();
}

class _SettleAccountsPageState extends State<SettleAccountsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Credit Summaries"),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return ExpansionPanelList(
              key: UniqueKey(),
              expansionCallback: (int index, bool isExpanded) {
                setState(() {});
              },
              children: [
                ExpansionPanel(
                  headerBuilder: (_, __) =>
                      const ListTile(title: Text("Settlement")),
                  body: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: widget.transaction
                        .getSettlements()
                        .map((e) => _settlementComponent(e))
                        .toList(),
                  ),
                  isExpanded: true,
                ),
                ExpansionPanel(
                  headerBuilder: (_, __) =>
                      const ListTile(title: Text("Creditors")),
                  body: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: widget.transaction.creditor.entries.entries
                        .toList()
                        .map((e) => _creditorComponent(e))
                        .toList(),
                  ),
                  isExpanded: true,
                ),
                ExpansionPanel(
                  headerBuilder: (_, __) =>
                      const ListTile(title: Text("Payments")),
                  body: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: widget.transaction.payments
                        .map((e) => _paymentComponent(e))
                        .toList(),
                  ),
                  isExpanded: true,
                ),
              ],
            );
          },
          itemCount: 1,
        ),
      );

  Column _settlementComponent(Settlement settlement) => Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 48),
              Expanded(
                flex: 2,
                child: Text(
                  settlement.from.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Expanded(
                child: Icon(Icons.arrow_right),
              ),
              Expanded(
                flex: 2,
                child: Text(settlement.to.displayName),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  settlement.amount.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(width: 64),
            ],
          ),
          const SizedBox(height: 8),
        ],
      );

  Column _creditorComponent(MapEntry<Participant, double> creditorEntry) =>
      Column(
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 48),
              Expanded(
                flex: 5,
                child: Text(
                  creditorEntry.key.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  creditorEntry.value.floorAtSecondDecimal().toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(width: 64),
            ],
          ),
          const SizedBox(height: 8),
        ],
      );

  Column _paymentComponent(Payment payment) => Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 48),
              Expanded(
                flex: 3,
                child: Text(
                  payment.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  payment.payer.displayName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  payment.price.floorAtSecondDecimal().toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(width: 64),
            ],
          ),
          const SizedBox(height: 8),
        ],
      );
}
