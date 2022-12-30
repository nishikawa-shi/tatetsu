import 'package:json_annotation/json_annotation.dart';
import 'package:tatetsu/model/entity/payment.dart';
import 'package:tatetsu/model/transport/codable.dart';

part 'payment_dto.g.dart';

@JsonSerializable()
class PaymentDto implements Codable {
  final String ttl;
  final String pN;
  final double prc;
  final Map<String, bool> ons;

  PaymentDto({
    required this.ttl,
    required this.pN,
    required this.prc,
    required this.ons,
  });

  PaymentDto.fromPayment(Payment payment)
      : ttl = payment.title,
        pN = payment.payer.displayName,
        prc = payment.price,
        ons = payment.owners
            .map((key, value) => MapEntry(key.displayName, value));

  factory PaymentDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PaymentDtoToJson(this);
}
