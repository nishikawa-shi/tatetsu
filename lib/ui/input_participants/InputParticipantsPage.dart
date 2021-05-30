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

  Row _createHeader() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Enter participants names.",
                  textAlign: TextAlign.left,
                )),
          ),
          TextButton(
            child: Icon(Icons.add_circle_sharp, size: 32),
            onPressed: _insertParticipantToLast,
          ),
        ],
      );

  Container _createFooter() => Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: TextButton(
        child: const Text("Start accounting detail input."),
        onPressed: () {},
      ));

  Row _createParticipantInputArea(int participantIndex) {
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
          child: Icon(
            Icons.remove,
            size: 16,
            color: Colors.grey,
          ),
          onPressed: () {
            _removeParticipant(participantIndex);
          },
        ),
      ],
    );
  }
}
