import 'package:tatetsu/model/core/double_ext.dart';
import 'package:test/test.dart';

void main() {
  group('DoubleExt', () {
    test('DoubleExt_floorAtSecondDecimal_0の時、0', () {
      expect(0.0.floorAtSecondDecimal(), equals(0));
    });

    test('DoubleExt_floorAtSecondDecimal_0.01未満と判断される値が切り捨てられる', () {
      expect(28.009999999999996.floorAtSecondDecimal(), equals(28));
    });

    test('DoubleExt_floorAtSecondDecimal_演算の結果0.01未満と判断される負の値が切り捨てられる', () {
      expect((-10 + 9.9900001).floorAtSecondDecimal(), equals(0));
    });

    test('DoubleExt_floorAtSecondDecimal_0.01以上と判断される値は残る', () {
      expect(28.009999999999997.floorAtSecondDecimal(), equals(28.01));
    });
  });
}
