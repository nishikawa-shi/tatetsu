import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/procedure.dart';
import 'package:test/test.dart';

void main() {
  group('Procedure', () {
    test('Procedure_from属性に、プロパティを外部から操作しなかった時引数で渡した値が設定される', () {
      final Participant testFromParticipant1 = Participant("testName1");

      expect(
        Procedure(
          from: testFromParticipant1,
          to: Participant("testToParticipant1"),
          amount: 0.0,
        ).from,
        equals(testFromParticipant1),
      );
    });

    test('Procedure_from属性に、プロパティを外部から操作した時書き換え後の値が設定される', () {
      final Participant testFromParticipant1 = Participant("testName1");
      final Participant testFromParticipant2 = Participant("testName2");

      expect(
        (Procedure(
          from: testFromParticipant1,
          to: Participant("testToParticipant1"),
          amount: 0.0,
        )..from = testFromParticipant2)
            .from,
        equals(testFromParticipant2),
      );
    });
  });
}
