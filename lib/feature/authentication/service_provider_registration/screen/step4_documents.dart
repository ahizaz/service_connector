import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';
import 'package:service_connect/core/common/widgets/custom_button.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/controller/provider_registration_controller.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/screen/step5_work_images.dart';
import 'package:service_connect/feature/authentication/service_provider_registration/widgets/step_progress_indicator.dart';

class Step4Documents extends StatelessWidget {
  const Step4Documents({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProviderRegistrationController>();
    final documentTypes = ['Passport'];
    final selectedDocType = documentTypes[0].obs;

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
          'Step 4 of 4',
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
            child: const StepProgressIndicator(currentStep: 4),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Your\nDocuments",
                    style: AppTextStyles.robotoRegular(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff313131),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Upload your business documents for verification",
                    style: AppTextStyles.robotoRegular(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff737373),
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Document Type (single dropdown for all uploads)
                  Text(
                    "Document Type",
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
                    child: DropdownButtonHideUnderline(
                      child: Obx(
                        () => DropdownButton<String>(
                          isExpanded: true,
                          value: selectedDocType.value,
                          items: documentTypes
                              .map(
                                (d) =>
                                    DropdownMenuItem(value: d, child: Text(d)),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) selectedDocType.value = value;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Passport Upload Button
                  Obx(
                    () => GestureDetector(
                      onTap: () => controller.pickDocument('trade'),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 40.h,
                          horizontal: 20.w,
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
                        child: controller.tradeLicenseDoc.value == null
                            ? Column(
                                children: [
                                  Icon(
                                    Icons.upload_file_outlined,
                                    size: 48.sp,
                                    color: const Color(0xffD32E28),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    "Browse Document",
                                    style: AppTextStyles.robotoRegular(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xffD32E28),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "Please upload your passport (photo or PDF). File must be less than 25 MB.",
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.robotoRegular(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff737373),
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.description,
                                        size: 48.sp,
                                        color: const Color(0xffD32E28),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        "Passport.pdf",
                                        style: AppTextStyles.robotoRegular(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff313131),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: -10,
                                    right: -10,
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
                                      onPressed: () =>
                                          controller.removeDocument('trade'),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // (Removed duplicate Document Type dropdown)
                  /*
            SizedBox(height: 16.h),

            // Insurance Upload Button (commented out per request)
            Obx(() => GestureDetector(
              onTap: () => controller.pickDocument('insurance'),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xffE0E0E0),
                    style: BorderStyle.solid,
                    width: 2,
                  ),
                ),
                child: controller.insuranceDoc.value == null
                    ? Column(
                        children: [
                          Icon(
                            Icons.upload_file_outlined,
                            size: 48.sp,
                            color: const Color(0xffD32E28),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "Browse Document",
                            style: AppTextStyles.robotoRegular(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xffD32E28),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Please upload Insurance or ID Card, also it can be less than 25 MB and in PDF format.",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.robotoRegular(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff737373),
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.description,
                                size: 48.sp,
                                color: const Color(0xffD32E28),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Insurance Card.pdf",
                                style: AppTextStyles.robotoRegular(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff313131),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: -10,
                            right: -10,
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
                              onPressed: () => controller.removeDocument('insurance'),
                            ),
                          ),
                        ],
                      ),
              ),
            )),
            */
                  SizedBox(height: 40.h),

                  // Action Buttons: Submit (enabled when passport uploaded) and Skip
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Submit",
                            enabled: controller.isStep4Valid.value,
                            color: controller.isStep4Valid.value
                                ? const Color(0xffD32E28)
                                : const Color(0xffE0E0E0),
                            onTap: () async {
                              // Submit documents using the provider ID
                              if (controller.isStep4Valid.value) {
                                await controller.submitDocuments();
                                // Move to Step 5 (Work Images) after successful submission
                                try {
                                  Get.to(() => const Step5WorkImages());
                                } catch (_) {
                                  // fallback: set step index if using stepper UI
                                  controller.currentStep.value = 4;
                                }
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
                            onPressed: () {
                              // Skip documents and continue to Step 5
                              try {
                                Get.to(() => const Step5WorkImages());
                              } catch (_) {
                                controller.currentStep.value = 4;
                              }
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
