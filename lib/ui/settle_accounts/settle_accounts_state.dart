import 'package:tatetsu/model/entity/participant.dart';
import 'package:tatetsu/model/entity/payment.dart';
import 'package:tatetsu/model/transport/account_detail_dto.dart';

class SettleAccountsState {
  SettleAccountsState({
    required this.payments,
  });

  final List<Payment> payments;
}

extension AccountDetailDtoExt on AccountDetailDto {
  SettleAccountsState toSettleAccountsState() {
    final participants = pNm.map((e) => Participant(e)).toList();
    final payments = ps
        .map(
          (e) => Payment(
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
    return SettleAccountsState(
      payments: payments,
    );
  }
}
