import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/home/widget/professional_card_widget.dart';
import 'package:service_connect/feature/home/screen/all_professionals_screen.dart';
import 'package:service_connect/feature/home/screen/professional_details_screen.dart';

class TopRatedProfessionalsWidget extends StatelessWidget {
  final HomeController controller;
  const TopRatedProfessionalsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("All Professional", style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Color(0xff252525),
              )),
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
        SizedBox(height: 16.h),
        // SizedBox(
        //   height: 240.h,
        //   child: ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     padding: EdgeInsets.symmetric(horizontal: 20.w),
        //     itemCount: controller.topRatedProfessionals.length,
        //     itemBuilder: (context, index) {
        //       final professional = controller.topRatedProfessionals[index];
        //       return Padding(
        //         padding: EdgeInsets.only(right: 16.w),
        //         child: GestureDetector(
        //           onTap: () {
        //             Get.to(() => ProfessionalDetailsScreen(
        //               professionalId: professional['professionalId'],
        //             ));
        //           },
        //           child: ProfessionalCardWidget(
        //             name: professional['name'],
        //             professional: professional['professional'],
        //             rating: professional['rating'].toDouble(),
        //             price: professional['price'] != null ? '\$${professional['price']}/hour' : null,
        //             experience: professional['experience'],
        //             workDone: professional['workDone'],
        //             image: professional['image'],
        //             category: professional['category'],
        //             onBookNow: () {
        //               Get.defaultDialog(
        //                 title: 'Confirm Booking',
        //                 middleText: 'Do you want to book ${professional['name']}?',
        //                 textConfirm: 'Yes',
        //                 textCancel: 'No',
        //                 onConfirm: () {
        //                   Get.back();
        //                   Get.snackbar(
        //                     'Booked',
        //                     '${professional['name']} booked successfully',
        //                     snackPosition: SnackPosition.BOTTOM,
        //                     backgroundColor: Colors.green.withOpacity(0.9),
        //                     colorText: Colors.white,
        //                   );
                         
        //                 },
        //               );
        //             },
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),
        Obx((){
       if(controller.isLoadingProviders.value){
        return SizedBox(
          height: 240.h,
          child: Center(
            child: CircularProgressIndicator(
                color: Color(0xffCC0000),
            ),
          ),
        );
       }
       if(controller.allProviders.isEmpty){
          return SizedBox(
              height: 240.h,
              child: Center(
                child: Text(
                  'No professionals available',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: Color(0xff999999),
                  ),
                ),
              ),
            );
       }
       return SizedBox(
       height: 240.h,
       child: ListView.builder(
         scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: controller.allProviders.length,
        itemBuilder: (context,index){
        final provider = controller.allProviders[index];
        debugPrint('Building card for: ${provider.userName}');
        return Padding(padding: EdgeInsets.only(right: 16.w),
        child: GestureDetector(
             onTap: () {
                      debugPrint('Tapped on provider: ${provider.userName}');
                      Get.to(() => ProfessionalDetailsScreen(
                        professionalId: provider.id,
                      ));
               },
               child: ProfessionalCardWidget(

                 name: provider.serviceTitle, // service_title
                      professional: provider.userName, // user_name
                      rating: double.tryParse(provider.providerRating) ?? 0.0, // provider_rating কে double এ convert করছি
                      price: '\$${provider.providerServiceCharge}/hour',
                      experience: provider.providerExperience, // provider_experience
                      workDone: provider.providerDoneWork, // provider_done_work
                      image: provider.categoryImage,
                        onBookNow: () {
                        // Book Now button press করলে dialog show হবে
                        Get.defaultDialog(
                          title: 'Confirm Booking',
                          middleText: 'Do you want to book ${provider.userName}?',
                          textConfirm: 'Yes',
                          textCancel: 'No',
                          onConfirm: () {
                            Get.back();
                            Get.snackbar(
                              'Booked',
                              '${provider.userName} booked successfully',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green.withOpacity(0.9),
                              colorText: Colors.white,
                            );
                     
                          },
                        );
                      }, // category_image - network image URL

               ),
        ),
        
        
        );

       }),
       

       );
        }),
      ],
    );
  }
}
