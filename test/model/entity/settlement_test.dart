import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/procedure.dart';
import 'package:tatetsu/model/entity/settlement.dart';
import 'package:test/test.dart';

void main() {
  final Participant testParticipant1 = Participant("testName1");
  final Participant testParticipant2 = Participant("testName2");
  final Participant testParticipant3 = Participant("testName3");
  final Participant testParticipant4 = Participant("testName4");

  group('Settlement', () {
    test('Settlement_procedures属性に、プロパティを外部から操作しなかった時引数で渡した値が設定される', () {
      final testProcedures = [
        Procedure(from: testParticipant1, to: testParticipant2, amount: 30),
        Procedure(from: testParticipant2, to: testParticipant3, amount: 400),
      ];

      expect(
        Settlement(procedures: testProcedures, errors: {}).procedures,
        equals(testProcedures),
      );
    });

    test('Settlement_procedures属性に、プロパティを外部から操作した時書き換え後の値が設定される', () {
      final testProcedures = [
        Procedure(from: testParticipant1, to: testParticipant2, amount: 30),
        Procedure(from: testParticipant2, to: testParticipant3, amount: 400),
      ];

      expect(
        (Settlement(procedures: testProcedures, errors: {})..procedures = [])
            .procedures,
        equals([]),
      );
    });

    test('toSummary_procedures属性に空配列を渡した時、ラベルのみを返す', () {
      expect(
        Settlement(procedures: [], errors: {}).toSummary("Settlement"),
        equals("[Settlement]"),
      );
    });

    test('toSummary_procedures属性に1件を渡した時、ラベルに加えて支払元、支払先と支払量を改行1つで繋げて返す', () {
      expect(
        Settlement(
          procedures: [
            Procedure(from: testParticipant1, to: testParticipant2, amount: 30),
          ],
          errors: {},
        ).toSummary("Settlement"),
        equals(
          "[Settlement]\ntestName1 -> testName2: 30.0",
        ),
      );
    });

    test('toSummary_procedures属性に2件以上を渡した時、全ての手続きが含まれた値を改行1つで繋げて返す', () {
      expect(
        Settlement(
          procedures: [
            Procedure(from: testParticipant1, to: testParticipant2, amount: 30),
            Procedure(
              from: testParticipant2,
              to: testParticipant3,
              amount: 400,
            ),
            Procedure(
              from: testParticipant4,
              to: testParticipant1,
              amount: 5000,
            ),
          ],
          errors: {},
        ).toSummary("Settlement"),
        equals(
          "[Settlement]\ntestName1 -> testName2: 30.0\ntestName2 -> testName3: 400.0\ntestName4 -> testName1: 5000.0",
        ),
      );
    });
  });
}
