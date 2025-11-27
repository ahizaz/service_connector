import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';

class ProfessionalDetailsScreen extends StatelessWidget {
  final int professionalId;

  const ProfessionalDetailsScreen({
    super.key,
    required this.professionalId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final professional = controller.professionals.firstWhere(
      (p) => p['id'] == professionalId,
      orElse: () => {},
    );
    
    // Handle case where professional is not found
    if (professional.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Professional Not Found'),
        ),
        body: const Center(
          child: Text('Professional details not available'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: Column(
        children: [
          // Header with Red Background
          Container(
            decoration: const BoxDecoration(
              color: Color(0xffCC0000),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // App Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .2),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '${professional['profession'] ?? 'Professional'} Details',
                              style: GoogleFonts.roboto(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 36.w), // Balance the back button
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Profile Picture
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4.w,
                      ),
                      image: professional['image'] != null
                          ? DecorationImage(
                              image: AssetImage(professional['image']),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Name
                  Text(
                    professional['name'] ?? 'Unknown',
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Stats Row with Icons
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Experience
                        _buildStatItem(
                          Icons.calendar_today,
                          professional['experience']?.toString().split(' ')[0] ?? '0',
                          'Years',
                          'Experience',
                        ),
                        // Work Done
                        _buildStatItem(
                          Icons.business_center,
                          professional['workDone'] ?? '0',
                          'Work Done',
                          '',
                        ),
                        // Rating
                        _buildStatItem(
                          Icons.star,
                          (professional['rating'] ?? 0.0).toString(),
                          'Rating',
                          '',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  
                  // Overview Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overview',
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff252525),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          professional['overview'] ?? 'No overview available',
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            color: const Color(0xff6B6B6B),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Services Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.cleaning_services_outlined,
                              size: 20.sp,
                              color: const Color(0xffCC0000),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Services',
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff252525),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: ((professional['services'] as List<dynamic>?) ?? [])
                              .map((service) => Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFF5F5),
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                        color: const Color(0xffCC0000).withValues(alpha: .3),
                                      ),
                                    ),
                                    child: Text(
                                      service,
                                      style: GoogleFonts.roboto(
                                        fontSize: 11.sp,
                                        color: const Color(0xffCC0000),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Working Image Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Working Image',
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff252525),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          height: 80.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 12.w),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.asset(
                                    professional['image'] ?? 'assets/images/userpicreparing.png',
                                    width: 100.w,
                                    height: 80.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Ratings & Reviews Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ratings & Reviews',
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff252525),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'View all',
                                style: GoogleFonts.roboto(
                                  fontSize: 12.sp,
                                  color: const Color(0xffCC0000),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        
                        // Rating Summary
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Left side - Overall rating
                              Column(
                                children: [
                                  Text(
                                    (professional['rating'] ?? 0.0).toString(),
                                    style: GoogleFonts.roboto(
                                      fontSize: 36.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff252525),
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) => Icon(
                                        Icons.star,
                                        color: index < (professional['rating'] ?? 0.0).floor()
                                            ? Colors.amber
                                            : Colors.grey[300],
                                        size: 16.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${professional['reviews'] ?? 0} Reviews',
                                    style: GoogleFonts.roboto(
                                      fontSize: 11.sp,
                                      color: const Color(0xff6B6B6B),
                                    ),
                                  ),
                                ],
                              ),
                              
                              SizedBox(width: 24.w),
                              
                              // Right side - Star breakdown
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildRatingBar(5, 0.7),
                                    _buildRatingBar(4, 0.2),
                                    _buildRatingBar(3, 0.05),
                                    _buildRatingBar(2, 0.03),
                                    _buildRatingBar(1, 0.02),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 16.h),
                        
                        // Review Cards
                        _buildReviewCard(
                          'Courtney Henry',
                          '2 mins ago',
                          5,
                          'Consequat velit qui adipisicing sunt do reprehenderit ad laborum tempor ullamco exercitation. Ullamco tempor adipisicing et voluptate duis sit esse aliqua esse ex dolore esse.',
                        ),
                        
                        SizedBox(height: 12.h),
                        
                        _buildReviewCard(
                          'Esther Howard',
                          '5 mins ago',
                          4,
                          'Eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
                        ),
                        
                        SizedBox(height: 12.h),
                        
                        _buildReviewCard(
                          'Leslie Alexander',
                          '1 day ago',
                          5,
                          'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
                        ),
                        
                        SizedBox(height: 100.h), // Space for button
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Message Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to chat
                  Get.toNamed('/chat-detail', arguments: {
                    'userId': professionalId,
                    'userName': professional['name'],
                    'userType': 'Plumber',
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(
                      color: const Color(0xffCC0000),
                      width: 1.5,
                    ),
                  ),
                  elevation: 0,
                ),
                icon: Icon(
                  Icons.message_outlined,
                  color: const Color(0xffCC0000),
                  size: 20.sp,
                ),
                label: Text(
                  'Message',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xffCC0000),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // (Send File option removed)
          ],
        ),
      ),
    );
  }
  

  Widget _buildStatItem(IconData icon, String value, String label1, String label2) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label1,
          style: GoogleFonts.roboto(
            fontSize: 11.sp,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        if (label2.isNotEmpty)
          Text(
            label2,
            style: GoogleFonts.roboto(
              fontSize: 11.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
    );
  }

  Widget _buildRatingBar(int stars, double percentage) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Text(
            '$stars',
            style: GoogleFonts.roboto(
              fontSize: 11.sp,
              color: const Color(0xff6B6B6B),
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.star,
            color: Colors.amber,
            size: 12.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffCC0000)),
                minHeight: 4.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(
    String name,
    String time,
    int rating,
    String review,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: const Color(0xffF5F5F5),
                child: Icon(
                  Icons.person,
                  size: 20.sp,
                  color: const Color(0xff6B6B6B),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.roboto(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff252525),
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.roboto(
                        fontSize: 10.sp,
                        color: const Color(0xff6B6B6B),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    color: index < rating ? Colors.amber : Colors.grey[300],
                    size: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            review,
            style: GoogleFonts.roboto(
              fontSize: 11.sp,
              color: const Color(0xff6B6B6B),
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
