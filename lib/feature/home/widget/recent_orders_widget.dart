import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:service_connect/feature/order/controller/all_orders_controller.dart';
import '../screen/recent_orders_screen.dart';

class RecentOrdersWidget extends StatefulWidget {
  const RecentOrdersWidget({super.key});

  @override
  State<RecentOrdersWidget> createState() => _RecentOrdersWidgetState();
}

class _RecentOrdersWidgetState extends State<RecentOrdersWidget> {
  final AllOrdersController controller = Get.put(AllOrdersController());

  @override
  void initState() {
    super.initState();
    // Fetch orders when widget loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                onTap: () {
                  Get.to(() => RecentOrdersScreen());
                },
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
        Obx(() {
          if (controller.isLoading.value && controller.allOrders.isEmpty) {
            return SizedBox(
              height: 200.h,
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xffCC0000),
                ),
              ),
            );
          }

          if (controller.allOrders.isEmpty) {
            return SizedBox(
              height: 200.h,
              child: Center(
                child: Text(
                  'No orders available',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: Color(0xff999999),
                  ),
                ),
              ),
            );
          }

          final recentOrders = controller.getRecentOrders();

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: recentOrders.length,
            itemBuilder: (context, index) {
              final order = recentOrders[index];
              return _OrderCard(
                serviceName: order.categoryName,
                clientName: order.receiverName,
                price: double.parse(order.serviceCost).toInt(),
                status: order.displayStatus,
                date: order.formattedDate,
                statusColor: order.getStatusColor(),
              );
            },
          );
        }),
        SizedBox(height: 20.h),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String serviceName;
  final String clientName;
  final int price;
  final String status;
  final String date;
  final Color statusColor;

  const _OrderCard({
    required this.serviceName,
    required this.clientName,
    required this.price,
    required this.status,
    required this.date,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Text(
                  serviceName,
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff313131),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
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
              Expanded(
                child: Text(
                  clientName,
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: Color(0xff737373),
                  ),
                  overflow: TextOverflow.ellipsis,
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
