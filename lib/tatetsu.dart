import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:tatetsu/config/application_meta.dart';
import 'package:tatetsu/l10n/built/app_localizations.dart';
import 'package:tatetsu/ui/input_accounting_detail/input_accounting_detail_page.dart';
import 'package:tatetsu/ui/input_participants/input_participants_page.dart';
import 'package:tatetsu/ui/settle_accounts/settle_accounts_page.dart';

class Tatetsu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routerConfig = GoRouter(
      initialLocation: "/app",
      routes: [
        GoRoute(
          path: "/app",
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: InputParticipantsPage(
              titlePrefix: getEntryPageTitlePrefix(),
            ),
          ),
          routes: [
            GoRoute(
              path: "accounting_detail",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                key: state.pageKey,
                child: const InputAccountingDetailPage(),
              ),
              routes: [
                GoRoute(
                  path: "settle_accounts",
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      MaterialPage(
                    key: state.pageKey,
                    child: const SettleAccountsPage(),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: routerConfig,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('ja', '')],
      title: getAppTitle(),
      theme: getAppTheme(),
    );
  }
}
