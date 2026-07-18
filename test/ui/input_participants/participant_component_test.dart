import 'package:flutter_test/flutter_test.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/ui/input_participants/participant_component.dart';

void main() {
  group('ParticipantComponent', () {
    test('defaultDisplayName_元のParticipantの表示名が設定される', () {
      expect(
        ParticipantComponent(Participant("testName")).defaultDisplayName,
        "testName",
      );
    });

    test('displayName_コントローラが空の時、デフォルト値を返す', () {
      expect(
        ParticipantComponent(Participant("testName")).displayName,
        "testName",
      );
    });

    test('displayName_コントローラに入力がある時、入力値を返す', () {
      final component = ParticipantComponent(Participant("testName"))
        ..displayNameController.text = "user input name";
      expect(component.displayName, "user input name");
    });

    test('displayName_コントローラの入力を全て消した時、デフォルト値に戻る', () {
      final component = ParticipantComponent(Participant("testName"))
        ..displayNameController.text = "user input name"
        ..displayNameController.text = "";
      expect(component.displayName, "testName");
    });
  });
}
