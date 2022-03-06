import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:tatetsu/config/core.dart';

void setConfig() => FlavorConfig(
      name: "name",
      variables: {
        "application_title": "title",
        "application_theme": ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Colors.red,
            onSurface: tatetsuGrey,
          ),
          primarySwatch: Colors.red, // これを設定しないとチェックボックス(立替参加者除外画面)の色にprimaryが設定されない
          hintColor: tatetsuGrey,
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        "entry_page_title_prefix": "[Env]",
        "settle_accounts_top_banner_id_ios":
            "ca-app-pub-3940256099942544/2934735716",
        "settle_accounts_top_banner_id_android":
            "ca-app-pub-3940256099942544/2934735716"
      },
    );
