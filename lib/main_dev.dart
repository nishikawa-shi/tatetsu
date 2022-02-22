import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tatetsu/config/application_meta.dart';
import 'package:tatetsu/config/dev.dart';
import 'package:tatetsu/l10n/built/app_localizations.dart';
import 'package:tatetsu/model/usecase/advertisement_usecase.dart';
import 'package:tatetsu/ui/input_participants/input_participants_page.dart';

void main() {
  setConfig();
  WidgetsFlutterBinding.ensureInitialized(); // この処理を行わないとAdMobの初期化がうまくいかない
  AdvertisementUsecase.shared().initialize();
  Firebase.initializeApp();
  runApp(Tatetsu());
}

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
