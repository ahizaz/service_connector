import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_connect/feature/hire/controller/hire_controller.dart';

class HireScreen extends StatelessWidget {
  const HireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HireController controller = Get.put(HireController());
    
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
            color: Colors.white,
            child: TabBar(
              controller: controller.tabController,
              labelColor: const Color(0xff1C59D2),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xff1C59D2),
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Active'),
                Tab(text: 'Complete'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
          
          // Tab View
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _buildOrderList(controller, 0),
                _buildOrderList(controller, 1),
                _buildOrderList(controller, 2),
                _buildOrderList(controller, 3),
              ],
            ),
          ),
        ],
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
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  color: statusColor.withOpacity(0.1),
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
    );
  }
}