import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/home/widget/home_header_widget.dart';
import 'package:service_connect/feature/home/widget/categories_list_widget.dart';
import 'package:service_connect/feature/home/widget/top_rated_professionals_widget.dart';
import 'package:service_connect/feature/home/widget/provider_dashboard_widget.dart';
import 'package:service_connect/feature/home/widget/recent_orders_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    // Reload mode when screen becomes visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.reloadMode();
    });

    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      body: Obx(() => controller.isServiceProvider.value
          ? _buildServiceProviderHome(controller)
          : _buildServiceReceiverHome(controller)),
    );
  }

  // Service Receiver Home (original)
  Widget _buildServiceReceiverHome(HomeController controller) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HomeHeaderWidget(controller: controller),
          CategoriesListWidget(controller: controller),
          TopRatedProfessionalsWidget(controller: controller),
        ],
      ),
    );
  }

  // Service Provider Home (new)
  Widget _buildServiceProviderHome(HomeController controller) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HomeHeaderWidget(controller: controller),
          ProviderDashboardWidget(),
          RecentOrdersWidget(),
        ],
      ),
    );
  }
}
