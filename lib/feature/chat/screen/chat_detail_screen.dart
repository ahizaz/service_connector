import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'offer') {
                controller.sendOfferMessage();
                Get.snackbar('Offer', 'Offer sent', snackPosition: SnackPosition.BOTTOM);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'offer',
                child: Text('Offer'),
              ),
            ],
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
                  color: Colors.black.withValues(alpha: .05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Gallery quick access (like the second icon in attachment)
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

                  // Attach button -> shows bottom sheet with options (no Gallery here)
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.attach_file, size: 20.sp),
                      color: Color(0xFF757575),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.r),
                                  topRight: Radius.circular(16.r),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _AttachmentOption(
                                        icon: Icons.camera_alt,
                                        label: 'Camera',
                                        onTap: () {
                                          Get.back();
                                          controller.pickImageFromCamera();
                                        },
                                      ),
                                      _AttachmentOption(
                                        icon: Icons.insert_drive_file,
                                        label: 'Document',
                                        onTap: () {
                                          Get.back();
                                          controller.pickFile();
                                        },
                                      ),
                                      _AttachmentOption(
                                        icon: Icons.audiotrack,
                                        label: 'Audio',
                                        onTap: () {
                                          Get.back();
                                          // Placeholder: audio picking not implemented
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _AttachmentOption(
                                        icon: Icons.location_on,
                                        label: 'Location',
                                        onTap: () {
                                          Get.back();
                                          // Placeholder: location share not implemented
                                        },
                                      ),
                                      _AttachmentOption(
                                        icon: Icons.close,
                                        label: 'Cancel',
                                        onTap: () => Get.back(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                ],
                              ),
                            );
                          },
                        );
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
                            onPressed: () {
                              controller.toggleEmojiPicker();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Voice/Send button (dynamic)
                  Obx(() {
                    final hasText = controller.messageText.value.trim().isNotEmpty;
                    if (hasText) {
                      return GestureDetector(
                        onTap: controller.sendMessage,
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
                            Icons.send,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      );
                    }

                    return GestureDetector(
                      onTap: () async {
                        await controller.toggleRecording();
                      },
                      onLongPress: () async {
                        await controller.toggleRecording();
                      },
                      onLongPressUp: () async {
                        if (controller.isRecording.value) {
                          await controller.toggleRecording();
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
                          controller.isRecording.value ? Icons.stop : Icons.mic,
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
          
          // Emoji Picker
          Obx(() {
            return Offstage(
              offstage: !controller.showEmojiPicker.value,
              child: SizedBox(
                height: 250.h,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    controller.addEmoji(emoji.emoji);
                  },
                  config: Config(
                    height: 256,
                    emojiViewConfig: EmojiViewConfig(
                      emojiSizeMax: 28,
                      backgroundColor: Colors.white,
                    ),
                    categoryViewConfig: CategoryViewConfig(
                      backgroundColor: Colors.white,
                      iconColor: Colors.grey,
                      iconColorSelected: Color(0xFF6B4CE6),
                      indicatorColor: Color(0xFF6B4CE6),
                    ),
                    bottomActionBarConfig: BottomActionBarConfig(
                      backgroundColor: Colors.white,
                      buttonColor: Colors.white,
                      buttonIconColor: Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          }),
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

    if (message.type == MessageType.file) {
      return _buildFileMessage(message);
    }

    if (message.type == MessageType.offer) {
      return _buildOfferMessage(message);
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
                        ? Colors.white.withValues(alpha: 0.7)
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
                        : Colors.white.withValues(alpha: .7),
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
    final duration = message.duration ?? 0;
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    final durationText = '${minutes}:${seconds.toString().padLeft(2, '0')}';
    
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
              color: message.isMe ? Colors.white : Color(0xFF6B4CE6),
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
                          ? Colors.white.withValues(alpha: .7)
                          : Color(0xFF9E9E9E),
                      borderRadius: BorderRadius.circular(1.r),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // Duration
            Text(
              durationText,
              style: TextStyle(
                color: message.isMe
                    ? Colors.white.withValues(alpha: .9)
                    : Color(0xFF424242),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4.w),
            // Time
            Text(
              message.time,
              style: TextStyle(
                color: message.isMe
                    ? Colors.white.withValues(alpha: .7)
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

  Widget _buildOfferMessage(ChatMessage message) {
    final offer = message.offerDetails;
    if (offer == null) return SizedBox.shrink();

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Color(0xFFE0E0E0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .03),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              offer.title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              offer.workDetails,
              style: TextStyle(
                fontSize: 13.sp,
                color: Color(0xFF616161),
                height: 1.4,
              ),
            ),
            SizedBox(height: 14.h),
            Column(
              children: offer.slots.map((slot) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: slot.isSelected ? Color(0xFF6B4CE6) : Color(0xFFE0E0E0),
                      width: slot.isSelected ? 1.5 : 1,
                    ),
                    color: slot.isSelected ? Color(0xFFF3EDFF) : Colors.white,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        slot.isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: slot.isSelected ? Color(0xFF6B4CE6) : Color(0xFFBDBDBD),
                        size: 18.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slot.dayLabel,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              slot.timeLabel,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Color(0xFF616161),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      side: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    onPressed: () {},
                    child: Text(
                      offer.secondaryCtaText,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE53935),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      offer.primaryCtaText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileMessage(ChatMessage message) {
    final fileName = message.message;
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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
            Icon(
              Icons.insert_drive_file,
              color: message.isMe ? Colors.white : Color(0xFF6B4CE6),
              size: 28.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: TextStyle(
                      color: message.isMe ? Colors.white : Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    message.time,
                    style: TextStyle(
                      color: message.isMe ? Colors.white.withValues(alpha: .7) : Color(0xFF9E9E9E),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 28.sp, color: Color(0xFF616161)),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(color: Color(0xFF616161), fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
