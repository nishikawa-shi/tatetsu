import 'package:json_annotation/json_annotation.dart';

part 'payment_dto.g.dart';

@JsonSerializable()
class PaymentDto {
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

  factory PaymentDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDtoToJson(this);
}
