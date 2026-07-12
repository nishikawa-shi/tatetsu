import 'dart:convert';

import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/transport/account_detail_dto.dart';
import 'package:tatetsu/model/transport/payment_dto.dart';
import 'package:tatetsu/ui/input_accounting_detail/payment_component.dart';

class AccountingDetailState {
  final List<Participant> participants;
  final List<PaymentComponent> payments;

  AccountingDetailState({required this.participants, required this.payments});

  // locationのうちpathのみを使う。クエリまで含めると、共有リンク経由で開いた
  // 画面（?params=付き）から再共有した時にparamsが二重化し復元不能なURLになる
  Uri toUri({required Uri location}) => Uri(
        scheme: "https",
        host: "tatetsu.ntetz.com",
        path: location.path,
        queryParameters: {
          "params": jsonEncode(
            AccountDetailDto(
              pNm: participants.map((e) => e.displayName).toList(),
              ps: payments
                  .map((e) => PaymentDto.fromPayment(e.toPayment()))
                  .toList(),
            ).toJson(),
          ),
        },
      );
}

extension AccountDetailDtoExt on AccountDetailDto {
  AccountingDetailState toAccountingDetailState() {
    final participants = pNm.map((e) => Participant(e)).toList();
    final payments = ps
        .map(
          (e) => PaymentComponent.of(
            title: e.ttl,
            payer: participants.firstWhere((p) => p.displayName == e.pN),
            price: e.prc,
            owners: e.ons.map(
              (ownerString, value) => MapEntry(
                participants.firstWhere((p) => p.displayName == ownerString),
                value,
              ),
            ),
          ),
        )
        .toList();
    return AccountingDetailState(
      participants: participants,
      payments: payments,
    );
  }
}
