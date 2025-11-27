import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';
import 'package:service_connect/core/common/widgets/custom_button.dart';
import 'package:service_connect/core/common/widgets/custom_textField.dart';
import 'package:service_connect/feature/authentication/forgot_password/controller/forget_controller.dart';
import 'package:service_connect/feature/authentication/login/screen/login_screen.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final ForgetController controller = Get.find<ForgetController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
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
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 67.h),
          Text("Forgot your password?",style: AppTextStyles.robotoRegular( 
            fontSize: 32.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xff313131)
          ),),
          SizedBox(height: 12.h,),
            Text("A code will be sent to your email to help reset\npassword",style: AppTextStyles.robotoRegular( 
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff505050)
            ),),
          SizedBox(height: 48.h,),
                 Text(
                "Email Address",
                style: AppTextStyles.robotoRegular(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff313131),
                ),
              ),
              CustomTextfield(
                hintText: "Enter your email address", 
                controller: controller.emailController,
              ),
               SizedBox(height: 32.h,),
               Obx(() => CustomButton(
                text: "Send OTP", 
                onTap: controller.sendOtp,
                enabled: controller.isEmailValid.value,
                color: const Color(0xffCC0000),
               )),
               SizedBox(height: 16.h,),
                Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: AppTextStyles.robotoRegular(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff000000),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                    Get.to(()=>LoginScreen());
                      },
                      child: Text(
                        "Sign in",
                        style: AppTextStyles.robotoRegular(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xffFF5A5F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}