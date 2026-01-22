import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:service_connect/feature/order/model/all_orders_response_model.dart';
import 'package:service_connect/feature/order/widget/order_in_row.dart';
import 'package:service_connect/feature/review/screen/give_review_screen.dart';

class CompletedOrderCard extends StatelessWidget {
  final OrderModel order;
  final String? fallbackProviderUserId;
  const CompletedOrderCard({
    super.key,
    required this.order,
    this.fallbackProviderUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
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
                'Order #${order.orderId}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          OrderInRow(
            icon: Icons.category,
            label: 'Category',
            value: order.categoryName,
          ),
          SizedBox(height: 8.h),
          OrderInRow(
            icon: Icons.person,
            label: 'Provider',
            value: order.providerName,
          ),
          SizedBox(height: 8.h),
          OrderInRow(
            icon: Icons.attach_money,
            label: 'Service Cost',
            value: '\$${order.serviceCost}',
          ),
          SizedBox(height: 8.h),
          OrderInRow(
            icon: Icons.calendar_today,
            label: 'Completed',
            value: DateFormatter.formatDate(order.completedAt ?? ''),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: () {
              debugPrint('=================================');
              debugPrint('Give review button clicked');
              debugPrint('Order ID: ${order.orderId}');
              debugPrint('Provider UUID from order: ${order.providerUserUuid}');
              debugPrint('Fallback Provider UUID: $fallbackProviderUserId');
              debugPrint('=================================');

              // Use provider UUID from order, or fallback to chat user ID
              final providerUuid =
                  order.providerUserUuid ?? fallbackProviderUserId;

              if (providerUuid == null || providerUuid.isEmpty) {
                debugPrint('❌ Provider UUID is missing');
                Get.snackbar(
                  'Error',
                  'Provider information is missing',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              debugPrint('✅ Using Provider UUID: $providerUuid');

              Get.to(
                () => GiveReviewScreen(
                  providerUserUuid: providerUuid,
                  orderId: order.orderId,
                  providerName: order.providerName,
                  categoryName: order.categoryName,
                  serviceCost: order.serviceCost,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0066FF),
              minimumSize: Size(double.infinity, 44.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Give Review',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
