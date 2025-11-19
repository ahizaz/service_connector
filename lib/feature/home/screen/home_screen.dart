import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/home/widget/home_header_widget.dart';
import 'package:service_connect/feature/home/screen/all_categories_screen.dart';
import 'package:service_connect/feature/home/screen/all_professionals_screen.dart';
import 'package:service_connect/feature/home/widget/professional_card_widget.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeaderWidget(controller: controller),
            SizedBox(height: 26.h,),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 26.h),
                  Text("All Catagories",style: GoogleFonts.roboto ( 
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xff252525),
                  ),),
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
            SizedBox(height: 16.h,),
            SizedBox(
              height: 120.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return Padding(
                    padding: EdgeInsets.only(right: index == controller.categories.length - 1 ? 0 : 16.w),
                    child: Container(
                      width: 90.w,
                      decoration: BoxDecoration(
                        color: const Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(19.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            category['icon']!,
                            width: 55.w,
                            height: 55.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            category['name']!,
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              color: const Color(0xff252525),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 37.h,),
              Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Top Rated Professional",style: GoogleFonts.roboto ( 
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xff252525),
                  ),),
                  GestureDetector(
                    onTap: () => Get.to(() => AllProfessionalsScreen()),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "See all",
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
            SizedBox(height: 16.h,),
            SizedBox(
              height: 240.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: controller.topRatedProfessionals.length,
                itemBuilder: (context, index) {
                  final professional = controller.topRatedProfessionals[index];
                  return Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: ProfessionalCardWidget(
                      name: professional['name'],
                      professional: professional['professional'],
                      rating: professional['rating'].toDouble(),
                      price: professional['price'],
                      image: professional['image'],
                      category: professional['category'],
                      onBookNow: () {
                        // Handle book now action
                        print('Book now: ${professional['name']}');
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h,),
             Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Near By Professional",style: GoogleFonts.roboto ( 
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xff252525),
                  ),),
                  GestureDetector(
                    onTap: () => Get.to(() => AllProfessionalsScreen()),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "See all",
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


        
          ],
        ),
      ),
    );
  }
}