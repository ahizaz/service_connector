import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentOrdersScreen extends StatelessWidget {
  const RecentOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent Orders', style: GoogleFonts.roboto()),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xff252525),
        elevation: 1,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            final serviceName = index == 0 ? "AC Repair Service" : index == 1 ? "Plumbing Service" : "Electrical Work";
            final clientName = index == 0 ? "John Doe" : index == 1 ? "Jane Smith" : "Mike Johnson";
            final price = index == 0 ? 150 : index == 1 ? 80 : 120;
            final status = index == 0 ? "In Progress" : index == 1 ? "Pending" : "Completed";
            final date = index == 0 ? "Today, 2:30 PM" : index == 1 ? "Tomorrow, 10:00 AM" : "Yesterday";

            return OrderCard(
              serviceName: serviceName,
              clientName: clientName,
              price: price,
              status: status,
              date: date,
            );
          },
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String serviceName;
  final String clientName;
  final int price;
  final String status;
  final String date;

  const OrderCard({required this.serviceName, required this.clientName, required this.price, required this.status, required this.date});

  @override
  Widget build(BuildContext context) {
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
            color: Colors.grey.withOpacity(.1),
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
                  color: statusColor.withOpacity(.1),
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
                "\$${price}",
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
