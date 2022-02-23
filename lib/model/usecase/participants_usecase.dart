import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:tatetsu/l10n/built/app_localizations.dart';
import 'package:tatetsu/model/entity/participant.dart';

class ParticipantsUsecase {
  List<Participant> getDefaults(BuildContext context) {
    return [
      Participant(
        AppLocalizations.of(context)?.sampleCommonParticipantsNameFirst ??
            "Smith",
      ),
      Participant(
        AppLocalizations.of(context)?.sampleCommonParticipantsNameSecond ??
            "Johnson",
      ),
      Participant(
        AppLocalizations.of(context)?.sampleCommonParticipantsNameThird ??
            "Williams",
      )
    ];
  }

  Participant createDummy() {
    final displayName =
        ["Dr.", generateWordPairs().first.asUpperCase].join(" ");
    return Participant(displayName);
  }
}
