import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tatetsu/l10n/built/app_localizations.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/ui/input_accounting_detail/payment_component.dart';

void main() {
  final Participant testParticipant1 = Participant("testName1");
  final Participant testParticipant2 = Participant("testName2");

  group('PaymentComponent', () {
    test('PaymentComponent_title属性に、クラス内で指定したデフォルト値が設定される', () {
      expect(
        PaymentComponent(participants: [Participant("testName")]).title,
        equals("Some Payment"),
      );
    });

    test('PaymentComponent_payer属性に、引数で渡した値の1番目が設定される', () {
      expect(
        PaymentComponent(participants: [testParticipant1, testParticipant2])
            .payer,
        equals(testParticipant1),
      );
    });

    test('PaymentComponent_引数に空配列を渡すとエラー', () {
      expect(() => PaymentComponent(participants: []), throwsStateError);
    });

    test('PaymentComponent_owners属性に、引数で渡した値に対してtrueのハッシュマップが設定される', () {
      expect(
        PaymentComponent(participants: [testParticipant1, testParticipant2])
            .owners,
        equals({testParticipant1: true, testParticipant2: true}),
      );
    });

    testWidgets('PaymentComponent_sample_英語設定の時、title属性に英語の値が設定される',
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
                PaymentComponent.sample(
                  participants: [testParticipant1, testParticipant2],
                  context: context,
                ).title,
                equals("Lunch at the nice cafe"),
              );
              return const Placeholder();
            },
          ),
        ),
      );
    });

    testWidgets('PaymentComponent_sample_日本語設定の時、title属性に日本語の値が設定される',
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
                PaymentComponent.sample(
                  participants: [testParticipant1, testParticipant2],
                  context: context,
                ).title,
                equals("昼食代"),
              );
              return const Placeholder();
            },
          ),
        ),
      );
    });

    testWidgets('PaymentComponent_sample_英語でも日本語でもない設定の時、title属性に英語の値が設定される',
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
                PaymentComponent.sample(
                  participants: [testParticipant1, testParticipant2],
                  context: context,
                ).title,
                equals("Lunch at the nice cafe"),
              );
              return const Placeholder();
            },
          ),
        ),
      );
    });

    test('toPayment_プロパティを外部から操作しなかった時、クラス内で指定したデフォルト値を含むPaymentオブジェクトを返す', () {
      expect(
        PaymentComponent(participants: [testParticipant1, testParticipant2])
            .toPayment()
            .title,
        equals("Some Payment"),
      );
    });

    test('toPayment_プロパティを外部から操作した時、書き換え後の値を含むPaymentオブジェクトを返す', () {
      expect(
        (PaymentComponent(participants: [testParticipant1, testParticipant2])
              ..title = "Modified Test Payment")
            .toPayment()
            .title,
        equals("Modified Test Payment"),
      );
    });

    testWidgets(
        'PaymentComponentsExt_hasOnlySampleElement_要素数が1つでプロパティがサンプルと同じ時true',
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
                [
                  PaymentComponent(
                    participants: [testParticipant1, testParticipant2],
                  )
                    ..title = "Lunch at the nice cafe"
                    ..payer = testParticipant1
                    ..price = 66.0
                    ..owners = {testParticipant1: true, testParticipant2: true}
                ].hasOnlySampleElement(
                  onParticipants: [testParticipant1, testParticipant2],
                  context: context,
                ),
                true,
              );
              return const Placeholder();
            },
          ),
        ),
      );
    });

    testWidgets(
        'PaymentComponentsExt_hasOnlySampleElement_要素数が1つで支払名が異なる時false',
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
                [
                  PaymentComponent(
                    participants: [testParticipant1, testParticipant2],
                  )..title = "modified title"
                ].hasOnlySampleElement(
                  onParticipants: [testParticipant1, testParticipant2],
                  context: context,
                ),
                equals(false),
              );
              return const Placeholder();
            },
          ),
        ),
      );
    });

    testWidgets(
        'PaymentComponentsExt_hasOnlySampleElement_要素数が1つで支払者が異なる時false',
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
                [
                  PaymentComponent(
                    participants: [testParticipant1, testParticipant2],
                  )..payer = testParticipant2
                ].hasOnlySampleElement(
                  onParticipants: [testParticipant1, testParticipant2],
                  context: context,
                ),
                equals(false),
              );
              return const Placeholder();
            },
          ),
        ),
      );
    });

    testWidgets('PaymentComponentsExt_hasOnlySampleElement_要素数が1つで価格が異なる時false',
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
                [
                  PaymentComponent(
                    participants: [testParticipant1, testParticipant2],
                  )..price = 0.01
                ].hasOnlySampleElement(
                  onParticipants: [testParticipant1, testParticipant2],
                  context: context,
                ),
                equals(false),
              );
              return const Placeholder();
            },
          ),
        ),
      );
    });

    testWidgets(
        'PaymentComponentsExt_hasOnlySampleElement_要素数が1つで精算対象者が異なる時false',
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
                [
                  PaymentComponent(
                    participants: [testParticipant1, testParticipant2],
                  )..owners = {testParticipant1: true, testParticipant2: false}
                ].hasOnlySampleElement(
                  onParticipants: [testParticipant1, testParticipant2],
                  context: context,
                ),
                equals(false),
              );
              return const Placeholder();
            },
          ),
        ),
      );
    });

    testWidgets(
        'PaymentComponentsExt_hasOnlySampleElement_要素数が1つだが参加者が異なる時false',
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
                [
                  PaymentComponent(
                    participants: [testParticipant1, testParticipant2],
                  )
                ].hasOnlySampleElement(
                  onParticipants: [testParticipant1],
                  context: context,
                ),
                equals(false),
              );
              return const Placeholder();
            },
          ),
        ),
      );
    });

    testWidgets('PaymentComponentsExt_hasOnlySampleElement_要素数が2以上の時false',
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
                [
                  PaymentComponent(
                    participants: [testParticipant1, testParticipant2],
                  ),
                  PaymentComponent(
                    participants: [testParticipant1, testParticipant2],
                  )
                ].hasOnlySampleElement(
                  onParticipants: [testParticipant1, testParticipant2],
                  context: context,
                ),
                equals(false),
              );
              return const Placeholder();
            },
          ),
        ),
      );
    });
  });
}
