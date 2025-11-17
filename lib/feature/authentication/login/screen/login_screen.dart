import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';
import 'package:service_connect/core/common/widgets/custom_button.dart';
import 'package:service_connect/core/common/widgets/custom_password_field.dart';
import 'package:service_connect/core/common/widgets/custom_textField.dart';
import 'package:service_connect/core/utils/constants/image_path.dart';
import 'package:service_connect/feature/authentication/forgot_password/screen/forgot_password.dart';
import 'package:service_connect/feature/authentication/login/controller/login_controller.dart';
import 'package:service_connect/feature/authentication/sign_up/screen/sign_up.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final controller = Get.put(LoginController());
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
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          bottom: 40.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Center(
              child: Image(
                image: AssetImage(ImagePath.logo),
                width: 190.w,
                height: 70.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 64.h),

            Center(
              child: Text(
                "Login to your Account",
                style: AppTextStyles.robotoRegular(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff313131),
                ),
              ),
            ),
            SizedBox(height: 48.h,),
                 Text(
                "Email Address",
                style: AppTextStyles.robotoRegular(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff313131),
                ),
              ),
                 SizedBox(height: 8.h),
                   CustomTextfield(
                hintText: "Enter your email address",
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
                 SizedBox(height: 16.h),
              Text(
                "Password",
                style: AppTextStyles.robotoRegular(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff313131),
                ),
              ),
                 SizedBox(height: 8.h),
                     Obx(
                () => CustomPasswordField(
                  hintText: "Enter your password",
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  onToggle: controller.togglePasswordVisibility,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.toggleRememberMe(!controller.rememberMe.value);
                          },
                          child: Container(
                            width: 20.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              color: controller.rememberMe.value
                                  ? const Color(0xffFF5A5F)
                                  : Colors.transparent,
                              border: Border.all(
                                color: controller.rememberMe.value
                                    ? const Color(0xffFF5A5F)
                                    : Colors.grey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: controller.rememberMe.value
                                ? Icon(
                                    Icons.check,
                                    size: 14.sp,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Remember me",
                          style: AppTextStyles.robotoRegular(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff313131),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Get.to(()=>ForgotPassword());
                    },
                    child: Text(
                      "Forget Password",
                      style: AppTextStyles.robotoRegular(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xffFF5A5F),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
                      Obx(
                () => CustomButton(
                  text: "Sign In",
                  onTap: controller.handleLogin,
                  enabled: controller.isloginEnabled.value,
                ),
              ),
                 SizedBox(height: 16.h),
                    Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Don’t have an account? ",
                      style: AppTextStyles.robotoRegular(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff000000),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                      Get.to(()=>SignUp());
                      },
                      child: Text(
                        "Sign Up",
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

          ],
        ),
      ),
    );
  }
}
