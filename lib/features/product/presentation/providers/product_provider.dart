// lib/features/product/presentation/providers/product_provider.dart

import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

enum ProductState { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repo;

  ProductProvider(this._repo);

  // ── State ──────────────────────────────────────────────
  ProductState _state = ProductState.initial;
  String? _errorMessage;

  List<ProductModel> _products = [];
  List<ProductModel> _popularProducts = [];
  List<ProductModel> _bestSellers = [];

  String? _selectedCategoryId;
  String _searchQuery = '';

  // ── Getters ────────────────────────────────────────────
  ProductState get state => _state;
  String? get errorMessage => _errorMessage;

  List<ProductModel> get products => _products;
  List<ProductModel> get popularProducts => _popularProducts;
  List<ProductModel> get bestSellers => _bestSellers;

  String? get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;

  bool get isLoading => _state == ProductState.loading;
  bool get hasError => _state == ProductState.error;

  // ── Methods ────────────────────────────────────────────

  Future<void> loadInitialData() async {
    _state = ProductState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repo.getPopularProducts(limit: 10),
        _repo.getBestSellers(limit: 10),
      ]);

      _popularProducts = results[0];
      _bestSellers = results[1];
      _products = results[0]; // default

      _state = ProductState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ProductState.error;
    }

    notifyListeners();
  }

  Future<void> loadProducts({String? categoryId, String? search}) async {
    _state = ProductState.loading;
    _errorMessage = null;
    _selectedCategoryId = categoryId;
    _searchQuery = search ?? '';
    notifyListeners();

    try {
      _products = await _repo.getProducts(
        categoryId: categoryId,
        search: search,
        limit: 30,
      );
      _state = ProductState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ProductState.error;
    }

    notifyListeners();
  }

  Future<void> search(String query) async {
    await loadProducts(categoryId: _selectedCategoryId, search: query);
  }

  Future<void> filterByCategory(String? categoryId) async {
    await loadProducts(categoryId: categoryId, search: _searchQuery);
  }

  void clearFilters() {
    _selectedCategoryId = null;
    _searchQuery = '';
    loadProducts();
  }
}
