import 'package:ecom_app/app/di/injection.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class RepositoryProviders {
  RepositoryProviders._();

  static List<SingleChildWidget> get providers {
    return [
      Provider.value(value: Injection.authRepository),
      Provider.value(value: Injection.productRepository),
      Provider.value(value: Injection.cartRepository),
      // Provider.value(value: Injection.orderRepository),
      // Provider.value(value: Injection.favoriteRepository),
      // Provider.value(value: Injection.categoryRepository),
    ];
  }
}
