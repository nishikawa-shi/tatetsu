import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:tatetsu/config/core.dart';

String getAppTitle() {
  try {
    return FlavorConfig.instance.variables["application_title"] as String;
  } catch (e) {
    return "Tatetsu";
  }
}

ThemeData getAppTheme() {
  try {
    return FlavorConfig.instance.variables["application_theme"] as ThemeData;
  } catch (e) {
    return ThemeData(
      primarySwatch: tatetsuViolet,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

String getEntryPageTitle() {
  try {
    return FlavorConfig.instance.variables["entry_page_title"] as String;
  } catch (e) {
    return "Participants";
  }
}
