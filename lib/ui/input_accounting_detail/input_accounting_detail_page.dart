import 'package:flutter/material.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/ui/input_accounting_detail/payment_component.dart';

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
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return ExpansionPanelList(
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
          itemCount: 1,
        ));
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
      children: [_payerView(payment)].expand((e) => e).toList(),
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
}
