import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'About',
          style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),
              Container(
                width: 90.w,
                height: 90.w,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(Icons.apps, size: 48.sp, color: Colors.grey[700]),
              ),
              SizedBox(height: 16.h),
              Text(
                'Service Connect',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 6.h),
              Text(
                'Version 0.1.0',
                style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 18.h),
              Text(
                'Service Connect is a lightweight platform connecting service providers and service receivers. Our goal is to make finding and offering services simple and reliable.',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[800], height: 1.5),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Divider(),
              SizedBox(height: 12.h),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.email_outlined, color: Colors.black),
                title: Text('Contact'),
                subtitle: Text('support@serviceconnect.example'),
                onTap: () {},
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.link_outlined, color: Colors.black),
                title: Text('Website'),
                subtitle: Text('https://serviceconnect.example'),
                onTap: () {},
              ),
              const Spacer(),
              Text(
                '© ${DateTime.now().year} Service Connect',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
