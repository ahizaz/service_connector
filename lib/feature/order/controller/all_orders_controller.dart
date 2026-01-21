import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:service_connect/feature/order/model/all_orders_response_model.dart';
import 'package:service_connect/feature/order/repository/order_repository.dart';

class AllOrdersController extends GetxController {
  final OrderRepository _orderRepository = OrderRepository();

  final RxList<OrderModel> allOrders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = false.obs;
  final Rx<String?> nextPageUrl = Rx<String?>(null);
  final RxInt totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Don't auto-fetch; let the screen call it when needed
  }

  /// Fetch all orders (initial load)
  Future<void> fetchAllOrders() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Loading orders...');

      debugPrint('=================================');
      debugPrint('📥 FETCHING ALL ORDERS');
      debugPrint('=================================');

      final response = await _orderRepository.getAllOrders();

      allOrders.value = response.results;
      totalCount.value = response.count;
      nextPageUrl.value = response.next;
      hasMore.value = response.next != null;

      debugPrint('=================================');
      debugPrint('✅ ORDERS FETCHED SUCCESSFULLY');
      debugPrint('Total Count: ${response.count}');
      debugPrint('Orders Loaded: ${response.results.length}');
      debugPrint('Has More: ${response.next != null}');
      debugPrint('=================================');

      EasyLoading.dismiss();
      isLoading.value = false;
    } catch (e) {
      debugPrint('❌ Error fetching orders: $e');
      EasyLoading.dismiss();
      isLoading.value = false;

      Get.snackbar(
        'Error',
        'Failed to load orders: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Load more orders (pagination)
  Future<void> loadMoreOrders() async {
    if (!hasMore.value || nextPageUrl.value == null || isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;

      debugPrint('=================================');
      debugPrint('📥 LOADING MORE ORDERS');
      debugPrint('Next URL: ${nextPageUrl.value}');
      debugPrint('=================================');

      final response = await _orderRepository.getOrdersWithPagination(
        nextPageUrl.value!,
      );

      allOrders.addAll(response.results);
      nextPageUrl.value = response.next;
      hasMore.value = response.next != null;

      debugPrint('=================================');
      debugPrint('✅ MORE ORDERS LOADED');
      debugPrint('Total Orders Now: ${allOrders.length}');
      debugPrint('Has More: ${response.next != null}');
      debugPrint('=================================');

      isLoading.value = false;
    } catch (e) {
      debugPrint('❌ Error loading more orders: $e');
      isLoading.value = false;

      Get.snackbar(
        'Error',
        'Failed to load more orders: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Refresh orders (pull to refresh)
  Future<void> refreshOrders() async {
    try {
      debugPrint('=================================');
      debugPrint('🔄 REFRESHING ORDERS');
      debugPrint('=================================');

      final response = await _orderRepository.getAllOrders();

      allOrders.value = response.results;
      totalCount.value = response.count;
      nextPageUrl.value = response.next;
      hasMore.value = response.next != null;

      debugPrint('=================================');
      debugPrint('✅ ORDERS REFRESHED');
      debugPrint('=================================');
    } catch (e) {
      debugPrint('❌ Error refreshing orders: $e');

      Get.snackbar(
        'Error',
        'Failed to refresh orders: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Get recent orders (first 3 for home widget)
  List<OrderModel> getRecentOrders() {
    return allOrders.take(3).toList();
  }
}
