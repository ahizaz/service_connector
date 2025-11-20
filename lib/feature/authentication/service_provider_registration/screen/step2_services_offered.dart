import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';
import 'package:service_connect/core/common/widgets/custom_button.dart';
import 'package:service_connect/core/common/widgets/custom_textField.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/controller/provider_registration_controller.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/widgets/step_progress_indicator.dart';

class Step2ServicesOffered extends StatelessWidget {
  const Step2ServicesOffered({super.key});

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
          'Step 2 of 4',
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
            child: const StepProgressIndicator(currentStep: 2),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What Services Do\nYou Offer?",
              style: AppTextStyles.robotoRegular(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Tell us about services you can provide. You can select multiple.",
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xff737373),
              ),
            ),
            SizedBox(height: 32.h),
            
            // Service Category Dropdown
            Text(
              "Service Category",
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xffF5F5F5)),
              ),
              child: Obx(() => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller.selectedCategory.value.isEmpty 
                      ? 'Service Category' 
                      : controller.selectedCategory.value,
                  items: controller.serviceCategories.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: AppTextStyles.robotoRegular(
                          fontSize: 14,
                          color: value == 'Service Category' 
                              ? const Color(0xff878787) 
                              : const Color(0xff313131),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.selectCategory(newValue);
                    }
                  },
                ),
              )),
            ),
            SizedBox(height: 16.h),
            
            // Selected Categories
            Obx(() => controller.selectedCategories.isNotEmpty
                ? Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: controller.selectedCategories.map((category) {
                      return Chip(
                        label: Text(
                          category,
                          style: AppTextStyles.robotoRegular(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: const Color(0xffD32E28),
                        deleteIcon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                        onDeleted: () => controller.removeCategory(category),
                      );
                    }).toList(),
                  )
                : const SizedBox()),
            SizedBox(height: controller.selectedCategories.isNotEmpty ? 20.h : 0),
            
            // Service Title
            Text(
              "Service Title",
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextfield(
              controller: controller.serviceTitleController,
              hintText: "Enter your service title",
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20.h),
            
            // Years of Experience
            Text(
              "Years of Experience",
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextfield(
              controller: controller.experienceController,
              hintText: "Enter your experience in number",
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20.h),
            
            // Keyword
            Text(
              "Keyword",
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: CustomTextfield(
                    controller: controller.keywordController,
                    hintText: "Type some relevant keyword of your service",
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () => controller.addKeyword(),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xffD32E28),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            
            // Keywords Chips
            Obx(() => controller.keywords.isNotEmpty
                ? Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: controller.keywords.map((keyword) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: const Color(0xffE0E0E0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              keyword,
                              style: AppTextStyles.robotoRegular(
                                fontSize: 12,
                                color: const Color(0xff313131),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            GestureDetector(
                              onTap: () => controller.removeKeyword(keyword),
                              child: Icon(
                                Icons.close,
                                size: 16.sp,
                                color: const Color(0xff737373),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                : const SizedBox()),
            SizedBox(height: 80.h),
            
            // Next Button
            Obx(() => CustomButton(
              text: "Next",
              enabled: controller.isStep2Valid.value,
              color: controller.isStep2Valid.value
                  ? const Color(0xffD32E28)
                  : const Color(0xffE0E0E0),
              onTap: () {
                if (controller.isStep2Valid.value) {
                  controller.nextStep();
                  Get.toNamed('/provider-registration-step3');
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
