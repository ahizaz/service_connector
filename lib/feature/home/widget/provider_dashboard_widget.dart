import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';

class ProviderDashboardWidget extends StatelessWidget {
  const ProviderDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Obx(() {
      return Column(
        children: [
          SizedBox(height: 26.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: .08),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Earning',
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff222222),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available withdraw',
                              style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                color: Color(0xff6B6B6B),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              '\$${controller.availableWithdraw.value.toStringAsFixed(0)}',
                              style: GoogleFonts.roboto(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                                color: Color(0xff27AE60),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Earning in October',
                              style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                color: Color(0xff6B6B6B),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              '\$${controller.earningInMonth.value.toStringAsFixed(0)}',
                              style: GoogleFonts.roboto(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff222222),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Active Hire',
                              style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                color: Color(0xff6B6B6B),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              controller.activeHire.value.toString(),
                              style: GoogleFonts.roboto(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff222222),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cancel Hire',
                              style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                color: Color(0xff6B6B6B),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              controller.cancelHire.value.toString(),
                              style: GoogleFonts.roboto(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff222222),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      );
    });
  }
}

// _StatCard removed — no longer used by ProviderDashboardWidget.
