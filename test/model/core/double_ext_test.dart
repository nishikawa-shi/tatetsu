import 'package:tatetsu/model/core/double_ext.dart';
import 'package:test/test.dart';

void main() {
  group('DoubleExt', () {
    test('DoubleExt_roundAtSecondDecimal_0の時、0', () {
      expect(0.0.roundAtSecondDecimal(), equals(0));
    });

    test('DoubleExt_roundAtSecondDecimal_0.01未満と判断される値が繰り上がる', () {
      expect(28.004999999999998.roundAtSecondDecimal(), equals(28.01));
    });

    test('DoubleExt_roundAtSecondDecimal_0.01未満と判断される値が切り捨てられる', () {
      expect(28.004999999999997.roundAtSecondDecimal(), equals(28));
    });

    test('DoubleExt_roundAtSecondDecimal_演算の結果0.01以上と判断される負の値が繰り上がる', () {
      expect((-10 + 9.9950000000000001).roundAtSecondDecimal(), equals(-0.01));
    });

    test('DoubleExt_roundAtSecondDecimal_演算の結果0.01未満と判断される負の値が切り捨てられる', () {
      expect((-10 + 9.9950000000000002).roundAtSecondDecimal(), equals(0));
    });

    test('DoubleExt_minusAtSecondDecimal_0.01以上の値は残る', () {
      expect(6.67.minusAtSecondDecimal(6.66), equals(0.01));
    });

    test('DoubleExt_minusAtSecondDecimal_60.45に対して20.15を作用させると40.3', () {
      expect(60.45.minusAtSecondDecimal(20.15), equals(40.3));
    });

    test('DoubleExt_minusAtSecondDecimal_言語の特性上0.01以上と判断される値は残る', () {
      expect(6.6649999999999996.minusAtSecondDecimal(6.66), equals(0.01));
    });

    test('DoubleExt_minusAtSecondDecimal_言語の特性上0.01未満と判断される値は残らない', () {
      expect(6.6649999999999995.minusAtSecondDecimal(6.66), equals(0));
    });

    test('DoubleExt_plusAtSecondDecimal_-0.01以下の値はと判断される値は残る', () {
      expect((-6.67).plusAtSecondDecimal(6.66), equals(-0.01));
    });

    test('DoubleExt_minusAtSecondDecimal_言語の特性上0.01以上と判断される値は残る', () {
      expect((-6.6649999999999996).plusAtSecondDecimal(6.66), equals(-0.01));
    });

    test('DoubleExt_minusAtSecondDecimal_言語の特性上0.01未満と判断される値は残らない', () {
      expect((-6.6649999999999995).plusAtSecondDecimal(6.66), equals(0));
    });
  });
}
