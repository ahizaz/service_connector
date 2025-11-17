import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';
import 'package:service_connect/feature/authentication/reset_password/controller/reset_controller.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetController());
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
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
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Center(
              child: Text(
                "Reset Password",
                style: GoogleFonts.roboto(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff313131),
                ),
              ),
            ),
            SizedBox(height: 48.h),
            
            // New Password Field
            Text(
              "New Password",
              style: AppTextStyles.robotoRegular(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            Obx(() => TextField(
              controller: controller.newPasswordController,
              obscureText: !controller.isNewPasswordVisible.value,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                hintStyle: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  color: const Color(0xff9E9E9E),
                ),
                filled: true,
                fillColor: const Color(0xffF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isNewPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xff9E9E9E),
                  ),
                  onPressed: controller.toggleNewPasswordVisibility,
                ),
              ),
            )),
            
            SizedBox(height: 24.h),
            
            // Confirm Password Field
            Text(
              "Confirm Password",
              style: AppTextStyles.robotoRegular(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            Obx(() => TextField(
              controller: controller.confirmPasswordController,
              obscureText: !controller.isConfirmPasswordVisible.value,
              decoration: InputDecoration(
                hintText: 'Re-type your password',
                hintStyle: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  color: const Color(0xff9E9E9E),
                ),
                filled: true,
                fillColor: const Color(0xffF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isConfirmPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xff9E9E9E),
                  ),
                  onPressed: controller.toggleConfirmPasswordVisibility,
                ),
              ),
            )),
            
            SizedBox(height: 32.h),
            
            // Reset Password Button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: controller.resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffD32F2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Reset Password',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}