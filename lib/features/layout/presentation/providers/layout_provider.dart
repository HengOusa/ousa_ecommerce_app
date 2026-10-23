import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LayoutProvider extends ChangeNotifier {
  int _currentIndex = 0;
  bool _isBottomNavVisible = true;

  int get currentIndex => _currentIndex;
  bool get isBottomNavVisible => _isBottomNavVisible;

  void changePage(int index) {
    if (_currentIndex == index) {
      // Ensure the navbar is visible when the selected tab is tapped.
      _showBottomNav();
      return;
    }

    _currentIndex = index;
    _isBottomNavVisible = true;
    notifyListeners();
  }

  void handleScrollDirection(ScrollDirection direction) {
    if (direction == ScrollDirection.reverse) {
      // Scrolling down the page: hide the navbar.
      if (_isBottomNavVisible) {
        _isBottomNavVisible = false;
        notifyListeners();
      }
    } else if (direction == ScrollDirection.forward) {
      // Scrolling up the page: show the navbar.
      if (!_isBottomNavVisible) {
        _isBottomNavVisible = true;
        notifyListeners();
      }
    }
  }

  void _showBottomNav() {
    if (!_isBottomNavVisible) {
      _isBottomNavVisible = true;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
