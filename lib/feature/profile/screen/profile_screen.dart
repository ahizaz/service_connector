
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

          ],
        ),
      )),
    );
  }
}