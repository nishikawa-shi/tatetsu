import 'package:tatetsu/ui/core/string_ext.dart';
import 'package:test/test.dart';

void main() {
  test('StringExt_toHintText_元の値に対して、例示であることがわかる接頭辞が付与された値を返す', () {
    expect(
      'testname1'.toHintText(),
      'e.g. testname1',
    );
  });
}
