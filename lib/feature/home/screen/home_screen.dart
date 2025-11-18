import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/core/utils/constants/icon_path.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/home/widget/home_header_widget.dart';
import 'package:service_connect/feature/home/screen/all_categories_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeaderWidget(controller: controller),
            SizedBox(height: 26.h,),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 26.h),
                  Text("All Catagories",style: GoogleFonts.roboto ( 
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xff252525),
                  ),),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Get.to(() => AllCategoriesScreen()),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "See All",
                          style: GoogleFonts.roboto(
                            color: Color(0xffCC0000),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14.sp,
                          color: Color(0xffCC0000),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 16.h,),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 90.w,
                    height: 91.h,
                    decoration: BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(19.r),
                    ),
                    child: Center(
                      child: Image(image: AssetImage(IconPath.plumber),width: 55.w,fit: BoxFit.cover,),
                    ),
                  ),
                  Container(
                    width: 90.w,
                    height: 91.h,
                    decoration: BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(19.r),
                    ),
                    child: Center(
                      child: Image(image: AssetImage(IconPath.painting),width: 55.w,fit: BoxFit.cover,),
                    ),
                  ),
                  Container(
                    width: 90.w,
                    height: 91.h,
                    decoration: BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(19.r),
                    ),
                    child: Center(
                      child: Image(image: AssetImage(IconPath.repairing),width: 55.w,fit: BoxFit.cover,),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 37.h,),
              Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 26.h),
                  Text("All Catagories",style: GoogleFonts.roboto ( 
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xff252525),
                  ),),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Get.to(() => AllCategoriesScreen()),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "See All",
                          style: GoogleFonts.roboto(
                            color: Color(0xffCC0000),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14.sp,
                          color: Color(0xffCC0000),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
        
          ],
        ),
      ),
    );
  }
}