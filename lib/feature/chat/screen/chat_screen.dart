import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:service_connect/feature/chat/screen/chat_detail_screen.dart';
import '../controller/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Messages',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 16.sp,
                  ),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF9E9E9E)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
              ),
            ),
          ),

          // Messages list
          Expanded(
            child: Obx(() {
              if (controller.filteredUsers.isEmpty) {
                return Center(
                  child: Text(
                    'No messages found',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 16.sp,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.filteredUsers.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final user = controller.filteredUsers[index];
                  return InkWell(
                    onTap: () {
                      controller.openChat(user);
                      Get.to(() => ChatDetailScreen());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFF0F0F0),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Profile image
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 28.r,
                                backgroundColor: Color(0xFFE0E0E0),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 28.sp,
                                ),
                              ),
                              if (user.isOnline)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 14.w,
                                    height: 14.h,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4CAF50),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(width: 12.w),

                          // Message content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              user.name,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (user.isVerified) ...[
                                            SizedBox(width: 4.w),
                                            Icon(
                                              Icons.verified,
                                              color: Color(0xFF2196F3),
                                              size: 16.sp,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    Text(
                                      user.time,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Color(0xFF9E9E9E),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        user.lastMessage,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Color(0xFF757575),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (user.unreadCount > 0)
                                      Container(
                                        margin: EdgeInsets.only(left: 8.w),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFF5252),
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        child: Text(
                                          '${user.unreadCount}',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}