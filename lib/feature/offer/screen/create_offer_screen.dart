import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';
import 'package:service_connect/core/common/widgets/custom_button.dart';
import 'package:service_connect/core/common/widgets/custom_textField.dart';
import 'package:service_connect/feature/offer/controller/create_offer_controller.dart';

class CreateOfferScreen extends StatelessWidget {
  final String receiverUserId;
  final String conversationId;

  const CreateOfferScreen({
    super.key,
    required this.receiverUserId,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateOfferController());
    
    // Set receiver user ID in controller
    controller.receiverUserId.value = receiverUserId;
    
    debugPrint('=================================');
    debugPrint('CreateOfferScreen initialized');
    debugPrint('Receiver User ID: $receiverUserId');
    debugPrint('Conversation ID: $conversationId');
    debugPrint('=================================');

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
          'Create Offer',
          style: AppTextStyles.robotoRegular(
            fontSize: 18,
            fontWeight: FontWeight.w600,
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
              'Offer Details',
              style: AppTextStyles.robotoRegular(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Fill in the details to create an offer for your client',
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xff737373),
              ),
            ),
            SizedBox(height: 32.h),

            // Service Category Dropdown
            Text(
              'Service Category*',
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
                border: Border.all(color: const Color(0xffE0E0E0)),
              ),
              child: Obx(
                () => DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: controller.selectedServiceCategory.value == 0
                        ? null
                        : controller.selectedServiceCategory.value - 1,
                    hint: Text(
                      'Select service category',
                      style: AppTextStyles.robotoRegular(
                        fontSize: 14,
                        color: const Color(0xff878787),
                      ),
                    ),
                    items: List.generate(
                      controller.serviceCategories.length,
                      (index) => DropdownMenuItem<int>(
                        value: index,
                        child: Text(
                          controller.serviceCategories[index],
                          style: AppTextStyles.robotoRegular(
                            fontSize: 14,
                            color: const Color(0xff313131),
                          ),
                        ),
                      ),
                    ),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        controller.selectCategory(newValue);
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Service Description
            Text(
              'Service Description*',
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: controller.serviceDescriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter service description',
                hintStyle: AppTextStyles.robotoRegular(
                  fontSize: 14,
                  color: const Color(0xff878787),
                ),
                filled: true,
                fillColor: const Color(0xffFFFFFF),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16.h,
                  horizontal: 16.w,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: Color(0xffF5F5F5),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: Color(0xffCC7A7A),
                    width: 1,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Service Cost
            Text(
              'Service Cost*',
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextfield(
              controller: controller.serviceCostController,
              hintText: 'Enter service cost (e.g., 500.00)',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 20.h),

            // Service Timeline
            Text(
              'Service Timeline*',
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextfield(
              controller: controller.serviceTimelineController,
              hintText: 'Enter timeline (e.g., 5 days)',
            ),
            SizedBox(height: 20.h),

            // Terms & Conditions
            Text(
              'Terms & Conditions*',
              style: AppTextStyles.robotoRegular(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff313131),
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: controller.termsConditionsController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter terms and conditions',
                hintStyle: AppTextStyles.robotoRegular(
                  fontSize: 14,
                  color: const Color(0xff878787),
                ),
                filled: true,
                fillColor: const Color(0xffFFFFFF),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16.h,
                  horizontal: 16.w,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: Color(0xffF5F5F5),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: Color(0xffCC7A7A),
                    width: 1,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Urgency Type
            Text(
              'Urgency Type',
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
                border: Border.all(color: const Color(0xffE0E0E0)),
              ),
              child: Obx(
                () => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: controller.selectedUrgencyType.value,
                    items: controller.urgencyTypes
                        .map(
                          (type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              type.capitalize!,
                              style: AppTextStyles.robotoRegular(
                                fontSize: 14,
                                color: const Color(0xff313131),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectUrgencyType(newValue);
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),

            // Submit Button
            Obx(
              () => CustomButton(
                text: 'Submit Offer',
                enabled: controller.isFormValid.value,
                color: controller.isFormValid.value
                    ? const Color(0xffD32E28)
                    : const Color(0xffE0E0E0),
                onTap: () {
                  if (controller.isFormValid.value) {
                    controller.submitOffer(conversationId);
                  }
                },
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
