import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:service_connect/core/common/styles/global_text_style.dart';
import 'package:service_connect/feature/service_receiver/controller/category_controller.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Categories',
          style: AppTextStyles.robotoRegular(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xff313131),
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: controller.refreshCategories,
                child: controller.categories.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 64.sp,
                              color: const Color(0xff737373),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No categories available',
                              style: AppTextStyles.robotoRegular(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff737373),
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.all(20.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          final category = controller.categories[index];
                          return GestureDetector(
                            onTap: () {
                              debugPrint('=================================');
                              debugPrint('Category tapped: ${category.categoryName}');
                              debugPrint('=================================');
                              // Navigate to category details or service list
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60.w,
                                    height: 60.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFF5F5),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: Image.network(
                                        category.categoryImage,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          debugPrint('=================================');
                                          debugPrint('Error loading image: ${category.categoryImage}');
                                          debugPrint('Error: $error');
                                          debugPrint('=================================');
                                          return Icon(
                                            Icons.category,
                                            size: 32.sp,
                                            color: const Color(0xffD32E28),
                                          );
                                        },
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                                    child: Text(
                                      category.categoryName,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.robotoRegular(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff313131),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
