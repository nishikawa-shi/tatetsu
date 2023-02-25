import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tatetsu/l10n/built/app_localizations.dart';
import 'package:tatetsu/model/entity/creditor.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';
import 'package:tatetsu/model/entity/procedure.dart';
import 'package:tatetsu/model/entity/settlement.dart';
import 'package:tatetsu/model/entity/transaction.dart';
import 'package:tatetsu/model/transport/account_detail_dto.dart';
import 'package:tatetsu/model/usecase/advertisement_usecase.dart';
import 'package:tatetsu/ui/settle_accounts/settle_accounts_state.dart';

class SettleAccountsPage extends StatefulWidget {
  const SettleAccountsPage() : super();

  @override
  _SettleAccountsPageState createState() => _SettleAccountsPageState();
}

class _SettleAccountsPageState extends State<SettleAccountsPage> {
  SettleAccountsState? state;
  Transaction? transaction;
  final AdvertisementUsecase advertisementUsecase =
      AdvertisementUsecase.shared();

  @override
  Widget build(BuildContext context) {
    _initializeStateIfEmpty(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.creditSummaries ?? "Credit Summaries",
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              final summaryMessage =
                  transaction?.toSummaryMessage(context: context);
              final Size size = MediaQuery.of(context).size;
              Share.share(
                summaryMessage?.body ?? "",
                subject: summaryMessage?.title ?? "",
                sharePositionOrigin:
                    Rect.fromLTWH(0, 0, size.width * 2, size.height / 16),
              );
            },
            child: Icon(
              !kIsWeb && (Platform.isMacOS || Platform.isIOS)
                  ? Icons.ios_share
                  : Icons.share,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
      body: ListView(
        children: _settleAccountsComponents(this),
      ),
    );
  }

  void _initializeStateIfEmpty(BuildContext context) {
    final paramsValue = GoRouterState.of(context).queryParams["params"];
    if (paramsValue == null) return;

    state ??= AccountDetailDto.fromJson(
      jsonDecode(paramsValue) as Map<String, dynamic>,
    ).toSettleAccountsState();

    transaction ??= Transaction(state?.payments ?? []);
  }

  List<Card> _settleAccountsComponents(State<SettleAccountsPage> state) {
    final components = <Card>[];
    if (advertisementUsecase.isSettleAccountsTopBannerSuccessfullyLoaded()) {
      components.add(
        Card(
          child: _adTopBannerComponent(advertisementUsecase),
        ),
      );
    }
    return components
      ..addAll([
        Card(
          child: Column(
            children: [
              _titleComponent(
                AppLocalizations.of(context)?.summaryPaymentsTitle ??
                    "Payments",
              ),
              _labelComponent(
                AppLocalizations.of(context)?.summaryPaymentsItemLabel ??
                    "Items",
              ),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: transaction?.payments
                        .map((e) => _paymentComponent(e))
                        .toList() ??
                    [],
              ),
              const SizedBox(
                height: 16,
              )
            ],
          ),
        ),
        Card(
          child: _creditorsComponent(transaction?.creditor),
        ),
        Card(
          child: _settlementComponent(transaction?.settlement),
        ),
      ]);
  }

  ListTile _titleComponent(String title) => ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );

  Column _labelComponent(String label) => Column(
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 16),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 8),
        ],
      );

  Column _adTopBannerComponent(AdvertisementUsecase advertisementUsecase) {
    final banner = advertisementUsecase.settleAccountsTopBanner;
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: banner.size.width.toDouble(),
          height: banner.size.height.toDouble(),
          child: AdWidget(ad: banner),
        )
      ],
    );
  }

  Column _paymentComponent(Payment payment) => Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Text(
                  payment.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  payment.payer.displayName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  payment.price.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 8),
        ],
      );

  Column _creditorsComponent(Creditor? creditor) {
    final List<Widget> baseCreditorsElements = [
      _titleComponent(
        AppLocalizations.of(context)?.summaryCreditorsTitle ?? "Creditors",
      ),
    ];

    baseCreditorsElements.addAll([
      _labelComponent(
        AppLocalizations.of(context)?.summaryCreditorsBalanceLabel ?? "Balance",
      ),
      ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: creditor?.entries.entries
                .toList()
                .map((e) => _creditorComponent(e))
                .toList() ??
            [],
      ),
      const SizedBox(
        height: 16,
      )
    ]);

    if (creditor?.hasError() ?? false) {
      baseCreditorsElements.addAll([
        _labelComponent(
          AppLocalizations.of(context)?.summaryCreditorsErrorLabel ?? "Error",
        ),
        _creditorErrorComponent(creditor?.getError() ?? 0),
        const SizedBox(
          height: 8,
        )
      ]);
    }

    return Column(
      children: baseCreditorsElements
        ..add(
          const SizedBox(
            height: 8,
          ),
        ),
    );
  }

  Column _creditorComponent(MapEntry<Participant, double> creditorEntry) =>
      Column(
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: Text(
                  creditorEntry.key.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  creditorEntry.value.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 8),
        ],
      );

  Column _creditorErrorComponent(double errorAmount) => Column(
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: Text(
                  AppLocalizations.of(context)
                          ?.summaryCreditorsErrorDescription ??
                      "Total",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  errorAmount.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 8),
        ],
      );

  Column _settlementComponent(Settlement? settlement) {
    final List<Widget> baseSettlementElements = [
      _titleComponent(
        AppLocalizations.of(context)?.summarySettlementsTitle ?? "Settlements",
      ),
    ];

    baseSettlementElements.addAll([
      _labelComponent(
        AppLocalizations.of(context)?.summarySettlementsProceduresLabel ??
            "Procedures",
      ),
      ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: settlement?.procedures
                .map((e) => _proceduresComponent(e))
                .toList() ??
            [],
      ),
      const SizedBox(
        height: 8,
      )
    ]);

    if (settlement?.errors.isNotEmpty ?? false) {
      baseSettlementElements.addAll([
        _labelComponent(
          AppLocalizations.of(context)?.summarySettlementsErrorRestsLabel ??
              "Error rests",
        ),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: settlement?.errors.entries
                  .map((e) => _settlementErrorComponent(e))
                  .toList() ??
              [],
        ),
        const SizedBox(
          height: 8,
        )
      ]);
    }

    return Column(
      children: baseSettlementElements
        ..add(
          const SizedBox(
            height: 8,
          ),
        ),
    );
  }

  Column _proceduresComponent(Procedure procedure) => Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Text(
                  procedure.from.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Icon(
                  Icons.arrow_right,
                  size: Theme.of(context).textTheme.bodyMedium?.fontSize,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(procedure.to.displayName),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  procedure.amount.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 8),
        ],
      );

  Column _settlementErrorComponent(MapEntry<Participant, double> error) =>
      Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: Text(
                  error.key.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  error.value.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 8),
        ],
      );
}
