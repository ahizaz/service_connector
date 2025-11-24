import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/home/widget/search_widget.dart';

class HomeHeaderWidget extends StatelessWidget {
  final HomeController controller;

  const HomeHeaderWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isProvider = controller.isServiceProvider.value;
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFD32F2F),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.r),
            bottomRight: Radius.circular(30.r),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Greeting column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.greetingText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            controller.userName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Notification / avatar
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: const Color(0xFFD32F2F),
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Provider-specific header (stats cards)
                if (isProvider) ...[
                  // Cards row
                  Container(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEE6B6B),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total Hire',
                                          style: TextStyle(color: Colors.white, fontSize: 12.sp),
                                        ),
                                        Obx(() => Text(
                                              '${controller.totalHire.value} times',
                                              style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Total Earing',
                                      style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                                    ),
                                    SizedBox(height: 6.h),
                                    Obx(() => Text(
                                          '\$${controller.totalEarning.value.toStringAsFixed(2)}',
                                          style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Container(
                              width: 88.w,
                              height: 88.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEE6B6B),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(() => Text(
                                        controller.providerRating.value.toStringAsFixed(1),
                                        style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold),
                                      )),
                                  SizedBox(height: 6.h),
                                  Text(
                                    'Rating',
                                    style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        // Average success rate card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEE6B6B),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Average Succeed Rate',
                                style: TextStyle(color: Colors.white, fontSize: 13.sp),
                              ),
                              Obx(() => Text(
                                    '${controller.successRate.value}%',
                                    style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Service Receiver: keep existing search widget
                  SizedBox(height: 4.h),
                  SearchWidget(controller: controller),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}
