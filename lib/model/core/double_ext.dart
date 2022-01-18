extension DoubleExt on double {
  double floorAtSecondDecimal() =>
      this == 0 ? 0 : (this * 100).abs().floor() / 100 * (isNegative ? -1 : 1);

  double minusAtSecondDecimal(double value) =>
      (((this * 100).toInt() - (value * 100).toInt()) / 100)
          .floorAtSecondDecimal();

  double plusAtSecondDecimal(double value) =>
      (((this * 100).toInt() + (value * 100).toInt()) / 100)
          .floorAtSecondDecimal();
}
