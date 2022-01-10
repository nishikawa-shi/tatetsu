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
  final List<Participant> _participants = ParticipantsUsecase().getDefaults();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                _toInputAccounting();
              },
              child: const Icon(Icons.payment, size: 32),
            )
          ],
        ),
        body: Center(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemBuilder: (BuildContext context, int index) {
              if (index >= _participants.length) {
                return _createFooter();
              }
              return _createParticipantInputArea(index);
            },
            // 要素の数は、参加者の数 + ヘッダー1つ
            itemCount: _participants.length + 1,
          ),
        ),
      ),
    );
  }

  void _insertParticipantToLast() {
    setState(() {
      _participants.add(ParticipantsUsecase().createDummy());
    });
  }

  void _removeParticipant(int participantIndex) {
    setState(() {
      _participants.removeAt(participantIndex);
    });
  }

  Widget _createFooter() => Center(
        child: Wrap(
          children: [
            TextButton(
              onPressed: _insertParticipantToLast,
              child: const Icon(Icons.add_circle, size: 32),
            )
          ],
        ),
      );

  void _toInputAccounting() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return InputAccountingDetailPage(participants: _participants);
        },
      ),
    );
  }

  Row _createParticipantInputArea(int participantIndex) {
    final bool hasOnlyParticipants = _participants.length <= 1;
    final String participantNameHint =
        _participants[participantIndex].displayName;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(hintText: participantNameHint),
            key: UniqueKey(),
            onChanged: (String value) {
              // テキストエリアに表示されている値を引き継ぎたい
              _participants[participantIndex].displayName =
                  value.isNotEmpty ? value : participantNameHint;
            },
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
