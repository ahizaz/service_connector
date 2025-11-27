import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_connect/feature/hire/controller/hire_controller.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/hire/screen/order_details.dart';

class HireScreen extends StatelessWidget {
  const HireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HireController controller = Get.find<HireController>();
    HomeController? homeController;
    try {
      homeController = Get.find<HomeController>();
    } catch (e) {
      homeController = null;
    }
    
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'My Orders & Spending',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Statistics Card
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('Total Hire', '${controller.totalHire} times'),
                _buildStatItem('Total Spend', '\$${controller.totalSpend.toStringAsFixed(2)}'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          // Tab Bar
          Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xffE8E8E8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(() => Row(
              children: [
                _buildTab(controller, 0, 'All'),
                _buildTab(controller, 1, 'Active'),
                _buildTab(controller, 2, 'Complete'),
                if (homeController?.isServiceProvider.value ?? false)
                  _buildTab(controller, 3, 'Cancelled'),
              ],
            )),
          ),
          
          // Tab View
          Expanded(
            child: Obx(() {
              final maxIndex = (homeController?.isServiceProvider.value ?? false) ? 3 : 2;
              if (controller.selectedTab.value > maxIndex) {
                controller.selectedTab.value = 0;
              }
              return _buildOrderList(controller, controller.selectedTab.value);
            }),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTab(HireController controller, int index, String label) {
    final isSelected = controller.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.selectedTab.value = index;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey[500],
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  
  Widget _buildOrderList(HireController controller, int tabIndex) {
    final orders = controller.getOrdersByTab(tabIndex);
    
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No orders found',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }
  
  Widget _buildOrderCard(Map<String, dynamic> order) {
    Color statusColor;
    switch (order['status']) {
      case 'Active':
        statusColor = Colors.green;
        break;
      case 'Complete':
        statusColor = const Color(0xff1C59D2);
        break;
      case 'Cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }
    
    return GestureDetector(
      onTap: () {
        Get.to(() => OrderDetailsScreen(order: order));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        order['status'],
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              order['description'],
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.attach_money,
                  size: 18,
                  color: Colors.grey[700],
                ),
                const SizedBox(width: 4),
                Text(
                  '\$${order['price'].toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 20),
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey[700],
                ),
                const SizedBox(width: 4),
                Text(
                  '${order['date']} ${order['time']}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}