import 'package:json_annotation/json_annotation.dart';
import 'package:tatetsu/model/transport/codable.dart';
import 'package:tatetsu/model/transport/payment_dto.dart';

part 'account_detail_dto.g.dart';

@JsonSerializable()
class AccountDetailDto implements Codable {
  AccountDetailDto({required this.pNm, required this.ps});

  final List<String> pNm;
  final List<PaymentDto> ps;

  factory AccountDetailDto.fromJson(Map<String, dynamic> json) =>
      _$AccountDetailDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AccountDetailDtoToJson(this);
}
