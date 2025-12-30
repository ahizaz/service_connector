import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';
import 'package:service_connect/core/common/widgets/custom_button.dart';
import 'package:service_connect/core/common/widgets/custom_textField.dart';
import 'package:service_connect/core/common/widgets/custom_password_field.dart';
import 'package:service_connect/core/utils/constants/image_path.dart';
import 'package:service_connect/feature/authentication/login/screen/login_screen.dart';
import 'package:service_connect/feature/authentication/sign_up/controller/signup_controller.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignUpController>();
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Center(
                child: Image(
                  image: AssetImage(ImagePath.logo),
                  width: 190.w,
                  height: 70.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "Create your Account",
                style: AppTextStyles.robotoRegular(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff313131),
                ),
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 40.h, top: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Full Name",
                        style: AppTextStyles.robotoRegular(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff313131),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextfield(
                        hintText: "Enter your full name",
                        controller: controller.nameController,
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Email Address",
                        style: AppTextStyles.robotoRegular(
                          fontSize: 16.sp,
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
                          fontSize: 16.sp,
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
                      Text(
                        "Confirm Password",
                        style: AppTextStyles.robotoRegular(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff313131),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Obx(
                        () => CustomPasswordField(
                          hintText: "Re-type your password",
                          controller: controller.confimPasswordController,
                          obscureText: !controller.isConfirmPasswordVisible.value,
                          onToggle: controller.toggleConfirmPasswordVisibility,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Obx(
                        () => CustomButton(
                          text: "SignUp",
                          onTap: () async {
                            await controller.signUp();
                          },
                          enabled: controller.isSignUpEnabled.value,
                        ),
                      ),
                      SizedBox(height: 16.h),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}