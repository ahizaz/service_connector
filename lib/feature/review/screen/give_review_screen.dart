import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/feature/review/controller/review_controller.dart';

class GiveReviewScreen extends StatelessWidget {
  final String providerUserUuid;
  final int orderId;
  final String providerName;
  final String categoryName;
  final String serviceCost;

  const GiveReviewScreen({
    super.key,
    required this.providerUserUuid,
    required this.orderId,
    required this.providerName,
    required this.categoryName,
    required this.serviceCost,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0066FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Give Review',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Details Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #$orderId',
                    style: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildInfoRow(Icons.person, 'Provider', providerName),
                  SizedBox(height: 8.h),
                  _buildInfoRow(Icons.category, 'Category', categoryName),
                  SizedBox(height: 8.h),
                  _buildInfoRow(Icons.attach_money, 'Service Cost', '\$$serviceCost'),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Rating Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rate Your Experience',
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (index) => GestureDetector(
                            onTap: () => controller.setRating(index + 1),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Icon(
                                controller.selectedRating.value > index
                                    ? Icons.star
                                    : Icons.star_border,
                                color: controller.selectedRating.value > index
                                    ? const Color(0xFFFFB800)
                                    : Colors.grey[400],
                                size: 40.sp,
                              ),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(height: 8.h),
                  Obx(() => Center(
                        child: Text(
                          controller.selectedRating.value > 0
                              ? '${controller.selectedRating.value} ${controller.selectedRating.value == 1 ? 'Star' : 'Stars'}'
                              : 'Tap to rate',
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      )),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Review Text Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Write Your Review',
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: controller.reviewTextController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: 'Share your experience with this service provider...',
                      hintStyle: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        color: Colors.grey[400],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: Color(0xFF0066FF), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: EdgeInsets.all(12.w),
                    ),
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      color: const Color(0xFF212121),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            // Submit Button
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : () {
                            debugPrint('=================================');
                            debugPrint('Submit Review button clicked');
                            debugPrint('Provider UUID: $providerUserUuid');
                            debugPrint('Order ID: $orderId');
                            debugPrint('=================================');
                            
                            controller.submitReview(
                              providerUserUuid: providerUserUuid,
                              orderId: orderId,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066FF),
                      disabledBackgroundColor: Colors.grey[400],
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isSubmitting.value
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Submit Review',
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: const Color(0xFF757575),
        ),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: GoogleFonts.roboto(
            fontSize: 14.sp,
            color: const Color(0xFF757575),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              color: const Color(0xFF212121),
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
