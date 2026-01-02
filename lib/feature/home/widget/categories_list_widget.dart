import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/home/screen/all_categories_screen.dart';
import 'package:service_connect/feature/home/screen/category_services_screen.dart';

class CategoriesListWidget extends StatelessWidget {
  final HomeController controller;
  const CategoriesListWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 35.h),
              Text("All Catagories", style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Color(0xff252525),
              )),
              Spacer(),
              GestureDetector(
                onTap: () => Get.to(() => AllCategoriesScreen()),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "See All",
                      style: GoogleFonts.roboto(
                        color: Color(0xffCC0000),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14.sp,
                      color: Color(0xffCC0000),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Obx(
          () => controller.categoryController.isLoading.value
              ? SizedBox(
                  height: 120.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffCC0000),
                    ),
                  ),
                )
              : controller.categoryController.categories.isEmpty
                  ? SizedBox(
                      height: 120.h,
                      child: Center(
                        child: Text(
                          "No categories available",
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            color: Color(0xff737373),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 120.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: controller.categoryController.categories.length > 5 
                            ? 5 
                            : controller.categoryController.categories.length,
                        itemBuilder: (context, index) {
                          final category = controller.categoryController.categories[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index == (controller.categoryController.categories.length > 5 ? 4 : controller.categoryController.categories.length - 1) 
                                  ? 0 
                                  : 16.w,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                debugPrint('=================================');
                                debugPrint('Category tapped: ${category.categoryName}');
                                debugPrint('=================================');
                                Get.to(() => CategoryServicesScreen(
                                  categoryName: category.categoryName,
                                ));
                              },
                              child: Container(
                                width: 116.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xffFFFFFF),
                                  borderRadius: BorderRadius.circular(19.r),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: Image.network(
                                        category.categoryImage,
                                        width: 55.w,
                                        height: 55.h,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          debugPrint('=================================');
                                          debugPrint('Error loading image: ${category.categoryImage}');
                                          debugPrint('Error: $error');
                                          debugPrint('=================================');
                                          return Icon(
                                            Icons.category,
                                            size: 40.sp,
                                            color: Color(0xffCC0000),
                                          );
                                        },
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return SizedBox(
                                            width: 55.w,
                                            height: 55.h,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Color(0xffCC0000),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                                      child: Text(
                                        category.categoryName,
                                        style: GoogleFonts.roboto(
                                          fontSize: 12.sp,
                                          color: const Color(0xff252525),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
