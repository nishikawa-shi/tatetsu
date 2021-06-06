import 'package:tatetsu/model/usecase/participants_usecase.dart';
import 'package:test/test.dart';

void main() {
  group('ParticipantsUsecase', () {
    test('getDefaults_デフォルトで3名分設定されていること', () {
      expect(ParticipantsUsecase.getDefaults().map((e) => e.displayName),
          equals(["Alice", "Bob", "Charley"]));
    });

    test('createDummy_Dr.から始まる名前が設定されていること', () {
      expect(ParticipantsUsecase.createDummy().displayName, startsWith("Dr."));
    });
  });
}
