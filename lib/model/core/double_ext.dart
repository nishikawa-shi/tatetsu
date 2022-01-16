extension DoubleExt on double {
  double floorAtSecondDecimal() =>
      this == 0 ? 0 : (this * 100).abs().floor() / 100 * (isNegative ? -1 : 1);
}
