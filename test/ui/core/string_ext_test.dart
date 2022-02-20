import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tatetsu/l10n/built/app_localizations.dart';
import 'package:tatetsu/ui/core/string_ext.dart';

void main() {
  testWidgets('StringExt_toHintText_英語設定の時、元の値に対して、例示であることがわかる英語接頭辞が付与された値を返す',
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
            expect("西川".toHintText(context), equals("e.g. 西川"));
            return const Placeholder();
          },
        ),
      ),
    );
  });

  testWidgets(
      'StringExt_toHintText_日本語設定の時、元の値に対して、例示であることがわかる日本語接頭辞が付与された値を返す',
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
            expect("西川".toHintText(context), equals("例. 西川"));
            return const Placeholder();
          },
        ),
      ),
    );
  });

  testWidgets('StringExt_toHintText_英語でも日本語でもない設定の時、元の値に対して、英語接頭辞が付与された値を返す',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      Localizations(
        delegates: const [
          AppLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        locale: const Locale('kn'),
        child: Builder(
          builder: (BuildContext context) {
            expect("西川".toHintText(context), equals("e.g. 西川"));
            return const Placeholder();
          },
        ),
      ),
    );
  });
}
