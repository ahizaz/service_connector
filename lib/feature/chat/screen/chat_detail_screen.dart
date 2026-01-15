import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:service_connect/feature/offer/screen/create_offer_screen.dart';
import 'package:service_connect/feature/order/screen/accepted_orders_screen.dart';
import '../controller/chat_controller.dart';
import '../model/chat_message_model.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Show accept/decline dialog and load messages after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowDialog();
      _loadMessages();
    });
  }

  Future<void> _loadMessages() async {
    final controller = Get.find<ChatController>();
    final user = controller.currentChatUser.value;

    // Load messages if conversation exists
    if (user != null && user.conversationId != null) {
      await controller.fetchConversationMessages(user.conversationId!);
    }
  }

  Future<void> _checkAndShowDialog() async {
    debugPrint('=================================');
    debugPrint('ChatDetailScreen: _checkAndShowDialog() called');

    final controller = Get.find<ChatController>();
    final user = controller.currentChatUser.value;

    debugPrint('Current chat user: ${user?.name}');
    debugPrint('User object is null: ${user == null}');

    // Check if current logged-in user is a service provider
    final prefs = await SharedPreferences.getInstance();
    final isProvider = prefs.getBool('is_service_provider') ?? false;
    final loggedInUserId = prefs.getString('userId') ?? '';

    debugPrint('=================================');
    debugPrint('DIALOG CHECK DETAILS:');
    debugPrint('Logged-in User ID: $loggedInUserId');
    debugPrint('Is Provider: $isProvider');
    debugPrint('Other Person: ${user?.name}');
    debugPrint('Other Person ID: ${user?.id}');
    debugPrint('Conversation Status: "${user?.conversationStatus}"');
    debugPrint('Conversation ID: ${user?.conversationId}');
    debugPrint(
      'Status lowercase == "pending": ${user?.conversationStatus?.toLowerCase() == 'pending'}',
    );
    debugPrint('=================================');

    // Show dialog ONLY if:
    // 1. User is a service provider
    // 2. Conversation status is "pending"
    // 3. Conversation ID exists
    // Logic: Customer sends request -> Provider accepts/declines
    if (isProvider &&
        user != null &&
        user.conversationId != null &&
        user.conversationStatus?.toLowerCase() == 'pending') {
      debugPrint('✅ ✅ ✅ PROVIDER + PENDING STATUS - SHOWING DIALOG ✅ ✅ ✅');
      debugPrint('Provider needs to accept/decline customer request');
      await Future.delayed(
        Duration(milliseconds: 300),
      ); // Small delay to ensure UI is ready
      controller.showAcceptDeclineDialog();
    } else {
      debugPrint('❌ ❌ ❌ CONDITIONS NOT MET - NOT SHOWING DIALOG ❌ ❌ ❌');
      debugPrint('Conditions breakdown:');
      debugPrint(
        '  - isProvider: $isProvider (need: true) - Only providers can accept/decline',
      );
      debugPrint('  - user != null: ${user != null} (need: true)');
      debugPrint(
        '  - conversationId != null: ${user?.conversationId != null} (need: true)',
      );
      debugPrint(
        '  - status == pending: ${user?.conversationStatus?.toLowerCase() == 'pending'} (need: true)',
      );
      if (!isProvider) {
        debugPrint(
          '  ℹ️  You are a SERVICE RECEIVER (Customer) - cannot accept/decline',
        );
      }
    }
    debugPrint('=================================');
  }

  // Helper method to check if the current user is a provider
  Future<bool> _isProvider() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_service_provider') ?? false;
  }

  // Helper method to determine if path is a network URL or local file
  Widget _buildImageWidget(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      // Network image
      return Image.network(
        path,
        width: 280.w,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 280.w,
            height: 200.h,
            color: Color(0xFFF5F5F5),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 280.w,
            height: 200.h,
            color: Color(0xFFF5F5F5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 50.sp, color: Colors.grey),
                SizedBox(height: 8.h),
                Text(
                  'Failed to load image',
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Local file
      return Image.file(File(path), width: 280.w, fit: BoxFit.cover);
    }
  }

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

          return FutureBuilder<bool>(
            future: _isProvider(),
            builder: (context, snapshot) {
              final isProvider = snapshot.data ?? false;
              // Show service title only when receiver is viewing a provider
              // Hide when provider is viewing a receiver
              final shouldShowTitle = !isProvider && user.serviceTitle != null && user.serviceTitle!.isNotEmpty;

              return Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: Color(0xFFE0E0E0),
                    backgroundImage: user.profileImage.isNotEmpty
                        ? NetworkImage(
                            user.profileImage.startsWith('http')
                                ? user.profileImage
                                : 'https://6zpmb4x8-8009.inc1.devtunnels.ms${user.profileImage}',
                          )
                        : null,
                    child: user.profileImage.isEmpty
                        ? Icon(Icons.person, color: Colors.white, size: 20.sp)
                        : null,
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
                        if (shouldShowTitle)
                          Text(
                            user.serviceTitle!,
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
            },
          );
        }),
        actions: [
          FutureBuilder<bool>(
            future: _isProvider(),
            builder: (context, snapshot) {
              final isProvider = snapshot.data ?? false;

              if (!isProvider) {
                // Don't show menu button if not a provider
                return SizedBox.shrink();
              }

              return PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.black),
                onSelected: (value) {
                  if (value == 'offer') {
                    final controller = Get.find<ChatController>();
                    final user = controller.currentChatUser.value;
                    
                    if (user != null && user.id.isNotEmpty) {
                      debugPrint('=================================');
                      debugPrint('Opening Create Offer Screen');
                      debugPrint('Receiver User ID: ${user.id}');
                      debugPrint('Conversation ID: ${user.conversationId}');
                      debugPrint('=================================');
                      
                      Get.to(() => CreateOfferScreen(
                        receiverUserId: user.id,
                        conversationId: user.conversationId?.toString() ?? '',
                      ));
                    } else {
                      debugPrint('❌ Error: User ID is empty or null');
                      Get.snackbar(
                        'Error',
                        'Cannot create offer: User information is missing',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  } else if (value == 'order') {
                    final controller = Get.find<ChatController>();
                    final user = controller.currentChatUser.value;
                    
                    debugPrint('=================================');
                    debugPrint('Create Order clicked');
                    debugPrint('Receiver User ID: ${user?.id}');
                    debugPrint('Conversation ID: ${user?.conversationId}');
                    debugPrint('=================================');
                    
                    if (user != null && user.id.isNotEmpty) {
                      // Navigate to Accepted Orders Screen
                      Get.to(() => AcceptedOrdersScreen(
                        receiverUserId: user.id,
                      ));
                    } else {
                      debugPrint('❌ Error: User ID is empty or null');
                      Get.snackbar(
                        'Error',
                        'Cannot load orders: User information is missing',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'offer', child: Text('Create Offer')),
                  PopupMenuItem(value: 'order', child: Text('Create Order')),
                ],
              );
            },
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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

                  // Send button
                  GestureDetector(
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
                      child: Icon(Icons.send, color: Colors.white, size: 20.sp),
                    ),
                  ),
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

    if (message.type == MessageType.order) {
      return _buildOrderMessage(message);
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
            bottomLeft: message.isMe
                ? Radius.circular(16.r)
                : Radius.circular(4.r),
            bottomRight: message.isMe
                ? Radius.circular(4.r)
                : Radius.circular(16.r),
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
            bottomLeft: message.isMe
                ? Radius.circular(16.r)
                : Radius.circular(4.r),
            bottomRight: message.isMe
                ? Radius.circular(4.r)
                : Radius.circular(16.r),
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
                    height:
                        (index % 3 == 0
                                ? 16
                                : index % 2 == 0
                                ? 12
                                : 8)
                            .h,
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
          crossAxisAlignment: message.isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: message.filePath != null
                  ? _buildImageWidget(message.filePath!)
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
              style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 11.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferMessage(ChatMessage message) {
    final offer = message.offerDetails;
    if (offer == null) return SizedBox.shrink();

    // Only show accept/decline buttons if the offer was sent by someone else (not me)
    // Provider sends offer (isMe = true), Receiver gets offer (isMe = false)
    final showButtons = !message.isMe;

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: message.isMe ? 300.w : double.infinity,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: slot.isSelected
                          ? Color(0xFF6B4CE6)
                          : Color(0xFFE0E0E0),
                      width: slot.isSelected ? 1.5 : 1,
                    ),
                    color: slot.isSelected ? Color(0xFFF3EDFF) : Colors.white,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        slot.isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: slot.isSelected
                            ? Color(0xFF6B4CE6)
                            : Color(0xFFBDBDBD),
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
            // Show buttons only if:
            // 1. The offer was received (not sent by me) - showButtons
            // 2. The offer is not yet accepted or declined
            if (showButtons && 
                (offer.quotationStatus == null || 
                (offer.quotationStatus != 'accepted' && 
                 offer.quotationStatus != 'declined')))
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () {
                        if (offer.quotationId != null) {
                          final controller = Get.find<ChatController>();
                          controller.updateOfferStatus(
                            offer.quotationId!,
                            'declined',
                          );
                        } else {
                          debugPrint('❌ Quotation ID is null');
                          Get.snackbar(
                            'Error',
                            'Cannot decline offer: Invalid quotation ID',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      child: Text(
                        offer.secondaryCtaText,
                        style: TextStyle(
                          color: Colors.white,
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
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () {
                        if (offer.quotationId != null) {
                          final controller = Get.find<ChatController>();
                          controller.updateOfferStatus(
                            offer.quotationId!,
                            'accepted',
                          );
                        } else {
                          debugPrint('❌ Quotation ID is null');
                          Get.snackbar(
                            'Error',
                            'Cannot accept offer: Invalid quotation ID',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
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
              )
            // Show status only for receivers (who got the offer and already acted on it)
            else if (showButtons)
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: offer.quotationStatus == 'accepted' 
                      ? Colors.green.withOpacity(0.1) 
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: offer.quotationStatus == 'accepted' 
                        ? Colors.green 
                        : Colors.red,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      offer.quotationStatus == 'accepted' 
                          ? Icons.check_circle 
                          : Icons.cancel,
                      color: offer.quotationStatus == 'accepted' 
                          ? Colors.green 
                          : Colors.red,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      offer.quotationStatus == 'accepted' 
                          ? 'Offer Accepted' 
                          : 'Offer Declined',
                      style: TextStyle(
                        color: offer.quotationStatus == 'accepted' 
                            ? Colors.green 
                            : Colors.red,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
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

  Widget _buildFileMessage(ChatMessage message) {
    final fileName = message.message;
    final isNetworkFile =
        message.filePath != null &&
        (message.filePath!.startsWith('http://') ||
            message.filePath!.startsWith('https://'));

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          if (message.filePath != null) {
            // TODO: Open/download file
            Get.snackbar(
              'File',
              isNetworkFile
                  ? 'Download from: ${message.filePath}'
                  : 'Local file: ${message.filePath}',
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
            );
          }
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          constraints: BoxConstraints(maxWidth: 280.w),
          decoration: BoxDecoration(
            color: message.isMe ? Color(0xFF6B4CE6) : Color(0xFFF5F5F5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
              bottomLeft: message.isMe
                  ? Radius.circular(16.r)
                  : Radius.circular(4.r),
              bottomRight: message.isMe
                  ? Radius.circular(4.r)
                  : Radius.circular(16.r),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isNetworkFile ? Icons.cloud_download : Icons.insert_drive_file,
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
                        color: message.isMe
                            ? Colors.white.withValues(alpha: .7)
                            : Color(0xFF9E9E9E),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build order notification message
  Widget _buildOrderMessage(ChatMessage message) {
    final order = message.orderDetails;
    if (order == null) return SizedBox.shrink();

    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📦 New Order Created',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Order #${order.orderId}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  _buildOrderInfoRow(
                    'Quotation ID',
                    '#${order.quotationId}',
                    Icons.receipt_long,
                  ),
                  SizedBox(height: 10.h),
                  _buildOrderInfoRow(
                    'Status',
                    order.orderStatus.toUpperCase(),
                    Icons.info_outline,
                  ),
                  SizedBox(height: 10.h),
                  _buildOrderInfoRow(
                    'Service Time',
                    order.serviceTimeTaken,
                    Icons.access_time,
                  ),
                  if (order.serviceDescription != null &&
                      order.serviceDescription!.isNotEmpty) ...[
                    SizedBox(height: 10.h),
                    Divider(color: Colors.white.withOpacity(0.3)),
                    SizedBox(height: 10.h),
                    Text(
                      order.serviceDescription!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 13.sp,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  message.time,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11.sp,
                  ),
                ),
                Text(
                  'From: ${message.senderName}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 18.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12.sp,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
