import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';
import 'package:service_connect/core/common/widgets/custom_button.dart';
import 'package:service_connect/core/common/widgets/custom_textField.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/controller/provider_registration_controller.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/widgets/step_progress_indicator.dart';

class Step3WorkLocation extends StatelessWidget {
  const Step3WorkLocation({super.key});

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
          'Step 3 of 4',
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
            child: const StepProgressIndicator(currentStep: 3),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
              "Where Do You\nWork?",
              style: AppTextStyles.robotoRegular(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Let clients know your service area so they can find you when they need help.",
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xff737373),
              ),
            ),
            SizedBox(height: 32.h),
            
            // Country Dropdown
            Text(
              "Country",
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xffF5F5F5)),
              ),
              child: Obx(() => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Row(
                    children: [
                      Text(
                        '🌍',
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Select your country',
                        style: AppTextStyles.robotoRegular(
                          fontSize: 14,
                          color: const Color(0xff878787),
                        ),
                      ),
                    ],
                  ),
                  value: controller.selectedCountry.value.isEmpty 
                      ? null
                      : controller.selectedCountry.value,
                  items: controller.countriesList.map((country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(
                        country,
                        style: AppTextStyles.robotoRegular(
                          fontSize: 14,
                          color: const Color(0xff313131),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.selectCountry(newValue);
                    }
                  },
                ),
              )),
            ),
            SizedBox(height: 20.h),
            
            // City (typed input)
            Text(
              "City",
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xffF5F5F5)),
              ),
              child: CustomTextfield(
                controller: controller.cityController,
                hintText: 'Type your city',
              ),
            ),
            SizedBox(height: 20.h),
            
            // Service Area
            Text(
              "Service Area",
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextfield(
              controller: controller.serviceAreaController,
              hintText: "Enter areas where you provide service",
            ),
            SizedBox(height: 150.h),
            
            // Create Button — calls API when valid
            Obx(() => CustomButton(
              text: "Create User",
              enabled: controller.isStep3Valid.value,
              color: controller.isStep3Valid.value
                  ? const Color(0xffD32E28)
                  : const Color(0xffE0E0E0),
              onTap: () {
                if (controller.isStep3Valid.value) {
                  debugPrint('Create User pressed — Step 3 values:');
                  debugPrint('Country: ${controller.selectedCountry.value}');
                  debugPrint('City (typed): ${controller.cityController.text}');
                  debugPrint('Selected City: ${controller.selectedCity.value}');
                  debugPrint('Service Area: ${controller.serviceAreaController.text}');
                  debugPrint('isStep3Valid: ${controller.isStep3Valid.value}');
                  controller.completeRegistration();
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
