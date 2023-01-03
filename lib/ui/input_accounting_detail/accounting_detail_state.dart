import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/transport/account_detail_dto.dart';
import 'package:tatetsu/ui/input_accounting_detail/payment_component.dart';

class AccountingDetailState {
  final List<Participant> participants;
  final List<PaymentComponent> payments;

  AccountingDetailState({required this.participants, required this.payments});
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
          )
            ..hasUserSpecifiedTitle = true
            ..hasUserSpecifiedPrice = true,
        )
        .toList();
    return AccountingDetailState(
      participants: participants,
      payments: payments,
    );
  }
}
