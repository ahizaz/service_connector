
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:service_connect/feature/profile/controller/profile_controller.dart';
import 'package:service_connect/feature/profile/widget/menuList.dart';
import 'package:service_connect/feature/profile/widget/profile_header.dart';
import 'package:service_connect/feature/profile/widget/service_provide_toggle.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
           SizedBox(height: 20.h),
           ProfileHeader(controller:controller),
            SizedBox(height: 24.h),
           ServiceProvideToggle(controller:controller),
              SizedBox(height: 14.h),
              Menulist(controller:controller),
             
              GestureDetector(
                onTap: controller.logout,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: const Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.logout,
                          color: const Color(0xffCC0000),
                          size: 20.w,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff313131),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.w,
                        color: const Color(0xffBDBDBD),
                      ),
                    ],
                  ),
                ),
              ),

          ],
        ),
      )),
    );
  }
}