import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/home/screen/category_services_screen.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xffF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff252525)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "All Categories",
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500,
            fontSize: 20.sp,
            color: Color(0xff252525),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Color(0xff252525)),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(
        () => controller.categoryController.isLoading.value
            ? Center(child: CircularProgressIndicator(color: Color(0xffCC0000)))
            : controller.categoryController.categories.isEmpty
            ? Center(
                child: Text(
                  "No categories available",
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: Color(0xff737373),
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: controller.categoryController.categories.length,
                  itemBuilder: (context, index) {
                    final category =
                        controller.categoryController.categories[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => CategoryServicesScreen(
                            categoryName: category.categoryName,
                          ),
                        );
                      },
                      child: _buildCategoryCard(
                        category.categoryName,
                        category.categoryImage,
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildCategoryCard(String name, String imageUrl) {
    return Container(
      width: 116.w,
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(19.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              imageUrl,
              height: 50.h,
              width: 50.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.category,
                  size: 40.sp,
                  color: Color(0xffCC0000),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  width: 50.w,
                  height: 50.h,
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
              name,
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
    );
  }
}
