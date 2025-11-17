import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/core/common/widgets/custom_button.dart';
import 'package:service_connect/core/utils/constants/image_path.dart';
import 'package:service_connect/feature/authentication/login/screen/login_screen.dart';

class PasswordChange extends StatelessWidget {
  const PasswordChange({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
         appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          SizedBox(height: 208.h,),
             Center(
                  child: Image(
                    image: AssetImage(ImagePath.applogo),
                    width: 143.w,
                    height: 143.h,
                    fit: BoxFit.cover,
                  ),
                ),
                   SizedBox(height: 24.h,),
                   Center(
                    child: Text("Password Change",style: GoogleFonts.roboto( 
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff313131)
                    ),),
                   ),
                   SizedBox(height: 12.h,),
                   Center(
                    child: Text("Your password has been changed\n            successfully",style: GoogleFonts.roboto( 
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff737373)
                    ),),
                   ),
                   SizedBox(height: 55.h,),
                   CustomButton(text: "Continue", onTap: (){
                    Get.to(()=>LoginScreen());
                   }),
        ],
      ),
      ),
    );
  }
}