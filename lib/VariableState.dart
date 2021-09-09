import 'package:flutter/material.dart';

// アプリ全体で共有したい変数を管理する

class VariableState with ChangeNotifier{
  double _paddingTop = 0;

  double get paddingTop => _paddingTop;

  // main.dartのinitStateで呼び出して、各端末のSafeAreaの高さを取得
  void getMediaQueryPaddingTop (pt) {
    _paddingTop = pt;

  }
}