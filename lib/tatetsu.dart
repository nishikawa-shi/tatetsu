import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tatetsu/config/application_meta.dart';
import 'package:tatetsu/l10n/built/app_localizations.dart';
import 'package:tatetsu/ui/input_participants/input_participants_page.dart';

class Tatetsu extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', ''), Locale('ja', '')],
        title: getAppTitle(),
        theme: getAppTheme(),
        home: InputParticipantsPage(
          titlePrefix: getEntryPageTitlePrefix(),
        ),
      );
}
