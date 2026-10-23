import 'package:flutter/material.dart';

class BrandProvider extends ChangeNotifier {
  String? _selectedBrand;

  String? get selectedBrand => _selectedBrand;

  void selectBrand(String brandName) {
    _selectedBrand = brandName;
    notifyListeners();
  }

  void selectAll() {
    _selectedBrand = null;
    notifyListeners();
  }

  bool isSelected(String brandName) {
    return _selectedBrand == brandName;
  }
}
