import 'package:flutter/material.dart';
import 'package:tatetsu/ui/input_accounting_detail/payment_component.dart';

class ExcludeParticipantsDialog extends StatefulWidget {
  final PaymentComponent payment;

  const ExcludeParticipantsDialog({required this.payment}) : super();

  @override
  State<StatefulWidget> createState() => _ExcludeParticipantsDialogState();
}

class _ExcludeParticipantsDialogState extends State<ExcludeParticipantsDialog> {
  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text("Exclude Participants"),
        content: SingleChildScrollView(
          child: _checkBoxComponent(),
        ),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      );

  Column _checkBoxComponent() => Column(
        children: widget.payment.owners.entries
            .map(
              (e) => Row(
                children: [
                  Checkbox(
                    value: e.value,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == null) {
                          return;
                        }
                        widget.payment.owners[e.key] = value;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      e.key.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            )
            .toList(),
      );
}
