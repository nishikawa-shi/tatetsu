import 'package:flutter/material.dart';
import 'package:tatetsu/l10n/built/app_localizations.dart';

extension StringExt on String {
  String toHintText(BuildContext context) =>
      [AppLocalizations.of(context)?.examplePrefix ?? "e.g.", this].join(" ");
}
