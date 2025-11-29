import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/home/screen/search_screen.dart';
import 'package:service_connect/feature/home/screen/professional_details_screen.dart';
import 'package:service_connect/feature/home/widget/professional_card_widget.dart';

class AllProfessionalsScreen extends StatelessWidget {
  const AllProfessionalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
            backgroundColor: Color(0xffF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xff252525)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Top Rated Professional',
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xff252525),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Color(0xff252525)),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar (opens dedicated search screen)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Color(0xffE0E0E0)),
              ),
              child: TextField(
                readOnly: true,
                onTap: () => Get.to(() => const SearchScreen()),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Search for plumber, electrician...',
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: Color(0xff999999),
                  ),
                  prefixIcon: Icon(Icons.search, color: Color(0xff999999)),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            // Grid of professionals
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 164 / 190,
                ),
                itemCount: controller.topRatedProfessionals.length,
                itemBuilder: (context, index) {
                  final professional = controller.topRatedProfessionals[index];
                  return ProfessionalCardWidget(
                    name: professional['name'],
                    professional: professional['professional'],
                    rating: professional['rating'].toDouble(),
                    price: professional['price'] != null ? '\$${professional['price']}/hour' : null,
                    experience: professional['experience'],
                    workDone: professional['workDone'],
                    image: professional['image'],
                    category: professional['category'],
                    onTap: () {
                      // Navigate to professional details screen
                      Get.to(() => ProfessionalDetailsScreen(
                        professionalId: professional['professionalId'],
                      ));
                    },
                    onBookNow: () {
                      Get.defaultDialog(
                        title: 'Confirm Booking',
                        middleText: 'Do you want to book ${professional['name']}?',
                        textConfirm: 'Yes',
                        textCancel: 'No',
                        onConfirm: () {
                          Get.back();
                          Get.snackbar(
                            'Booked',
                            '${professional['name']} booked successfully',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green.withOpacity(0.9),
                            colorText: Colors.white,
                          );
                          // TODO: integrate real booking API here
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
