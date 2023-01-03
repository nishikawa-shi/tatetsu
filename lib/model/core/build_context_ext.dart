import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tatetsu/model/transport/codable.dart';

extension ContextExt on BuildContext {
  void goTo({required String path, required Codable params}) {
    go(
      Uri(
        path: path,
        queryParameters: {
          "params": json.encode(
            params.toJson(),
          )
        },
      ).toString(),
    );
  }
}
