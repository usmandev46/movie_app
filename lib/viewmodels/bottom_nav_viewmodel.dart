import 'package:flutter/material.dart';

class BottomNavViewModel extends ChangeNotifier {
  int _currentIndex = 1;

  int get currentIndex => _currentIndex;

  void changeIndex(int index, BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
        _currentIndex = index;
        notifyListeners();
    } else {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
