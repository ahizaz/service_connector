import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/core/utils/constants/colors.dart';
import 'package:service_connect/core/utils/constants/icon_path.dart';
import 'package:service_connect/core/utils/constants/image_path.dart';
import 'package:service_connect/feature/splash_screen/screen/second_splash_screen.dart';
import 'package:service_connect/feature/splash_screen/screen/secondonboardingscreen.dart';


class OnboadringScreen extends StatelessWidget {
  const OnboadringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
          body: Stack(
           children: [
            SizedBox.expand(
              child: Image.asset(
                ImagePath.onboadringScreen,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(bottom: 40,left: 20,right: 20,child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
              TextButton(onPressed: (){
            Get.to(()=>SecondSplashScreen());
              }, child: Text("Skip",style:GoogleFonts.roboto(
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xffCC0000)
                
              ),)),
              InkWell(
                onTap: (){
                  Get.to(()=>Secondonboardingscreen());
                },
                child: Container(
                  width: 55.w,
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: Color(0xffCC0000),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(child: Image.asset(IconPath.right,height: 24.h,width: 24.w,fit: BoxFit.cover,),),
                ),
              )
              
              
             ], 
            ),
            
            
            )
           ],
          )

    );
  }
}