import 'package:flutter/material.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/ui/input_accounting_detail/exclude_participants_dialog.dart';
import 'package:tatetsu/ui/input_accounting_detail/payment_component.dart';
import 'package:tatetsu/ui/settle_accounts/settle_accounts_page.dart';

class InputAccountingDetailPage extends StatefulWidget {
  InputAccountingDetailPage({required this.participants})
      : payments = [PaymentComponent(participants: participants)],
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: _showDiscardConfirmDialogIfNeeded,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Payments"),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  _toSettleAccounts();
                },
                child: const Icon(Icons.summarize, size: 32),
              )
            ],
          ),
          body: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              if (index == 1) {
                return Center(
                  child: Wrap(
                    children: [
                      TextButton(
                        onPressed: _insertPaymentToLast,
                        child: const Icon(Icons.add_circle, size: 32),
                      )
                    ],
                  ),
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
          ),
        ),
      ),
    );
  }

  Future<bool> _showDiscardConfirmDialogIfNeeded() => widget.payments
          .hasOnlyDefaultElements(onParticipants: widget.participants)
      ? Future(() => true)
      : showDialog<bool>(
          context: context,
          builder: (context) => _discardConfirmDialog(),
        ).then((value) => value ?? false);

  AlertDialog _discardConfirmDialog() => AlertDialog(
        content: const Text("Are you sure to discard the input payments?"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Theme.of(context).disabledColor,
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Discard"),
          )
        ],
      );

  void _toSettleAccounts() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return SettleAccountsPage(
            payments: widget.payments.map((e) => e.toPayment()).toList(),
          );
        },
      ),
    );
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
    final String paymentTitleHint = payment.title;
    return ListTile(
      title: TextFormField(
        decoration: InputDecoration(hintText: paymentTitleHint),
        key: UniqueKey(),
        onChanged: (String value) {
          payment.title = value.isNotEmpty ? value : paymentTitleHint;
        },
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
        _actionsView(payment),
      ].expand((e) => e).toList(),
    );
  }

  List<Widget> _payerView(PaymentComponent payment) {
    return [
      const Text("Payer"),
      DropdownButton<Participant>(
        value: payment.payer,
        onChanged: (Participant? newValue) {
          setState(() {
            if (newValue == null) {
              return;
            }
            payment.payer = newValue;
          });
        },
        items: payment.owners.keys
            .map<DropdownMenuItem<Participant>>((Participant value) {
          return DropdownMenuItem<Participant>(
            value: value,
            child: Text(value.displayName),
          );
        }).toList(),
        isExpanded: true,
      ),
    ];
  }

  List<Widget> _priceView(PaymentComponent payment) {
    final double paymentPriceHintValue = payment.price;
    return [
      const SizedBox(height: 16),
      const Text("Price"),
      TextFormField(
        decoration: InputDecoration(hintText: paymentPriceHintValue.toString()),
        key: UniqueKey(),
        onChanged: (String value) {
          payment.price =
              value.isNotEmpty ? double.parse(value) : paymentPriceHintValue;
        },
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    ];
  }

  List<Widget> _actionsView(PaymentComponent payment) {
    final bool isOnlyPayment = widget.payments.length <= 1;
    return [
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => ExcludeParticipantsDialog(payment: payment),
              );
            },
            child: const Icon(Icons.person_off, size: 32),
          ),
          TextButton(
            onPressed: isOnlyPayment
                ? null
                : () => showDialog(
                      context: context,
                      builder: (context) =>
                          _paymentDeleteConfirmDialog(payment),
                    ),
            child: const Icon(Icons.delete_forever, size: 32),
          ),
        ],
      )
    ];
  }

  AlertDialog _paymentDeleteConfirmDialog(PaymentComponent payment) =>
      AlertDialog(
        content: Text('Are you sure to delete payment \n"${payment.title}"?'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Theme.of(context).disabledColor,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _deletePayment(payment);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          )
        ],
      );
}
