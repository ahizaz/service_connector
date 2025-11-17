import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';
import 'package:service_connect/core/common/widgets/custom_button.dart';
import 'package:service_connect/feature/authentication/forgot_password/controller/forget_controller.dart';
import 'package:service_connect/feature/authentication/reset_password/screen/reset_password.dart';

class ForgetVerification extends StatelessWidget {
  ForgetVerification({super.key});
  
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
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 67.h),
            Text(
              "Enter Verification Code",
              style: AppTextStyles.robotoRegular(
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 12.h),
         Text("We’ve sent a reset link to your as.....m@gmail.com\n email please check your inbox ",style: GoogleFonts.roboto( 
           fontSize: 16,
           fontWeight: FontWeight.w400,
           color: Color(0xff878787)
         ),),
            SizedBox(height: 48.h),
            // OTP Input with Pinput
            Pinput(
              controller: controller.pinController,
              length: 6,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              defaultPinTheme: PinTheme(
                width: 48.w,
                height: 56.h,
                textStyle: AppTextStyles.robotoRegular(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff313131),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xffE0E0E0),
                    width: 1.5,
                  ),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 48.w,
                height: 56.h,
                textStyle: AppTextStyles.robotoRegular(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff313131),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xffCC0000),
                    width: 1.5,
                  ),
                ),
              ),
              submittedPinTheme: PinTheme(
                width: 48.w,
                height: 56.h,
                textStyle: AppTextStyles.robotoRegular(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff313131),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xffCC0000),
                    width: 1.5,
                  ),
                ),
              ),
              onChanged: (value) {
                controller.onOtpChanged(value);
              },
              onCompleted: (pin) {
                controller.onOtpCompleted(pin);
              },
            ),
            SizedBox(height: 32.h),
            Obx(() => CustomButton(
              text: "Verify",
              onTap: (){
                Get.to(()=>ResetPassword());
              },
              enabled: controller.isOtpValid.value,
              color: controller.isOtpValid.value 
                  ? const Color(0xffCC0000) 
                  : const Color(0xffE0E0E0),
            )),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't received code? ",
                  style: AppTextStyles.robotoRegular(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff505050),
                  ),
                ),
                GestureDetector(
                  onTap: controller.resendOtp,
                  child: Text(
                    "Resend Now",
                    style: AppTextStyles.robotoRegular(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xffCC0000),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}