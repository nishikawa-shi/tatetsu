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

    test('DoubleExt_minusAtSecondDecimal_0.01以上の値は残る', () {
      expect(6.67.minusAtSecondDecimal(6.66), equals(0.01));
    });

    test('DoubleExt_minusAtSecondDecimal_言語の特性上0.01以上と判断される値は残る', () {
      expect(6.6699999999999995.minusAtSecondDecimal(6.66), equals(0.01));
    });

    test('DoubleExt_minusAtSecondDecimal_言語の特性上0.01未満と判断される値は残らない', () {
      expect(6.6699999999999994.minusAtSecondDecimal(6.66), equals(0));
    });

    test('DoubleExt_plusAtSecondDecimal_-0.01以下の値はと判断される値は残る', () {
      expect((-6.67).plusAtSecondDecimal(6.66), equals(-0.01));
    });

    test('DoubleExt_minusAtSecondDecimal_言語の特性上0.01以上と判断される値は残る', () {
      expect((-6.6699999999999995).plusAtSecondDecimal(6.66), equals(-0.01));
    });

    test('DoubleExt_minusAtSecondDecimal_言語の特性上0.01未満と判断される値は残らない', () {
      expect((-6.6699999999999994).plusAtSecondDecimal(6.66), equals(0));
    });
  });
}
