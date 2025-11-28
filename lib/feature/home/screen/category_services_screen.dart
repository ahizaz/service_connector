import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/home/screen/search_screen.dart';
import 'package:service_connect/feature/home/screen/professional_details_screen.dart';

class CategoryServicesScreen extends StatelessWidget {
  final String categoryName;

  const CategoryServicesScreen({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final services = controller.categoryServices[categoryName] ?? [];

    return Scaffold(
     backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
      backgroundColor: Color(0xffF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff252525)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          categoryName,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500,
            fontSize: 20.sp,
            color: const Color(0xff252525),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Color(0xff252525)),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            // Search bar (opens dedicated search screen with category)
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                readOnly: true,
                onTap: () => Get.to(() => SearchScreen(initialCategory: categoryName)),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Search for $categoryName...',
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: const Color(0xff9E9E9E),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xff9E9E9E),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // Services list
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to professional details
                      Get.to(() => ProfessionalDetailsScreen(
                        professionalId: service['professionalId'],
                      ));
                    },
                    child: _buildServiceCard(
                      service['name'],
                      service['professional'],
                      service['rating'].toDouble(),
                      service['reviews'],
                      service['price'],
                      service['image'],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    String serviceName,
    String professionalName,
    double rating,
    int reviews,
    int price,
    String imagePath,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Service image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              imagePath,
              width: 60.w,
              height: 60.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          // Service details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName,
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff252525),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  professionalName,
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    color: const Color(0xff757575),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: const Color(0xffFFB800),
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '$rating ($reviews Reviews)',
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        color: const Color(0xff757575),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // Price (booking removed)
          Column(
            children: [
              Text(
                '\$$price',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff252525),
                ),
              ),
              Text(
                '/hour',
                style: GoogleFonts.roboto(
                  fontSize: 10.sp,
                  color: const Color(0xff757575),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
