import 'package:flutter/material.dart';
import 'package:tatetsu/config/application_meta.dart';
import 'package:tatetsu/config/core.dart';
import 'package:tatetsu/config/dev.dart' as dev;
import 'package:tatetsu/config/prd.dart' as prd;
import 'package:test/test.dart';

void main() {
  group('ApplicationMeta', () {
    test('getAppTitle_devのsetConfig実施後に実行した時、devの接尾辞のついたタイトルを返す', () {
      dev.setConfig();
      expect(getAppTitle(), equals("Tatetsu Dev"));
    });

    test('getAppTitle_prdのsetConfig実施後に実行した時、接尾辞のないタイトルを返す', () {
      prd.setConfig();
      expect(getAppTitle(), equals("Tatetsu"));
    });

    test('getAppTheme_devのsetConfig実施後に実行した時、色が赤のテーマを返す', () {
      dev.setConfig();
      expect(getAppTheme().primaryColor, Colors.red);
    });

    test('getAppTheme_prdのsetConfig実施後に実行した時、色がメインカラーのテーマを返す', () {
      prd.setConfig();
      expect(getAppTheme().primaryColor, tatetsuViolet);
    });

    test('getEntryPageTitle_devのsetConfig実施後に実行した時、devの接頭辞のついたページ名を返す', () {
      dev.setConfig();
      expect(getEntryPageTitle(), equals("[Dev] Participants"));
    });

    test('getEntryPageTitle_prdのsetConfig実施後に実行した時、接頭辞のないページ名を返す', () {
      prd.setConfig();
      expect(getEntryPageTitle(), equals("Participants"));
    });

    test('getSettleAccountsTopBannerId_devのsetConfig実施後に実行した時、AdMobのテスト広告IDを返す', () {
      dev.setConfig();
      expect(getSettleAccountsTopBannerId(), equals("ca-app-pub-3940256099942544/2934735716"));
    });
  });
}
