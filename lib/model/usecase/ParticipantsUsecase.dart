import 'package:english_words/english_words.dart';
import 'package:tatetsu/model/entity/Participant.dart';

class ParticipantsUsecase {
  static List<Participant> getDefaults() {
    return [Participant("Alice"), Participant("Bob")];
  }

  static Participant createDummy() {
    final displayName =
        ["Dr.", generateWordPairs().first.asUpperCase].join(" ");
    return Participant(displayName);
  }
}