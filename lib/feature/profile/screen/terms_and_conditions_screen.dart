import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Terms & Conditions',
          style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last updated: 01 January 2025',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 16.h),

              _sectionTitle('1. Introduction'),
              _sectionBody(
                'Welcome to Service Connect. By using our application, you agree to be bound by these terms and conditions. Please read them carefully before using the app.',
              ),

              _sectionTitle('2. Using the Service'),
              _sectionBody(
                'You must follow any policies made available within the app. You agree not to misuse the service or help anyone else to do so. If you breach these terms, we may suspend or stop providing the service to you.',
              ),

              _sectionTitle('3. Content'),
              _sectionBody(
                'You retain ownership of the content you post. By posting content you grant Service Connect a license to host, use, reproduce, and distribute that content.',
              ),

              _sectionTitle('4. Liability'),
              _sectionBody(
                'To the fullest extent permitted by law, Service Connect is not responsible for any indirect, incidental, or consequential damages arising from your use of the app.',
              ),

              _sectionTitle('5. Changes'),
              _sectionBody(
                'We may modify these terms from time to time. When changes are made, we will update the date above. Continued use of the app after changes constitutes acceptance of the new terms.',
              ),

              SizedBox(height: 24.h),
              // Center(
              //   child: OutlinedButton(
              //     onPressed: () => Navigator.of(context).pop(),
              //     style: OutlinedButton.styleFrom(
              //       padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              //     ),
              //     child: Text(
              //       'Close',
              //       style: TextStyle(fontSize: 14.sp, color: Colors.black),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 6.h),
      child: Text(
        t,
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }

  Widget _sectionBody(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 13.sp, color: Colors.grey[800], height: 1.4),
      ),
    );
  }
}
