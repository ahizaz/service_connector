import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_connect/feature/profile/controller/profile_controller.dart';

class Menulist extends StatelessWidget {
    final ProfileController controller;
  const Menulist({super.key,required this.controller});

   @override
  Widget build(BuildContext context) {
    return Column(
      children: controller.menuItems.map((item) {
        return _MenuTile(
          icon: item['icon'],
          title: item['title'],
          onTap: item['onTap'],
        );
      }).toList(),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: const Color(0xffF5F5F5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 24.sp, color: Colors.black),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 24.sp),
      ),
    );
  }
}
