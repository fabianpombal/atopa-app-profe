import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => this._currentIndex;

  set currentIndex(int index) {
    this._currentIndex = index;
    notifyListeners();
  }
}