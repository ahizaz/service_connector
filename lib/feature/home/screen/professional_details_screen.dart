import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_connect/feature/home/controller/home_controller.dart';
import 'package:service_connect/feature/home/model/provider_detail_model.dart';
import 'package:service_connect/feature/home/repository/provider_repositroy.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProfessionalDetailsScreen extends StatefulWidget {
  final int professionalId;

  const ProfessionalDetailsScreen({super.key, required this.professionalId});

  @override
  State<ProfessionalDetailsScreen> createState() => _ProfessionalDetailsScreenState();
}

class _ProfessionalDetailsScreenState extends State<ProfessionalDetailsScreen> {
  final ProviderRepository _providerRepository = ProviderRepository();
  ProviderDetailModel? providerDetail;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProviderDetails();
  }

  Future<void> _fetchProviderDetails() async {
    try {
      debugPrint('=================================');
      debugPrint('Starting to fetch provider details for ID: ${widget.professionalId}');
      debugPrint('=================================');
      
      EasyLoading.show(status: 'Loading...');
      
      final details = await _providerRepository.getProviderDetails(widget.professionalId);
      
      debugPrint('=================================');
      debugPrint('Provider details loaded successfully');
      debugPrint('Provider Name: ${details.user.name}');
      debugPrint('Service Title: ${details.serviceTitle}');
      debugPrint('Rating: ${details.providerRating}');
      debugPrint('=================================');
      
      setState(() {
        providerDetail = details;
        isLoading = false;
      });
      
      EasyLoading.dismiss();
    } catch (e) {
      debugPrint('=================================');
      debugPrint('Error loading provider details: $e');
      debugPrint('=================================');
      
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      
      EasyLoading.dismiss();
      EasyLoading.showError('Failed to load provider details');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xffCC0000),
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text(
            'Professional Details',
            style: GoogleFonts.roboto(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xffCC0000),
          ),
        ),
      );
    }

    // Show error state
    if (errorMessage != null || providerDetail == null) {
      return Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xffCC0000),
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text(
            'Professional Details',
            style: GoogleFonts.roboto(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.sp,
                color: Colors.red,
              ),
              SizedBox(height: 16.h),
              Text(
                'Failed to load provider details',
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  color: const Color(0xff252525),
                ),
              ),
              SizedBox(height: 8.h),
              ElevatedButton(
                onPressed: _fetchProviderDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffCC0000),
                ),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final professional = providerDetail!;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: Column(
        children: [
          // Header with Red Background
          Container(
            decoration: const BoxDecoration(color: Color(0xffCC0000)),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // App Bar
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
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
                              '${professional.serviceCategory.categoryName} Details',
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
                      border: Border.all(color: Colors.white, width: 4.w),
                      image: professional.serviceCategory.categoryImage.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(professional.serviceCategory.categoryImage),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: professional.serviceCategory.categoryImage.isEmpty
                        ? Icon(Icons.person, size: 50.sp, color: Colors.white)
                        : null,
                  ),
                  SizedBox(height: 12.h),
                  // Name
                  Text(
                    professional.user.name,
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
                          professional.providerExperience.toString(),
                          'Years',
                          'Experience',
                        ),
                        // Work Done
                        _buildStatItem(
                          Icons.business_center,
                          professional.providerDoneWork.toString(),
                          'Work Done',
                          '',
                        ),
                        // Rating
                        _buildStatItem(
                          Icons.star,
                          professional.providerRating,
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
                          professional.providerDescription,
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

                  // Provider Information Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Provider Information',
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff252525),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _buildInfoRow(Icons.email, 'Email', professional.user.email),
                        _buildInfoRow(Icons.location_city, 'City', professional.providerCity),
                        _buildInfoRow(Icons.location_on, 'Country', professional.providerCountry),
                        _buildInfoRow(Icons.language, 'Languages', professional.providerLanguage),
                        _buildInfoRow(Icons.card_membership, 'License', professional.providerLicenceNumber),
                        _buildInfoRow(Icons.attach_money, 'Service Charge', '\$${professional.providerServiceCharge}/hour'),
                        _buildInfoRow(Icons.verified, 'Verified', professional.providerIsVerified ? 'Yes' : 'No'),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Services Section (Keywords)
                  if (professional.keywords.isNotEmpty)
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
                                'Keywords',
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
                            children: professional.keywords
                                .map(
                                  (keyword) => Container(
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
                                      keyword,
                                      style: GoogleFonts.roboto(
                                        fontSize: 11.sp,
                                        color: const Color(0xffCC0000),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 20.h),

                  // Working Images Section
                  if (professional.workImages.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Working Images',
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
                              itemCount: professional.workImages.length,
                              itemBuilder: (context, index) {
                                final workImage = professional.workImages[index];
                                return Padding(
                                  padding: EdgeInsets.only(right: 12.w),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.network(
                                      workImage.image,
                                      width: 100.w,
                                      height: 80.h,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 100.w,
                                          height: 80.h,
                                          color: Colors.grey[300],
                                          child: Icon(Icons.image, color: Colors.grey),
                                        );
                                      },
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

                  // Documents Section
                  if (professional.documents.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Documents',
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff252525),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ...professional.documents.map((doc) => Container(
                                margin: EdgeInsets.only(bottom: 8.h),
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.document_scanner, color: const Color(0xffCC0000)),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            doc.documentType.toUpperCase(),
                                            style: GoogleFonts.roboto(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'Status: ${doc.status}',
                                            style: GoogleFonts.roboto(
                                              fontSize: 11.sp,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: doc.status == 'pending'
                                            ? Colors.orange.withValues(alpha: .2)
                                            : doc.status == 'approved'
                                                ? Colors.green.withValues(alpha: .2)
                                                : Colors.red.withValues(alpha: .2),
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                      child: Text(
                                        doc.status.toUpperCase(),
                                        style: GoogleFonts.roboto(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                          color: doc.status == 'pending'
                                              ? Colors.orange
                                              : doc.status == 'approved'
                                                  ? Colors.green
                                                  : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )).toList(),
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
                                    professional.providerRating,
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
                                        color: index < double.parse(professional.providerRating).floor()
                                            ? Colors.amber
                                            : Colors.grey[300],
                                        size: 16.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${professional.providerTotalHired} Hired',
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
                  Get.toNamed(
                    '/chat-detail',
                    arguments: {
                      'userId': widget.professionalId,
                      'userName': professional.user.name,
                      'userType': professional.serviceCategory.categoryName,
                    },
                  );
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

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label1,
    String label2,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: Colors.white, size: 20.sp),
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
          Icon(Icons.star, color: Colors.amber, size: 12.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xffCC0000),
                ),
                minHeight: 4.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String name, String time, int rating, String review) {
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: const Color(0xffCC0000)),
          SizedBox(width: 12.w),
          Text(
            '$label: ',
            style: GoogleFonts.roboto(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff252525),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 12.sp,
                color: const Color(0xff6B6B6B),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
