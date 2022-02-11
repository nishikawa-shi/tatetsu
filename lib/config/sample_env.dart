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
        "entry_page_title": "title"
      },
    );
