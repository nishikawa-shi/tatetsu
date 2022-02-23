import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tatetsu/l10n/built/app_localizations.dart';
import 'package:tatetsu/model/usecase/participants_usecase.dart';

void main() {
  group('ParticipantsUsecase', () {
    testWidgets('getDefaults_英語設定の時、英語圏の名前が設定された参加者を3名返す',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Localizations(
          delegates: const [
            AppLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: const Locale('en'),
          child: Builder(
            builder: (BuildContext context) {
              expect(
                ParticipantsUsecase()
                    .getDefaults(context)
                    .map((e) => e.displayName),
                equals(["Smith", "Johnson", "Williams"]),
              );
              return const Placeholder();
            },
          ),
        ),
      );
    });

    testWidgets('getDefaults_日本語設定の時、日本語圏の名前が設定された参加者を3名返す',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Localizations(
          delegates: const [
            AppLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: const Locale('ja'),
          child: Builder(
            builder: (BuildContext context) {
              expect(
                ParticipantsUsecase()
                    .getDefaults(context)
                    .map((e) => e.displayName),
                equals(["鈴木", "佐藤", "田中"]),
              );
              return const Placeholder();
            },
          ),
        ),
      );
    });

    testWidgets('getDefaults_英語でも日本語でもない設定の時、英語圏の名前が設定された参加者を3名返す',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Localizations(
          delegates: const [
            AppLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: const Locale('es'),
          child: Builder(
            builder: (BuildContext context) {
              expect(
                ParticipantsUsecase()
                    .getDefaults(context)
                    .map((e) => e.displayName),
                equals(["Smith", "Johnson", "Williams"]),
              );
              return const Placeholder();
            },
          ),
        ),
      );
    });

    test('createDummy_Dr.から始まる名前が設定されていること', () {
      expect(
        ParticipantsUsecase().createDummy().displayName,
        startsWith("Dr."),
      );
    });
  });
}
