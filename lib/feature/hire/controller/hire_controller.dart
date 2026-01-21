import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:service_connect/feature/home/repository/provider_repositroy.dart';
import 'package:service_connect/feature/home/model/hiring_list_model.dart';

class HireController extends GetxController {
  final ProviderRepository _providerRepository = ProviderRepository();

  // Observable for selected tab
  var selectedTab = 0.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Hiring list data from API
  final RxList<HiringListModel> allHiringList = <HiringListModel>[].obs;

  // Filtered lists based on order status
  List<HiringListModel> get activeOrders =>
      allHiringList.where((order) => order.isActive).toList();

  List<HiringListModel> get completedOrders =>
      allHiringList.where((order) => order.isCompleted).toList();

  List<HiringListModel> get cancelledOrders =>
      allHiringList.where((order) => order.isCancelled).toList();

  // Total statistics
  int get totalHire => allHiringList.length;
  double get totalSpend {
    double total = 0.0;
    for (var order in allHiringList) {
      total += double.tryParse(order.serviceCost) ?? 0.0;
    }
    return total;
  }

  @override
  void onInit() {
    super.onInit();
    fetchHiringList();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Fetch hiring list from API
  Future<void> fetchHiringList() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Loading hiring list...');

      debugPrint('=================================');
      debugPrint('HireController: Starting to fetch hiring list');
      debugPrint('=================================');

      final hiringList = await _providerRepository.getHiringList();

      debugPrint('=================================');
      debugPrint('HireController: Hiring list fetched successfully');
      debugPrint('Total records: ${hiringList.length}');
      debugPrint('Active orders: ${hiringList.where((o) => o.isActive).length}');
      debugPrint('Completed orders: ${hiringList.where((o) => o.isCompleted).length}');
      debugPrint('Cancelled orders: ${hiringList.where((o) => o.isCancelled).length}');
      debugPrint('=================================');

      allHiringList.value = hiringList;

      EasyLoading.dismiss();
    } catch (e) {
      debugPrint('=================================');
      debugPrint('HireController: Error fetching hiring list: $e');
      debugPrint('=================================');

      EasyLoading.dismiss();
      EasyLoading.showError('Failed to load hiring list');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh hiring list
  Future<void> refreshHiringList() async {
    await fetchHiringList();
  }

  // Get orders based on selected tab
  List<HiringListModel> getOrdersByTab(int index) {
    switch (index) {
      case 0: // All
        return allHiringList;
      case 1: // Active
        return activeOrders;
      case 2: // Complete
        return completedOrders;
      case 3: // Cancelled
        return cancelledOrders;
      default:
        return allHiringList;
    }
  }
}