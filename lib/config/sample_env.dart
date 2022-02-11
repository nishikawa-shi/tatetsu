import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

void setConfig() => FlavorConfig(
      name: "name",
      variables: {
        "application_title": "title",
        "application_theme": ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        "entry_page_title": "title",
        "settle_accounts_top_banner_id_ios":
            "ca-app-pub-3940256099942544/2934735716",
        "settle_accounts_top_banner_id_android":
            "ca-app-pub-3940256099942544/2934735716"
      },
    );
