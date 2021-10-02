import 'package:flutter/material.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/ui/input_accounting_detail/payment_component.dart';
import 'package:tatetsu/ui/settle_accounts/settle_accounts_page.dart';

class InputAccountingDetailPage extends StatefulWidget {
  InputAccountingDetailPage({required this.participants})
      : payments = [
          PaymentComponent(participants: participants)..isExpanded = true
        ],
        super();

  final List<Participant> participants;
  final List<PaymentComponent> payments;

  @override
  _InputAccountingDetailPageState createState() =>
      _InputAccountingDetailPageState();
}

class _InputAccountingDetailPageState extends State<InputAccountingDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Input Accounting Detail"),
          actions: <Widget>[
            TextButton(
                style: TextButton.styleFrom(
                    primary: Theme.of(context).colorScheme.onPrimary),
                onPressed: () {
                  _toSettleAccounts();
                },
                child: const Text("Settle"))
          ],
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            if (index == 1) {
              return TextButton(
                onPressed: _insertPaymentToLast,
                child: const Icon(Icons.add_circle_sharp, size: 32),
              );
            }
            return ExpansionPanelList(
              key: UniqueKey(),
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  widget.payments[index].isExpanded = !isExpanded;
                });
              },
              children: widget.payments
                  .map<ExpansionPanel>((PaymentComponent payment) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext _, bool __) {
                    return _paymentHeader(payment);
                  },
                  body: _paymentBody(payment),
                  isExpanded: payment.isExpanded,
                );
              }).toList(),
            );
          },
          itemCount: 2, // 入力部分と追加ボタンで、合計2
        ));
  }

  void _toSettleAccounts() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return SettleAccountsPage(
          payments: widget.payments.map((e) => e.data).toList());
    }));
  }

  void _insertPaymentToLast() {
    setState(() {
      widget.payments.add(PaymentComponent(participants: widget.participants));
    });
  }

  void _deletePayment(PaymentComponent payment) {
    setState(() {
      widget.payments.remove(payment);
    });
  }

  ListTile _paymentHeader(PaymentComponent payment) {
    return ListTile(
      title: TextFormField(
        initialValue: payment.data.title,
        key: UniqueKey(),
      ),
    );
  }

  Container _paymentBody(PaymentComponent payment) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: _paymentEditBody(payment),
    );
  }

  Column _paymentEditBody(PaymentComponent payment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _payerView(payment),
        _priceView(payment),
        _ownerView(payment),
        _deleteView(payment)
      ].expand((e) => e).toList(),
    );
  }

  List<Widget> _payerView(PaymentComponent payment) {
    return [
      const Text("Payer"),
      DropdownButton<Participant>(
        value: payment.data.payer,
        onChanged: (Participant? newValue) {
          setState(() {
            if (newValue == null) {
              return;
            }
            payment.data.payer = newValue;
          });
        },
        items: payment.data.participants
            .map<DropdownMenuItem<Participant>>((Participant value) {
          return DropdownMenuItem<Participant>(
            value: value,
            child: Text(value.displayName),
          );
        }).toList(),
      ),
    ];
  }

  List<Widget> _priceView(PaymentComponent payment) {
    return [
      const SizedBox(height: 16),
      const Text("Price"),
      TextFormField(
        initialValue: payment.data.price.toString(),
        key: UniqueKey(),
      ),
    ];
  }

  List<Widget> _ownerView(PaymentComponent payment) {
    final headerComponent = [
      const SizedBox(height: 16),
      const Text("Owners"),
    ];
    final ownersComponent = payment.data.owners.entries
        .map((e) => Row(children: [
              Checkbox(
                value: e.value,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == null) {
                      return;
                    }
                    payment.data.owners[e.key] = value;
                  });
                },
              ),
              Text(e.key.displayName)
            ]))
        .toList();
    return [headerComponent, ownersComponent].expand((e) => e).toList();
  }

  List<Widget> _deleteView(PaymentComponent payment) {
    final bool isOnlyPayment = widget.payments.length <= 1;
    return [
      TextButton(
        onPressed: isOnlyPayment ? null : () => {_deletePayment(payment)},
        child: const Text("Delete this payment."),
      )
    ];
  }
}
