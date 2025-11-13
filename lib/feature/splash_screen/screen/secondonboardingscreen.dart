import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/core/utils/constants/colors.dart';
import 'package:service_connect/core/utils/constants/icon_path.dart';
import 'package:service_connect/core/utils/constants/image_path.dart';
import 'package:service_connect/feature/splash_screen/screen/thirdonboardingscreen.dart';

class Secondonboardingscreen extends StatelessWidget {
  const Secondonboardingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // ছবির ওপর ট্রান্সপারেন্ট বার
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black, // প্রয়োজন হলে Colors.white দিতে পারো
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Stack(
        children: [
          /// Background Image
          SizedBox.expand(
            child: Image.asset(
              ImagePath.secondOnboardingScreen,
              fit: BoxFit.cover,
            ),
          ),

          /// Bottom Buttons
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Skip button
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    "Skip",
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffCC0000),
                    ),
                  ),
                ),

                /// Continue button
                InkWell(
                  onTap: () {
                 Get.to(()=>Thirdonboardingscreen());
                  },
                  child: Container(
                    width: 55.w,
                    height: 55.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffCC0000),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(child: Image.asset(IconPath.right,height: 24.h,width: 24.w,fit: BoxFit.cover,),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
