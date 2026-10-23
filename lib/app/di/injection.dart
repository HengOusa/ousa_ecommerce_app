import 'package:ecom_app/features/auth/data/repositories/auth_repository.dart';
import 'package:ecom_app/features/cart/data/repositories/cart_repository.dart';
import 'package:ecom_app/features/product/data/repositories/product_repository.dart';

/// Central place to create and hold all repositories.
/// Call [Injection.init()] only once in main().
class Injection {
  Injection._(); // private constructor

  // ========== REPOSITORIES ==========
  static late final AuthRepository authRepository;
  static late final ProductRepository productRepository;
  static late final CartRepository cartRepository;
  // static late final OrderRepository orderRepository;
  // static late final FavoriteRepository favoriteRepository;
  // static late final CategoryRepository categoryRepository;

  /// Initialize all repositories.
  /// Must be called before runApp().
  static void init() {
    authRepository = AuthRepository();
    productRepository = ProductRepository();
    cartRepository = CartRepository();
    // orderRepository = OrderRepository();
    // favoriteRepository = FavoriteRepository();
    // categoryRepository = CategoryRepository();
  }
}
