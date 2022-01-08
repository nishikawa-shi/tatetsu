import 'package:english_words/english_words.dart';
import 'package:tatetsu/model/entity/participant.dart';

class ParticipantsUsecase {
  List<Participant> getDefaults() {
    return [Participant("Alice"), Participant("Bob"), Participant("Charley")];
  }

  Participant createDummy() {
    final displayName =
        ["Dr.", generateWordPairs().first.asUpperCase].join(" ");
    return Participant(displayName);
  }
}
