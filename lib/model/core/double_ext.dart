extension DoubleExt on double {
  double roundAtSecondDecimal() =>
      this == 0 ? 0 : (this * 100).abs().round() / 100 * (isNegative ? -1 : 1);

  double minusAtSecondDecimal(double value) =>
      (((this * 100).round() - (value * 100).round()) / 100)
          .roundAtSecondDecimal();

  double plusAtSecondDecimal(double value) =>
      (((this * 100).round() + (value * 100).round()) / 100)
          .roundAtSecondDecimal();
}
