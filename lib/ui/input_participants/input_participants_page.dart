import 'package:flutter/material.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/usecase/participants_usecase.dart';
import 'package:tatetsu/ui/input_accounting_detail/input_accounting_detail_page.dart';

class InputParticipantsPage extends StatefulWidget {
  const InputParticipantsPage({required this.title}) : super();

  final String title;

  @override
  _InputParticipantsPageState createState() => _InputParticipantsPageState();
}

class _InputParticipantsPageState extends State<InputParticipantsPage> {
  final List<Participant> _participants = ParticipantsUsecase.getDefaults();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _createHeader();
              }
              if (index > _participants.length) {
                return _createFooter();
              }
              final participantIndex = index - 1;
              return _createParticipantInputArea(participantIndex);
            },
            itemCount: _participants.length + 2),
      ),
    );
  }

  void _insertParticipantToLast() {
    setState(() {
      _participants.add(ParticipantsUsecase.createDummy());
    });
  }

  void _removeParticipant(int participantIndex) {
    setState(() {
      _participants.removeAt(participantIndex);
    });
  }

  Row _createHeader() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Text(
                  "Enter participants names.",
                  textAlign: TextAlign.left,
                )),
          ),
          TextButton(
            onPressed: _insertParticipantToLast,
            child: const Icon(Icons.add_circle_sharp, size: 32),
          ),
        ],
      );

  Container _createFooter() => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: TextButton(
          onPressed: _toInputAccounting,
          child: const Text("Start accounting detail input."),
        ),
      );

  void _toInputAccounting() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return InputAccountingDetailPage(participants: _participants);
    }));
  }

  Row _createParticipantInputArea(int participantIndex) {
    final bool hasOnlyParticipants = _participants.length <= 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: TextFormField(
            initialValue: _participants[participantIndex].displayName,
            key: UniqueKey(),
          ),
        ),
        TextButton(
          onPressed: hasOnlyParticipants
              ? null
              : () => {_removeParticipant(participantIndex)},
          child: const Icon(
            Icons.remove,
            size: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
