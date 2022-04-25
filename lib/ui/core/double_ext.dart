import 'package:flutter/material.dart';
import 'package:tatetsu/ui/core/string_ext.dart';

extension DoubleExt on double {
  String toHintText(BuildContext context) {
    if (Localizations.localeOf(context).languageCode == "ja") {
      return toInt().toString().toHintText(context);
    }
    return toString().toHintText(context);
  }
}
