import 'package:flutter/material.dart';
import 'package:tatetsu/model/entity/Participant.dart';
import 'package:tatetsu/model/usecase/ParticipantsUsecase.dart';

class InputParticipantsPage extends StatefulWidget {
  InputParticipantsPage({required this.title}) : super();

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
            padding: EdgeInsets.all(16),
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

  Container _createHeader() => Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text("Enter participants names."));

  Container _createFooter() => Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: TextButton(
        child: const Icon(Icons.add_circle_sharp, size: 40),
        onPressed: _insertParticipantToLast,
      ));

  Row _createParticipantInputArea(int participantIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
            child: TextFormField(
                initialValue: _participants[participantIndex].displayName)),
        IconButton(
          icon: Icon(Icons.remove, size: 16),
          onPressed: () {
            _removeParticipant(participantIndex);
          },
        )
      ],
    );
  }
}
