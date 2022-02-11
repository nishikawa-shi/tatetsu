import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tatetsu/config/application_meta.dart';
import 'package:tatetsu/config/prd.dart';
import 'package:tatetsu/ui/input_participants/input_participants_page.dart';

void main() {
  setConfig();
  WidgetsFlutterBinding.ensureInitialized(); // この処理を行わないとAdMobの初期化がうまくいかない
  MobileAds.instance.initialize();
  runApp(Tatetsu());
}

class Tatetsu extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: getAppTitle(),
        theme: getAppTheme(),
        home: InputParticipantsPage(
          title: getEntryPageTitle(),
        ),
      );
}
