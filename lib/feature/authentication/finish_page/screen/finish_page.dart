import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';
import 'package:service_connect/core/common/widgets/custom_button.dart';
import 'package:service_connect/core/utils/constants/image_path.dart';

class FinishPage extends StatelessWidget {
  const FinishPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff313131),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: Color(0xffF5F5F5),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
               SizedBox(height: 98.h),
                 Center(
                  child: Image(
                    image: AssetImage(ImagePath.logo),
                    width: 190.w,
                    height: 70.h,
                    fit: BoxFit.cover,
                  ),
                ),
                 SizedBox(height: 98.h),
                   Center(
                  child: Image(
                    image: AssetImage(ImagePath.applogo),
                    width: 143.w,
                    height: 143.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 24.h,),
                Text("Welcome to Chiripa",style: AppTextStyles.robotoRegular(
                    fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff313131),
                ),),
                SizedBox(height: 12.h,),
                Center(child: Text("Welcome to Chiripa, a vibrant and",style: AppTextStyles.robotoRegular(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff737373)
                ),)),
                SizedBox(height: 6.h,),
                  Center(child: Text("enchanting place where the beauty of nature",style: AppTextStyles.robotoRegular(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff737373)
                ),)),
                SizedBox(height: 55.h,),
                CustomButton(text: "Continue", onTap:(){
     
                } )



        
          ],
        ),
      ),
    );
  }
}