import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/home/widget/home_header_widget.dart';
import 'package:service_connect/feature/home/screen/all_categories_screen.dart';
import 'package:service_connect/feature/home/screen/all_professionals_screen.dart';
import 'package:service_connect/feature/home/screen/category_services_screen.dart';
import 'package:service_connect/feature/home/widget/professional_card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController(), permanent: true);
    
    // Reload mode when screen becomes visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.reloadMode();
    });
    
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      body: Obx(() => controller.isServiceProvider.value
          ? _buildServiceProviderHome(controller)
          : _buildServiceReceiverHome(controller)),
    );
  }
  
  // Service Receiver Home (original)
  Widget _buildServiceReceiverHome(HomeController controller) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HomeHeaderWidget(controller: controller),
          SizedBox(height: 26.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 26.h),
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
          SizedBox(height: 16.h),
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
                  child: GestureDetector(
                    onTap: () => Get.to(() => CategoryServicesScreen(
                      categoryName: category['name']!,
                    )),
                    child: Container(
                      width: 116.w,
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
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Top Rated Professional", style: GoogleFonts.roboto(
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
                      debugPrint('Book now: ${professional['name']}');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  // Service Provider Home (new)
  Widget _buildServiceProviderHome(HomeController controller) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HomeHeaderWidget(controller: controller),
          SizedBox(height: 26.h),
          
          // Dashboard Cards
          Padding(
            
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("My Dashboard", style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Color(0xff252525),
                )),
                SizedBox(height: 16.h),
                
                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: "Active Orders",
                        value: "12",
                        icon: Icons.work_outline,
                        color: Color(0xffD32E28),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildStatCard(
                        title: "Completed",
                        value: "45",
                        icon: Icons.check_circle_outline,
                        color: Color(0xff4CAF50),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: "Earnings",
                        value: "\$1,250",
                        icon: Icons.attach_money,
                        color: Color(0xffFF9800),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildStatCard(
                        title: "Rating",
                        value: "4.8",
                        icon: Icons.star_outline,
                        color: Color(0xffFFC107),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 32.h),
          
          // Recent Orders
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recent Orders", style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color(0xff252525),
                )),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "View All",
                    style: GoogleFonts.roboto(
                      color: Color(0xffCC0000),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          
          // Order List
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildOrderCard(
                serviceName: index == 0 ? "AC Repair Service" : index == 1 ? "Plumbing Service" : "Electrical Work",
                clientName: index == 0 ? "John Doe" : index == 1 ? "Jane Smith" : "Mike Johnson",
                price: index == 0 ? 150 : index == 1 ? 80 : 120,
                status: index == 0 ? "In Progress" : index == 1 ? "Pending" : "Completed",
                date: index == 0 ? "Today, 2:30 PM" : index == 1 ? "Tomorrow, 10:00 AM" : "Yesterday",
              );
            },
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
  
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xff313131),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 12.sp,
              color: Color(0xff737373),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOrderCard({
    required String serviceName,
    required String clientName,
    required int price,
    required String status,
    required String date,
  }) {
    Color statusColor = status == "Completed" 
        ? Color(0xff4CAF50) 
        : status == "In Progress" 
            ? Color(0xffFF9800) 
            : Color(0xff2196F3);
            
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                serviceName,
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff313131),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.person_outline, size: 16.sp, color: Color(0xff737373)),
              SizedBox(width: 4.w),
              Text(
                clientName,
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  color: Color(0xff737373),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, size: 16.sp, color: Color(0xff737373)),
                  SizedBox(width: 4.w),
                  Text(
                    date,
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      color: Color(0xff737373),
                    ),
                  ),
                ],
              ),
              Text(
                "\$$price",
                style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffD32E28),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}