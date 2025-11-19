import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/chat_controller.dart';
import '../model/chat_message_model.dart';

class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final user = controller.currentChatUser.value;
          if (user == null) return SizedBox();

          return Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Color(0xFFE0E0E0),
                child: Icon(Icons.person, color: Colors.white, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Plumber',
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: controller.currentChatMessages.length,
                itemBuilder: (context, index) {
                  final message = controller.currentChatMessages[index];
                  return _buildMessageBubble(message);
                },
              );
            }),
          ),

          // Message input area
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Attach button
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.image, size: 20.sp),
                      color: Color(0xFF757575),
                      onPressed: () {
                        controller.pickImageFromGallery();
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Message input field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.messageController,
                              decoration: InputDecoration(
                                hintText: 'Start your conversation here...',
                                hintStyle: TextStyle(
                                  color: Color(0xFF9E9E9E),
                                  fontSize: 14.sp,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 10.h,
                                ),
                              ),
                              maxLines: null,
                            ),
                          ),
                          // Emoji button
                          IconButton(
                            icon: Icon(Icons.emoji_emotions_outlined),
                            color: Color(0xFF757575),
                            iconSize: 22.sp,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Voice/Send button
                  Obx(() {
                    final hasText = controller.messageController.text.isNotEmpty;
                    return GestureDetector(
                      onTap: () {
                        if (hasText) {
                          controller.sendMessage();
                        }
                      },
                      onLongPress: () {
                        if (!hasText) {
                          controller.toggleRecording();
                        }
                      },
                      onLongPressUp: () {
                        if (controller.isRecording.value) {
                          controller.toggleRecording();
                        }
                      },
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF6B4CE6), Color(0xFF9B6FFF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          controller.isRecording.value
                              ? Icons.stop
                              : (hasText ? Icons.send : Icons.mic),
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    if (message.type == MessageType.voice) {
      return _buildVoiceMessage(message);
    }
    
    if (message.type == MessageType.image) {
      return _buildImageMessage(message);
    }

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        constraints: BoxConstraints(maxWidth: 280.w),
        decoration: BoxDecoration(
          color: message.isMe ? Color(0xFF6B4CE6) : Color(0xFFF5F5F5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: message.isMe ? Radius.circular(16.r) : Radius.circular(4.r),
            bottomRight: message.isMe ? Radius.circular(4.r) : Radius.circular(16.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: message.isMe ? Colors.white : Colors.black,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.time,
                  style: TextStyle(
                    color: message.isMe
                        ? Colors.white.withOpacity(0.7)
                        : Color(0xFF9E9E9E),
                    fontSize: 11.sp,
                  ),
                ),
                if (message.isMe) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    message.isRead ? Icons.done_all : Icons.done,
                    color: message.isRead
                        ? Color(0xFFFF9800)
                        : Colors.white.withOpacity(0.7),
                    size: 14.sp,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceMessage(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        constraints: BoxConstraints(maxWidth: 280.w),
        decoration: BoxDecoration(
          color: message.isMe ? Color(0xFF6B4CE6) : Color(0xFFF5F5F5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: message.isMe ? Radius.circular(16.r) : Radius.circular(4.r),
            bottomRight: message.isMe ? Radius.circular(4.r) : Radius.circular(16.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Play button
            Icon(
              Icons.play_arrow,
              color: message.isMe ? Colors.white : Colors.black,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            // Waveform
            Expanded(
              child: Row(
                children: List.generate(
                  20,
                  (index) => Container(
                    width: 2.w,
                    height: (index % 3 == 0 ? 16 : index % 2 == 0 ? 12 : 8).h,
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    decoration: BoxDecoration(
                      color: message.isMe
                          ? Colors.white.withOpacity(0.7)
                          : Color(0xFF9E9E9E),
                      borderRadius: BorderRadius.circular(1.r),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // Time
            Text(
              message.time,
              style: TextStyle(
                color: message.isMe
                    ? Colors.white.withOpacity(0.7)
                    : Color(0xFF9E9E9E),
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildImageMessage(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        constraints: BoxConstraints(maxWidth: 280.w),
        child: Column(
          crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: message.filePath != null
                  ? Image.file(
                      File(message.filePath!),
                      width: 280.w,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 280.w,
                      height: 200.h,
                      color: Color(0xFFF5F5F5),
                      child: Icon(Icons.image, size: 50.sp),
                    ),
            ),
            SizedBox(height: 4.h),
            Text(
              message.time,
              style: TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
