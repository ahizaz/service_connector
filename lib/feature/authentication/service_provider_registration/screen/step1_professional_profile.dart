import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';
import 'package:service_connect/core/common/widgets/custom_button.dart';
import 'package:service_connect/core/common/widgets/custom_textField.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/controller/provider_registration_controller.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/widgets/step_progress_indicator.dart';

class Step1ProfessionalProfile extends StatelessWidget {
  const Step1ProfessionalProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProviderRegistrationController(), permanent: true);

    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
       backgroundColor: const Color(0xffFFFFFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff313131)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Step 1 of 4',
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
          // Step Progress Indicator
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: const StepProgressIndicator(currentStep: 1),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's set up your\nprofessional profile.",
              style: AppTextStyles.robotoRegular(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Tell us about your skills and experience so we can\nconnect you with clients.",
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xff737373),
              ),
            ),
            SizedBox(height: 32.h),
            
            // Profile Image Upload
            Center(
              child: GestureDetector(
                onTap: controller.pickProfileImage,
                child: Obx(() => Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xffE0E0E0), width: 2),
                    image: controller.profileImage.value != null
                        ? DecorationImage(
                            image: FileImage(controller.profileImage.value!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: controller.profileImage.value == null
                      ? Icon(
                          Icons.add_a_photo,
                          size: 40.sp,
                          color: const Color(0xff9E9E9E),
                        )
                      : null,
                )),
              ),
            ),
            SizedBox(height: 8.h),
            Center(
              child: Text(
                "Upload Profile Image",
                style: AppTextStyles.robotoRegular(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff737373),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            
            // Full Name
            Text(
              "Full Name",
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextfield(
              controller: controller.fullNameController,
              hintText: "Enter your full name",
            ),
            SizedBox(height: 20.h),
            
            // Profile Description
            Text(
              "Profile Description",
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextfield(
              controller: controller.professionController,
              hintText: "Enter your profile description",
            ),
            SizedBox(height: 20.h),
            Text(
              "Upload Working Image",
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: controller.pickPortfolioImages,
              child: Container(
               width: double.infinity,
               height: 112.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF9F9F9),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: const Color(0xffE0E0E0),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: 48.sp,
                      color: const Color(0xffBDBDBD),
                    ),
                    SizedBox(height: 12.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Click to upload',
                            style: AppTextStyles.robotoRegular(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff2196F3),
                            ),
                          ),
                          TextSpan(
                            text: ' or drag and drop',
                            style: AppTextStyles.robotoRegular(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff737373),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "JPG, JPEG, PNG files less than 1MB",
                      style: AppTextStyles.robotoRegular(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff9E9E9E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
           
            SizedBox(height: 12.h),
            Obx(() => controller.portfolioImages.isNotEmpty
                ? Row(
                    children: [
                      ...controller.portfolioImages.asMap().entries.map((entry) {
                        int index = entry.key;
                        File image = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: Stack(
                            children: [
                              Container(
                                width: 80.w,
                                height: 80.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  image: DecorationImage(
                                    image: FileImage(image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -8,
                                right: -8,
                                child: IconButton(
                                  icon: Container(
                                    padding: EdgeInsets.all(4.w),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () => controller.removePortfolioImage(index),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      if (controller.portfolioImages.length < 4)
                        GestureDetector(
                          onTap: controller.pickPortfolioImages,
                          child: Container(
                            width: 80.w,
                            height: 80.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: const Color(0xffE0E0E0),
                                style: BorderStyle.solid,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 32.sp,
                              color: const Color(0xff9E9E9E),
                            ),
                          ),
                        ),
                    ],
                  )
                : const SizedBox.shrink()),
            SizedBox(height: 40.h),
            
            // Next Button
            Obx(() => CustomButton(
              text: "Next",
              enabled: controller.isStep1Valid.value,
              color: controller.isStep1Valid.value
                  ? const Color(0xffD32E28)
                  : const Color(0xffE0E0E0),
              onTap: () {
                if (controller.isStep1Valid.value) {
                  controller.nextStep();
                  Get.toNamed('/provider-registration-step2');
                }
              },
            )),
            SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
