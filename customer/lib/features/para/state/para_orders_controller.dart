import 'package:customer/features/para/data/models/para_order_model.dart';
import 'package:customer/features/para/data/repositories/para_orders_repository.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// GetX Controller for Orders
class ParaOrdersController extends GetxController {
  final ParaOrdersRepository _repository = ParaOrdersRepository();

  // State
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<ParaOrderModel> orders = <ParaOrderModel>[].obs;
  final Rxn<ParaOrderModel> selectedOrder = Rxn<ParaOrderModel>();
  final RxList<ParaOrderItemModel> selectedOrderItems = <ParaOrderItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  /// Load user orders
  Future<void> loadOrders() async {
    final uid = FireStoreUtils.getCurrentUid();
    if (uid == null) {
      orders.clear();
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';
      final userOrders = await _repository.getUserOrders(uid);
      orders.value = userOrders;
    } catch (e) {
      error.value = 'Failed to load orders: $e';
      Get.snackbar('Error', error.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Load order details
  Future<void> loadOrderDetails(String orderId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final order = await _repository.getOrder(orderId);
      selectedOrder.value = order;

      if (order != null) {
        final items = await _repository.getOrderItems(orderId);
        selectedOrderItems.value = items;
      }
    } catch (e) {
      error.value = 'Failed to load order details: $e';
      Get.snackbar('Error', error.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Get status color
  Color getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.purple;
      case 'delivering':
        return Colors.teal;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Get status text
  String getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'preparing':
        return 'Preparing';
      case 'delivering':
        return 'Delivering';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}

