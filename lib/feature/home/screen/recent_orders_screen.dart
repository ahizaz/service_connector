import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:service_connect/feature/order/controller/all_orders_controller.dart';

class RecentOrdersScreen extends StatefulWidget {
  const RecentOrdersScreen({super.key});

  @override
  State<RecentOrdersScreen> createState() => _RecentOrdersScreenState();
}

class _RecentOrdersScreenState extends State<RecentOrdersScreen> {
  final AllOrdersController controller = Get.find<AllOrdersController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.loadMoreOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        title: Text('Recent Orders', style: GoogleFonts.roboto()),
        backgroundColor: Color(0xffCC0000),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.allOrders.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xffCC0000),
            ),
          );
        }

        if (controller.allOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 64.sp,
                  color: Color(0xff999999),
                ),
                SizedBox(height: 16.h),
                Text(
                  'No orders available',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    color: Color(0xff999999),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: Color(0xffCC0000),
          onRefresh: controller.refreshOrders,
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            itemCount: controller.allOrders.length +
                (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.allOrders.length) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: CircularProgressIndicator(
                      color: Color(0xffCC0000),
                    ),
                  ),
                );
              }

              final order = controller.allOrders[index];
              return OrderCard(
                serviceName: order.categoryName,
                clientName: order.receiverName,
                price: double.parse(order.serviceCost).toInt(),
                status: order.displayStatus,
                date: order.formattedDate,
                statusColor: order.getStatusColor(),
              );
            },
          ),
        );
      }),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String serviceName;
  final String clientName;
  final int price;
  final String status;
  final String date;
  final Color statusColor;

  const OrderCard({
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
