import 'dart:convert';

import 'package:tatetsu/model/transport/account_detail_dto.dart';
import 'package:tatetsu/model/transport/payment_dto.dart';
import 'package:test/test.dart';

void main() {
  group('AccountDetailDto', () {
    test('toJson_全属性が空の時、全属性が空', () {
      expect(
        AccountDetailDto(pNm: [], ps: []).toJson(),
        {"pNm": [], "ps": []},
      );
    });

    test('toJson_参加者1人の時、pNmに対象の参加者1名が含まれている', () {
      expect(
        AccountDetailDto(pNm: ["suzuki"], ps: []).toJson(),
        {
          "pNm": ["suzuki"],
          "ps": []
        },
      );
    });

    test('toJson_参加者2人の時、pNmに対象の参加者2名が含まれている', () {
      expect(
        AccountDetailDto(pNm: ["suzuki", "tanaka"], ps: []).toJson(),
        {
          "pNm": ["suzuki", "tanaka"],
          "ps": []
        },
      );
    });

    test('toJson_参加者3人の時、pNmに対象の参加者3名が含まれている', () {
      expect(
        AccountDetailDto(pNm: ["suzuki", "tanaka", "sato"], ps: []).toJson(),
        {
          "pNm": ["suzuki", "tanaka", "sato"],
          "ps": []
        },
      );
    });

    test('toJson_会計1つの時、psに対象の会計1件が含まれている', () {
      expect(
          jsonDecode(
            jsonEncode(
              AccountDetailDto(
                pNm: ["suzuki", "tanaka", "sato"],
                ps: [
                  PaymentDto(
                    ttl: "会計タイトル",
                    pN: "sato",
                    prc: 49800,
                    ons: {"suzuki": true, "tanaka": true, "sato": true},
                  )
                ],
              ).toJson(),
            ),
          ) as Map<String, dynamic>,
          {
            "pNm": ["suzuki", "tanaka", "sato"],
            "ps": [
              {
                "ttl": "会計タイトル",
                "pN": "sato",
                "prc": 49800,
                "ons": {"suzuki": true, "tanaka": true, "sato": true}
              }
            ]
          });
    });

    test('toJson_会計2つの時、psに対象の会計2件が含まれている', () {
      expect(
          jsonDecode(
            jsonEncode(
              AccountDetailDto(
                pNm: ["suzuki", "tanaka", "sato"],
                ps: [
                  PaymentDto(
                    ttl: "会計タイトル",
                    pN: "sato",
                    prc: 49800,
                    ons: {"suzuki": true, "tanaka": true, "sato": true},
                  ),
                  PaymentDto(
                    ttl: "会計タイトル2",
                    pN: "tanaka",
                    prc: 7980,
                    ons: {"suzuki": true, "tanaka": false, "sato": true},
                  )
                ],
              ).toJson(),
            ),
          ) as Map<String, dynamic>,
          {
            "pNm": ["suzuki", "tanaka", "sato"],
            "ps": [
              {
                "ttl": "会計タイトル",
                "pN": "sato",
                "prc": 49800,
                "ons": {"suzuki": true, "tanaka": true, "sato": true}
              },
              {
                "ttl": "会計タイトル2",
                "pN": "tanaka",
                "prc": 7980,
                "ons": {"suzuki": true, "tanaka": false, "sato": true}
              }
            ]
          });
    });

    test('toJson_支払い参加者と支払い対象者が異なる不正な会計も変換される', () {
      expect(
          jsonDecode(
            jsonEncode(
              AccountDetailDto(
                pNm: ["imai", "nakagawa"],
                ps: [
                  PaymentDto(
                    ttl: "会計タイトル",
                    pN: "sato",
                    prc: 49800,
                    ons: {"takano": true, "nakagi": true, "yamao": true},
                  )
                ],
              ).toJson(),
            ),
          ) as Map<String, dynamic>,
          {
            "pNm": ["imai", "nakagawa"],
            "ps": [
              {
                "ttl": "会計タイトル",
                "pN": "sato",
                "prc": 49800,
                "ons": {"takano": true, "nakagi": true, "yamao": true}
              }
            ]
          });
    });

    test('fromJson_参加者1人の時、pNmに対象の参加者1名が含まれている', () {
      expect(
        AccountDetailDto.fromJson({
          "pNm": ["suzuki"],
          "ps": []
        }).pNm,
        ["suzuki"],
      );
    });

    test('fromJson_参加者2人の時、pNmに対象の参加者2名が含まれている', () {
      expect(
        AccountDetailDto.fromJson({
          "pNm": ["suzuki", "tanaka"],
          "ps": []
        }).pNm,
        ["suzuki", "tanaka"],
      );
    });

    test('fromJson_参加者3人の時、pNmに対象の参加者3名が含まれている', () {
      expect(
        AccountDetailDto.fromJson({
          "pNm": ["suzuki", "tanaka", "sato"],
          "ps": []
        }).pNm,
        ["suzuki", "tanaka", "sato"],
      );
    });

    test('fromJson_会計1つの時、psに対象の会計1件が含まれている', () {
      expect(
        AccountDetailDto.fromJson({
          "pNm": ["suzuki", "tanaka", "sato"],
          "ps": [
            {
              "ttl": "会計タイトル1",
              "pN": "sato",
              "prc": 47800,
              "ons": {"suzuki": true, "tanaka": true, "sato": true}
            }
          ]
        }).ps[0].ttl,
        "会計タイトル1",
      );
    });

    test('fromJson_会計2つの時、psに対象の会計が含まれている', () {
      expect(
        AccountDetailDto.fromJson({
          "pNm": ["suzuki", "tanaka", "sato"],
          "ps": [
            {
              "ttl": "会計タイトル1",
              "pN": "sato",
              "prc": 47800,
              "ons": {"suzuki": true, "tanaka": true, "sato": true}
            },
            {
              "ttl": "会計タイトル2",
              "pN": "tanaka",
              "prc": 7980,
              "ons": {"suzuki": true, "tanaka": true, "sato": true}
            }
          ]
        }).ps[1].ttl,
        "会計タイトル2",
      );
    });

    test('fromJson_支払い参加者と支払い対象者が異なる不正な会計も変換される', () {
      expect(
        AccountDetailDto.fromJson({
          "pNm": ["imai", "nakagawa"],
          "ps": [
            {
              "ttl": "会計タイトル",
              "pN": "sato",
              "prc": 47800,
              "ons": {"takano": true, "nakagi": true, "yamao": true},
            }
          ]
        }).ps[0].ttl,
        "会計タイトル",
      );
    });
  });
}
