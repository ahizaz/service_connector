import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/home/screen/search_screen.dart';
import 'package:service_connect/feature/home/screen/professional_details_screen.dart';
import 'package:service_connect/feature/home/widget/professional_card_widget.dart';

class AllProfessionalsScreen extends StatefulWidget {
  const AllProfessionalsScreen({super.key});

  @override
  State<AllProfessionalsScreen> createState() => _AllProfessionalsScreenState();
}

class _AllProfessionalsScreenState extends State<AllProfessionalsScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<HomeController>();
    // Fetch all providers when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllProviders();
    });
  }

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
          'All Professional',
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
              child: Obx(() {
                if (controller.isLoadingProviders.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff252525),
                    ),
                  );
                }

                if (controller.allProviders.isEmpty) {
                  return Center(
                    child: Text(
                      'No professionals found',
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        color: Color(0xff999999),
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 164 / 190,
                  ),
                  itemCount: controller.allProviders.length,
                  itemBuilder: (context, index) {
                    final provider = controller.allProviders[index];
                    debugPrint('Displaying provider: ${provider.userName}');
                    
                    return ProfessionalCardWidget(
                      name: provider.userName,
                      professional: provider.categoryName,
                      rating: double.tryParse(provider.providerRating) ?? 0.0,
                      price: '\$${provider.providerServiceCharge}/hour',
                      experience: provider.providerExperience,
                      workDone: provider.providerDoneWork,
                      image: provider.userImage ?? provider.categoryImage,
                      category: provider.categoryName,
                      onTap: () {
                        debugPrint('Tapped on provider: ${provider.userName} (ID: ${provider.id})');
                        // Navigate to professional details screen
                        Get.to(() => ProfessionalDetailsScreen(
                          professionalId: provider.id,
                        ));
                      },
                      onBookNow: () {
                        debugPrint('Book now clicked for provider: ${provider.userName}');
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
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
