// lib/features/cart/presentation/providers/cart_provider.dart

import 'package:flutter/material.dart';
import 'package:ecom_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ecom_app/features/cart/data/models/cart_item_model.dart';
import 'package:ecom_app/features/cart/data/repositories/cart_repository.dart';

enum CartState { initial, loading, loaded, error }

class CartProvider extends ChangeNotifier {
  final CartRepository _repo;
  final AuthProvider _auth;

  CartProvider(this._repo, this._auth);

  CartState _state = CartState.initial;
  String? _errorMessage;
  List<CartItemModel> _cartItems = [];

  // ====================== GETTERS ======================
  CartState get state => _state;
  String? get errorMessage => _errorMessage;
  List<CartItemModel> get cartItems => _cartItems;

  bool get isLoading => _state == CartState.loading;
  bool get isEmpty => _cartItems.isEmpty;

  /// Total quantity of all items
  int get totalItems =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  /// Alias used in CartScreen
  int get cartCount => totalItems;

  /// Subtotal (price × quantity)
  double get subTotal {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  /// Shipping logic
  double get shipping {
    if (_cartItems.isEmpty) return 0;
    if (subTotal >= 50) return 0; // Free shipping over $50
    return 2.50;
  }

  /// Discount (can be improved later with coupons)
  double get discount => 0.0;

  /// Final total
  double get totalPrice => subTotal + shipping - discount;

  // ====================== LOAD CART ======================
  Future<void> loadCart() async {
    final userId = _auth.user?.id;
    if (userId == null) {
      _cartItems = [];
      _state = CartState.loaded;
      notifyListeners();
      return;
    }

    _state = CartState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _cartItems = await _repo.getCartItems(userId);
      _state = CartState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = CartState.error;
    }

    notifyListeners();
  }

  // ====================== ADD TO CART ======================
  Future<void> addToCart(String productId, {int quantity = 1}) async {
    final userId = _auth.user?.id;
    if (userId == null) return;

    try {
      await _repo.addToCart(
        userId: userId,
        productId: productId,
        quantity: quantity,
      );
      await loadCart();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // ====================== UPDATE QUANTITY ======================
  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      final item = _cartItems.firstWhere(
        (e) => e.productId == productId,
      );

      await _repo.updateQuantity(
        cartItemId: item.id,
        quantity: quantity,
      );
      await loadCart();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> increaseQuantity(String productId) async {
    final item = _cartItems.firstWhere((e) => e.productId == productId);
    await updateQuantity(productId, item.quantity + 1);
  }

  Future<void> decreaseQuantity(String productId) async {
    final item = _cartItems.firstWhere((e) => e.productId == productId);

    if (item.quantity <= 1) {
      await removeFromCart(productId);
    } else {
      await updateQuantity(productId, item.quantity - 1);
    }
  }

  // ====================== REMOVE ======================
  Future<void> removeFromCart(String productId) async {
    try {
      final item = _cartItems.firstWhere((e) => e.productId == productId);

      await _repo.removeFromCart(item.id);
      await loadCart();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // ====================== CLEAR ======================
  Future<void> clearCart() async {
    final userId = _auth.user?.id;
    if (userId == null) return;

    try {
      await _repo.clearCart(userId);
      _cartItems = [];
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}