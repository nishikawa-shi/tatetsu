import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tatetsu/model/entity/creditor.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';
import 'package:tatetsu/model/entity/procedure.dart';
import 'package:tatetsu/model/entity/settlement.dart';
import 'package:tatetsu/model/entity/transaction.dart';
import 'package:tatetsu/model/usecase/advertisement_usecase.dart';

class SettleAccountsPage extends StatefulWidget {
  SettleAccountsPage({required this.payments})
      : transaction = Transaction(payments),
        super();

  final List<Payment> payments;
  final Transaction transaction;

  @override
  _SettleAccountsPageState createState() => _SettleAccountsPageState();
}

class _SettleAccountsPageState extends State<SettleAccountsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Credit Summaries"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                final summaryMessage = widget.transaction.toSummaryMessage();
                Share.share(summaryMessage.body, subject: summaryMessage.title);
              },
              child: const Icon(
                Icons.share,
                size: 32,
              ),
            )
          ],
        ),
        body: ListView(
          children: [
            Card(
              child: _adTopBannerComponent(),
            ),
            Card(
              child: Column(
                children: [
                  _titleComponent("Payments"),
                  _labelComponent("Items"),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: widget.transaction.payments
                        .map((e) => _paymentComponent(e))
                        .toList(),
                  ),
                  const SizedBox(
                    height: 16,
                  )
                ],
              ),
            ),
            Card(
              child: _creditorsComponent(widget.transaction.creditor),
            ),
            Card(
              child: _settlementComponent(widget.transaction.settlement),
            ),
          ],
        ),
      );

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

  Column _adTopBannerComponent() {
    final banner = AdvertisementUsecase.shared().settleAccountsTopBanner;
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

  Column _creditorsComponent(Creditor creditor) {
    final List<Widget> baseCreditorsElements = [
      _titleComponent("Creditors"),
    ];

    baseCreditorsElements.addAll([
      _labelComponent("Balance"),
      ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: creditor.entries.entries
            .toList()
            .map((e) => _creditorComponent(e))
            .toList(),
      ),
      const SizedBox(
        height: 16,
      )
    ]);

    if (creditor.hasError()) {
      baseCreditorsElements.addAll([
        _labelComponent("Error"),
        _creditorErrorComponent(creditor.getError()),
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
              const Expanded(
                flex: 5,
                child: Text(
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

  Column _settlementComponent(Settlement settlement) {
    final List<Widget> baseSettlementElements = [
      _titleComponent("Settlements"),
    ];

    baseSettlementElements.addAll([
      _labelComponent("Procedures"),
      ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children:
            settlement.procedures.map((e) => _proceduresComponent(e)).toList(),
      ),
      const SizedBox(
        height: 8,
      )
    ]);

    if (settlement.errors.isNotEmpty) {
      baseSettlementElements.addAll([
        _labelComponent("Error rests"),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: settlement.errors.entries
              .map((e) => _settlementErrorComponent(e))
              .toList(),
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
