import 'package:customer/app/models/restaurant_model.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class FoodController extends GetxController {
  final RxBool loading = false.obs;
  final RxList<RestaurantModel> featured = <RestaurantModel>[].obs;
  final RxList<RestaurantModel> top10 = <RestaurantModel>[].obs;
  final RxList<RestaurantModel> nearby = <RestaurantModel>[].obs;
  final Rxn<RestaurantModel> currentRestaurant = Rxn<RestaurantModel>();
  final RxList<MenuItemModel> currentMenu = <MenuItemModel>[].obs;

  final RxList<CartItem> cart = <CartItem>[].obs;

  void addToCart(CartItem item) {
    cart.add(item);
  }

  double get cartSubtotal => cart.fold(0, (sum, item) => sum + item.price * item.quantity);

  @override
  void onInit() {
    super.onInit();
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    loading.value = true;
    featured.value = await FireStoreUtils.getRestaurants(isFeatured: true);
    top10.value = await FireStoreUtils.getRestaurants(isTop10: true);
    nearby.value = await FireStoreUtils.getRestaurants(isNearby: true);
    loading.value = false;
  }

  Future<void> openRestaurant(RestaurantModel restaurant) async {
    currentRestaurant.value = restaurant;
    currentMenu.value = await FireStoreUtils.getMenuItems(restaurant.id);
  }
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


