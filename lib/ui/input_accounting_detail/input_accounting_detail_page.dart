import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tatetsu/l10n/built/app_localizations.dart';
import 'package:tatetsu/model/core/double_ext.dart';
import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/transport/account_detail_dto.dart';
import 'package:tatetsu/model/usecase/advertisement_usecase.dart';
import 'package:tatetsu/ui/core/double_ext.dart';
import 'package:tatetsu/ui/core/string_ext.dart';
import 'package:tatetsu/ui/input_accounting_detail/accounting_detail_state.dart';
import 'package:tatetsu/ui/input_accounting_detail/exclude_participants_dialog.dart';
import 'package:tatetsu/ui/input_accounting_detail/payment_component.dart';
import 'package:tatetsu/ui/settle_accounts/settle_accounts_page.dart';

class InputAccountingDetailPage extends StatefulWidget {
  const InputAccountingDetailPage() : super();

  @override
  _InputAccountingDetailPageState createState() =>
      _InputAccountingDetailPageState();
}

class _InputAccountingDetailPageState extends State<InputAccountingDetailPage> {
  AccountingDetailState? state;

  @override
  Widget build(BuildContext context) {
    _initializeStateIfEmpty(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: _showDiscardConfirmDialogIfNeeded,
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)?.payments ?? "Payments"),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  _toSettleAccounts();
                },
                child: Icon(
                  Icons.summarize,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            ],
          ),
          body: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              if (index == 1) {
                return Center(
                  child: Wrap(
                    children: [
                      TextButton(
                        onPressed: _insertPaymentToLast,
                        child: const Icon(Icons.add_circle, size: 32),
                      )
                    ],
                  ),
                );
              }

              return ExpansionPanelList(
                key: UniqueKey(),
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    state?.payments[index].isExpanded = !isExpanded;
                  });
                },
                children: state?.payments
                        .map<ExpansionPanel>((PaymentComponent payment) {
                      return ExpansionPanel(
                        headerBuilder: (BuildContext _, bool __) {
                          return _paymentHeader(payment);
                        },
                        body: _paymentBody(payment),
                        isExpanded: payment.isExpanded,
                      );
                    }).toList() ??
                    [],
              );
            },
            itemCount: 2, // 入力部分と追加ボタンで、合計2
          ),
        ),
      ),
    );
  }

  void _initializeStateIfEmpty(BuildContext context) {
    final paramsValue = GoRouterState.of(context).queryParams["params"];
    if (paramsValue == null) return;

    state ??= AccountDetailDto.fromJson(
      jsonDecode(paramsValue) as Map<String, dynamic>,
    ).toAccountingDetailState();

    if (state?.payments.isEmpty ?? false) {
      state?.payments.add(
        PaymentComponent.sample(
          participants: state?.participants ?? [],
          context: context,
        ),
      );
    }
  }

  Future<bool> _showDiscardConfirmDialogIfNeeded() =>
      state?.payments.hasOnlySampleElement(
                onParticipants: state?.participants ?? [],
                context: context,
              ) ??
              false
          ? Future(() => true)
          : showDialog<bool>(
              context: context,
              builder: (context) => _discardConfirmDialog(),
            ).then((value) => value ?? false);

  AlertDialog _discardConfirmDialog() => AlertDialog(
        content: Text(
          AppLocalizations.of(context)?.paymentDiscardConfirmDialogBody ??
              "Are you sure to discard the input payments?",
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).disabledColor,
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              AppLocalizations.of(context)?.dialogCancelLabel ?? "Cancel",
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              AppLocalizations.of(context)?.dialogDiscardLabel ?? "Discard",
            ),
          )
        ],
      );

  void _toSettleAccounts() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return SettleAccountsPage(
            payments: state?.payments.map((e) => e.toPayment()).toList() ?? [],
            advertisementUsecase: AdvertisementUsecase.shared(),
          );
        },
      ),
    );
  }

  void _insertPaymentToLast() {
    setState(() {
      state?.payments.add(
        PaymentComponent(
          participants: state?.participants ?? [],
          context: context,
        ),
      );
    });
  }

  void _deletePayment(PaymentComponent payment) {
    setState(() {
      state?.payments.remove(payment);
    });
  }

  ListTile _paymentHeader(PaymentComponent payment) {
    final String defaultPaymentTitle = payment.title;
    return ListTile(
      title: TextFormField(
        decoration:
            InputDecoration(hintText: defaultPaymentTitle.toHintText(context)),
        initialValue: payment.hasUserSpecifiedTitle ? payment.title : null,
        key: UniqueKey(),
        onChanged: (String value) {
          payment.hasUserSpecifiedTitle = true;
          payment.title = value.isNotEmpty ? value : defaultPaymentTitle;
        },
      ),
    );
  }

  Container _paymentBody(PaymentComponent payment) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: _paymentEditBody(payment),
    );
  }

  Column _paymentEditBody(PaymentComponent payment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _payerView(payment),
        _priceView(payment),
        _actionsView(payment),
      ].expand((e) => e).toList(),
    );
  }

  List<Widget> _payerView(PaymentComponent payment) {
    return [
      Text(
        AppLocalizations.of(context)?.paymentPayerLabel ?? "Payer",
        style: Theme.of(context).textTheme.labelMedium,
      ),
      DropdownButton<Participant>(
        value: payment.payer,
        onChanged: (Participant? newValue) {
          setState(() {
            if (newValue == null) {
              return;
            }
            payment.payer = newValue;
          });
        },
        items: payment.owners.keys
            .map<DropdownMenuItem<Participant>>((Participant value) {
          return DropdownMenuItem<Participant>(
            value: value,
            child: Text(
              value.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        isExpanded: true,
      ),
    ];
  }

  List<Widget> _priceView(PaymentComponent payment) {
    final double defaultPaymentPriceValue = payment.price;
    return [
      const SizedBox(height: 16),
      Text(
        AppLocalizations.of(context)?.paymentPriceLabel ?? "Price",
        style: Theme.of(context).textTheme.labelMedium,
      ),
      TextFormField(
        decoration: InputDecoration(
          hintText: defaultPaymentPriceValue.toHintText(context),
        ),
        initialValue:
            payment.hasUserSpecifiedPrice ? payment.price.toString() : null,
        key: UniqueKey(),
        onChanged: (String value) {
          payment.hasUserSpecifiedPrice = true;
          payment.price = value.isNotEmpty
              ? double.parse(value).roundAtSecondDecimal()
              : defaultPaymentPriceValue;
        },
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    ];
  }

  List<Widget> _actionsView(PaymentComponent payment) {
    final bool isOnlyPayment = (state?.payments.length ?? 0) <= 1;
    return [
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => ExcludeParticipantsDialog(payment: payment),
              );
            },
            child: const Icon(Icons.person_off, size: 32),
          ),
          TextButton(
            onPressed: isOnlyPayment
                ? null
                : () => showDialog(
                      context: context,
                      builder: (context) =>
                          _paymentDeleteConfirmDialog(payment),
                    ),
            child: const Icon(Icons.delete_forever, size: 32),
          ),
        ],
      )
    ];
  }

  AlertDialog _paymentDeleteConfirmDialog(PaymentComponent payment) =>
      AlertDialog(
        content: Text(
          [
            AppLocalizations.of(context)
                    ?.paymentDeleteConfirmDescriptionPrefix ??
                "Are you sure to discard the payment [",
            payment.title,
            AppLocalizations.of(context)
                    ?.paymentDeleteConfirmDescriptionSuffix ??
                "] ?",
          ].join(" "),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).disabledColor,
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)?.dialogCancelLabel ?? "Cancel",
            ),
          ),
          TextButton(
            onPressed: () {
              _deletePayment(payment);
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)?.dialogDeleteLabel ?? "Delete",
            ),
          )
        ],
      );
}
