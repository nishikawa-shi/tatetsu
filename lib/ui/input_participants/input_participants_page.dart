import 'package:flutter/material.dart';
import 'package:tatetsu/l10n/built/app_localizations.dart';
import 'package:tatetsu/model/core/build_context_ext.dart';
import 'package:tatetsu/model/transport/account_detail_dto.dart';
import 'package:tatetsu/model/usecase/participants_usecase.dart';
import 'package:tatetsu/ui/core/string_ext.dart';
import 'package:tatetsu/ui/input_participants/participant_component.dart';

class InputParticipantsPage extends StatefulWidget {
  const InputParticipantsPage({required this.titlePrefix}) : super();

  final String titlePrefix;

  @override
  _InputParticipantsPageState createState() => _InputParticipantsPageState();
}

class _InputParticipantsPageState extends State<InputParticipantsPage> {
  final List<ParticipantComponent> _participants = [];

  @override
  void dispose() {
    for (final participant in _participants) {
      participant.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_participants.isEmpty) {
      _participants.addAll(
        ParticipantsUsecase.shared()
            .getDefaults(context)
            .map(ParticipantComponent.new),
      );
    }
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            [
              widget.titlePrefix,
              AppLocalizations.of(context)?.participants ?? "Participants",
            ].join(" "),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                _toInputAccounting();
              },
              child: Icon(
                Icons.receipt_long,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
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
      _participants.add(
        ParticipantComponent(ParticipantsUsecase.shared().createDummy(context)),
      );
    });
  }

  void _removeParticipant(int participantIndex) {
    final removedParticipant = _participants[participantIndex];
    setState(() {
      _participants.removeAt(participantIndex);
    });
    WidgetsBinding.instance
        .addPostFrameCallback((_) => removedParticipant.dispose());
  }

  Widget _createFooter() => Center(
        child: Wrap(
          children: [
            TextButton(
              onPressed: _insertParticipantToLast,
              child: const Icon(Icons.person_add, size: 32),
            ),
          ],
        ),
      );

  void _toInputAccounting() {
    context.goTo(
      path: "/app/accounting_detail",
      params: AccountDetailDto(
        pNm: _participants.map((e) => e.displayName).toList(),
        ps: [],
      ),
    );
  }

  Row _createParticipantInputArea(int participantIndex) {
    final bool hasOnlyParticipants = _participants.length <= 1;
    final participant = _participants[participantIndex];
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: participant.defaultDisplayName.toHintText(context),
            ),
            controller: participant.displayNameController,
          ),
        ),
        TextButton(
          onPressed: hasOnlyParticipants
              ? null
              : () => {_removeParticipant(participantIndex)},
          child: Icon(
            Icons.person_remove,
            size: 32,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
