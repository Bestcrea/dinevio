import 'package:get/get.dart';

class FoodController extends GetxController {
  final RxList<CartItem> cart = <CartItem>[].obs;

  void addToCart(CartItem item) {
    cart.add(item);
  }

  double get cartSubtotal => cart.fold(0, (sum, item) => sum + item.price * item.quantity);
}

class CartItem {
  final String restaurant;
  final String name;
  final double price;
  final int quantity;
  final List<String> options;

  CartItem({
    required this.restaurant,
    required this.name,
    required this.price,
    required this.quantity,
    this.options = const [],
  });
}


