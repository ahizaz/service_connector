import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';
import 'package:service_connect/core/common/widgets/custom_button.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/controller/provider_registration_controller.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/widgets/step_progress_indicator.dart';
import 'package:service_connect/feature/bottom_navbar/screen/bottom_navbar.dart';

class Step5WorkImages extends StatelessWidget {
  const Step5WorkImages({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProviderRegistrationController>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff313131)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Step 5 of 5',
          style: AppTextStyles.robotoRegular(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xff313131),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: const StepProgressIndicator(currentStep: 5, totalSteps: 5),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Work Images",
                    style: AppTextStyles.robotoRegular(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff313131),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Upload images of your work so customers can see examples.",
                    style: AppTextStyles.robotoRegular(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff737373),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Upload area
                  Obx(
                    () => GestureDetector(
                      onTap: () => controller.pickPortfolioImages(),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 24.h,
                          horizontal: 16.w,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xffE0E0E0),
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                        ),
                        child: controller.portfolioImages.isEmpty
                            ? Column(
                                children: [
                                  Icon(
                                    Icons.photo_library_outlined,
                                    size: 48.sp,
                                    color: const Color(0xffD32E28),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    "Add images",
                                    style: AppTextStyles.robotoRegular(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xffD32E28),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "Tap to pick images from gallery (up to device limits).",
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.robotoRegular(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff737373),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    spacing: 8.w,
                                    runSpacing: 8.h,
                                    children: controller.portfolioImages
                                        .asMap()
                                        .entries
                                        .map(
                                          (e) => Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                child: Image.file(
                                                  File(e.value.path),
                                                  width: 100.w,
                                                  height: 80.h,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                top: -6,
                                                right: -6,
                                                child: IconButton(
                                                  onPressed: () => controller
                                                      .removePortfolioImage(
                                                        e.key,
                                                      ),
                                                  icon: Container(
                                                    padding: EdgeInsets.all(
                                                      4.w,
                                                    ),
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: Colors.red,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 14.sp,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    '${controller.portfolioImages.length} image(s) selected',
                                    style: AppTextStyles.robotoRegular(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff737373),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Actions: Submit (enabled when images exist) and Skip
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Submit',
                            enabled: controller.isStep5Valid.value,
                            color: controller.isStep5Valid.value
                                ? const Color(0xffD32E28)
                                : const Color(0xffE0E0E0),
                            onTap: () async {
                              if (controller.isStep5Valid.value) {
                                await controller.uploadWorkImage();
                                Get.offAll(() => BottomNavbar());
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        SizedBox(
                          height: 48.h,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xffD32E28)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            onPressed: () async {
                              // Skip images but complete registration
                              await controller.completeRegistration();
                              Get.offAll(() => BottomNavbar());
                            },
                            child: Text(
                              'Skip',
                              style: AppTextStyles.robotoRegular(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xffD32E28),
                              ),
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
    );
  }
}
