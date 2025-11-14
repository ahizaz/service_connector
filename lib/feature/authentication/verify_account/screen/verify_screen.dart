import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';
import 'package:service_connect/core/utils/constants/image_path.dart';
import 'package:service_connect/feature/authentication/verify_account/controller/verify_controller.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyController());

    final defaultPinTheme = PinTheme(
      width: 45.w,
      height: 52.h,
      textStyle: TextStyle(
        fontSize: 20.sp,
        color: const Color(0xff313131),
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xffE0E0E0),
          width: 1,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: const Color(0xffD3E9C1),
        width: 2,
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: const Color(0xffD3E9C1),
        width: 1,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
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
              SizedBox(height: 64.h),
              Text(
                "Verify Your Account",
                style: AppTextStyles.robotoRegular(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff313131),
                ),
              ),
              SizedBox(height: 40.h),
              Pinput(
                controller: controller.otpController,
                focusNode: controller.otpFocusNode,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                showCursor: true,
                onCompleted: (pin) {
                  // Auto verify when all 6 digits are entered
                  controller.verifyOtp();
                },
              ),
              SizedBox(height: 24.h),
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.verifyOtp(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffD32E28),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        disabledBackgroundColor:
                            const Color(0xffD32E28).withOpacity(0.6),
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Verify",
                              style: AppTextStyles.robotoRegular(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  )),
              SizedBox(height: 16.h),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't received code? ",
                        style: AppTextStyles.robotoRegular(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff757575),
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.canResend.value
                            ? () => controller.resendOtp()
                            : null,
                        child: Text(
                          controller.canResend.value
                              ? "Resend Now"
                              : "Resend in ${controller.resendTimer.value}s",
                          style: AppTextStyles.robotoRegular(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: controller.canResend.value
                                ? const Color(0xffD32E28)
                                : const Color(0xff757575),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}