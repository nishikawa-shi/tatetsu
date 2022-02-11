import 'dart:io';

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

String getSettleAccountsTopBannerId() {
  try {
    return (Platform.isAndroid || Platform.isFuchsia)
        ? FlavorConfig.instance
            .variables["settle_accounts_top_banner_id_android"] as String
        : FlavorConfig.instance.variables["settle_accounts_top_banner_id_ios"]
            as String;
  } catch (e) {
    // テスト広告のID https://developers.google.com/admob/ios/test-ads#demo_ad_units
    return "ca-app-pub-3940256099942544/2934735716";
  }
}
