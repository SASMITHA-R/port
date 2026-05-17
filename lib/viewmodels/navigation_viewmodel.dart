import 'package:flutter/material.dart';

class NavigationViewModel extends ChangeNotifier {
  int _activeSection = 0;
  bool _isScrolled = false;

  int get activeSection => _activeSection;
  bool get isScrolled => _isScrolled;

  void setActiveSection(int index) {
    if (_activeSection != index) {
      _activeSection = index;
      notifyListeners();
    }
  }

  void setScrolled(bool scrolled) {
    if (_isScrolled != scrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }
}
