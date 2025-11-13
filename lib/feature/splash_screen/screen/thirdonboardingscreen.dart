import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/core/utils/constants/colors.dart';
import 'package:service_connect/core/utils/constants/image_path.dart';
import 'package:service_connect/feature/splash_screen/screen/last_onboarding_screen.dart';

class Thirdonboardingscreen extends StatelessWidget {
  const Thirdonboardingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(
              ImagePath.thirdonboardingscreen,
              fit: BoxFit.cover,
            ),
          ),

          // Button Container at Bottom
          Positioned(
            bottom: 40, // distance from bottom
            left: 20,
            right: 20,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () {
                Get.to(()=>LastOnboardingScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffCC0000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:  Text(
                  "Get Started",
                  style:GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffFFFFFF)
                  )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
