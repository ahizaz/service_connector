// 'dart:io' removed: no direct File usage in this screen
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
    final controller = Get.find<ProviderRegistrationController>();

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
            
            SizedBox(height: 8.h),

            // Profile Description / Bio
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
              controller: controller.bioController,
              hintText: "Enter your profile description",
            ),
            SizedBox(height: 20.h),
            // Provider Language (optional)
            Text(
              "Provider Language (Optional)",
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextfield(
              controller: controller.providerLanguageController,
              hintText: "e.g. English, Spanish (optional)",
            ),
            SizedBox(height: 16.h),

            // Provider License Number (optional)
            Text(
              "Provider License Number (Optional)",
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextfield(
              controller: controller.licenseNumberController,
              hintText: "Enter license number (optional)",
            ),
            SizedBox(height: 20.h),
            
            // (Removed duplicate Profile Description field)
            SizedBox(height: 12.h),
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
