import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';
import 'package:service_connect/core/common/widgets/custom_button.dart';
import 'package:service_connect/core/common/widgets/custom_textField.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/controller/provider_registration_controller.dart';

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
      body: SingleChildScrollView(
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
            
            // Location Dropdown
            Text(
              "Location",
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
                  value: controller.selectedLocation.value.isEmpty 
                      ? 'Location' 
                      : controller.selectedLocation.value,
                  items: controller.locations.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: AppTextStyles.robotoRegular(
                          fontSize: 14,
                          color: value == 'Location' 
                              ? const Color(0xff878787) 
                              : const Color(0xff313131),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.selectLocation(newValue);
                    }
                  },
                ),
              )),
            ),
            SizedBox(height: 20.h),
            
            // Address
            Text(
              "Address Line",
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextfield(
              controller: controller.addressController,
              hintText: "Enter your address",
            ),
            SizedBox(height: 20.h),
            
            // City
            Text(
              "Select Area",
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextfield(
              controller: controller.cityController,
              hintText: "Enter your city/area",
            ),
            SizedBox(height: 150.h),
            
            // Next Button
            Obx(() => CustomButton(
              text: "Next",
              enabled: controller.isStep3Valid.value,
              color: controller.isStep3Valid.value
                  ? const Color(0xffD32E28)
                  : const Color(0xffE0E0E0),
              onTap: () {
                if (controller.isStep3Valid.value) {
                  controller.nextStep();
                  Get.toNamed('/provider-registration-step4');
                }
              },
            )),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
