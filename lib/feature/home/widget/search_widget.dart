import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';

class SearchWidget extends StatelessWidget {
  final HomeController controller;
  
  const SearchWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: TextField(
        controller: controller.searchController,
        focusNode: controller.searchFocusNode,
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          hintText: "Search for plumber, electrician...",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }
}
