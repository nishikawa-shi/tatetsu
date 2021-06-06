import 'package:flutter/material.dart';
import 'package:tatetsu/model/entity/participant.dart';

class InputAccountingDetailPage extends StatefulWidget {
  const InputAccountingDetailPage({required this.participants}) : super();

  final List<Participant> participants;

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
        body: Text(widget.participants.map((e) => e.displayName).toString()));
  }
}
