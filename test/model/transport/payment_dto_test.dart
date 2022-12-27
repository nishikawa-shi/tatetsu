import 'dart:convert';

import 'package:tatetsu/model/transport/payment_dto.dart';
import 'package:test/test.dart';

void main() {
  group('PaymentDto', () {
    test('toJson_属性名を維持したまま値が格納される', () {
      expect(
        jsonDecode(
          jsonEncode(
            PaymentDto(
              ttl: "会計タイトル",
              pN: "suzuki",
              prc: 76800,
              ons: {"suzuki": true, "yamamoto": true, "sato": true},
            ),
          ),
        ) as Map<String, dynamic>,
        {
          "ttl": "会計タイトル",
          "pN": "suzuki",
          "prc": 76800,
          "ons": {"suzuki": true, "yamamoto": true, "sato": true}
        },
      );
    });

    test('fromJson_属性名を維持したまま値が格納される', () {
      expect(
        PaymentDto.fromJson({
          "ttl": "会計タイトル",
          "pN": "suzuki",
          "prc": 76800,
          "ons": {"suzuki": true, "yamamoto": true, "sato": true}
        }).ttl,
        "会計タイトル",
      );
    });
  });
}
