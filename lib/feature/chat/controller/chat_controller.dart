import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/chat_message_model.dart';
import 'package:service_connect/feature/conversation/repository/conversation_repository.dart';
import 'package:service_connect/feature/conversation/model/conversation_list_response_model.dart';

class ChatController extends GetxController {
  // Conversation repository
  final ConversationRepository _conversationRepository =
      ConversationRepository();

  // Loading state
  final RxBool isLoadingConversations = false.obs;

  // Search controller
  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Message input controller
  final messageController = TextEditingController();
  final RxString messageText = ''.obs;

  // Observable lists
  final RxList<ChatUser> allUsers = <ChatUser>[].obs;
  final RxList<ChatUser> filteredUsers = <ChatUser>[].obs;
  final RxList<ChatMessage> currentChatMessages = <ChatMessage>[].obs;

  // Current chat user
  final Rx<ChatUser?> currentChatUser = Rx<ChatUser?>(null);

  // Voice recording
  final RxBool isRecording = false.obs;
  final AudioRecorder _audioRecorder = AudioRecorder();
  DateTime? _recordingStartTime;

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();

  // Emoji picker
  final RxBool showEmojiPicker = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load conversations from API instead of dummy data
    fetchAllConversations();

    // Listen to search query changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      filterUsers();
    });

    messageController.addListener(() {
      messageText.value = messageController.text;
    });
  }

  /// Fetch all conversations from API
  Future<void> fetchAllConversations() async {
    try {
      isLoadingConversations.value = true;
      EasyLoading.show(status: 'Loading conversations...');

      debugPrint('=================================');
      debugPrint('ChatController: Fetching conversations');
      debugPrint('=================================');

      final response = await _conversationRepository.getAllConversations();

      debugPrint('=================================');
      debugPrint('ChatController: Got ${response.count} conversations');
      debugPrint('=================================');

      // Convert API response to ChatUser list
      final List<ChatUser> users = response.results.map((conversation) {
        debugPrint(
          '>>> Conversation: ID=${conversation.conversationId}, Status="${conversation.conversationStatus}", User=${conversation.otherPerson.name}',
        );

        return ChatUser(
          id: conversation.otherPerson.id,
          name: conversation.otherPerson.name,
          profileImage: conversation.otherPerson.image ?? '',
          lastMessage:
              conversation.lastMessage?.messageText ?? 'No messages yet',
          time: _formatTime(
            conversation.lastMessage?.createdAt ?? conversation.createdAt,
          ),
          unreadCount: 0, // You can add unread count logic if needed
          isOnline: false,
          isVerified: false,
          conversationId: conversation.conversationId,
          conversationStatus: conversation.conversationStatus,
        );
      }).toList();

      debugPrint('=================================');
      debugPrint('Total users created: ${users.length}');
      for (var user in users) {
        debugPrint(
          'User: ${user.name}, ConvID: ${user.conversationId}, Status: "${user.conversationStatus}"',
        );
      }
      debugPrint('=================================');

      allUsers.value = users;
      filteredUsers.value = users;

      EasyLoading.dismiss();
      isLoadingConversations.value = false;
    } catch (e) {
      EasyLoading.dismiss();
      isLoadingConversations.value = false;
      debugPrint('Error fetching conversations: $e');

      Get.snackbar(
        'Error',
        'Failed to load conversations: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  /// Format timestamp to relative time (1h, 2d, etc.)
  String _formatTime(String timestamp) {
    try {
      final DateTime dateTime = DateTime.parse(timestamp);
      final Duration difference = DateTime.now().difference(dateTime);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d';
      } else {
        return '${(difference.inDays / 7).floor()}w';
      }
    } catch (e) {
      return 'now';
    }
  }

  /// Format message timestamp to time (9:41 AM)
  String _formatMessageTime(String timestamp) {
    try {
      final DateTime dateTime = DateTime.parse(timestamp);
      final int hour = dateTime.hour;
      final int minute = dateTime.minute;
      final String period = hour >= 12 ? 'PM' : 'AM';
      final int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

      return '${displayHour}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return 'now';
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    messageController.dispose();
    _audioRecorder.dispose();
    super.onClose();
  }

  // ❌ OLD: Load dummy data - replaced with fetchAllConversations()
  // void _loadDummyData() {
  //   allUsers.value = [
  //     ChatUser(id: '1', name: 'Annette Black', ...),
  //     ...
  //   ];
  //   filteredUsers.value = allUsers;
  // }

  // Filter users based on search query
  void filterUsers() {
    if (searchQuery.value.isEmpty) {
      filteredUsers.value = allUsers;
    } else {
      filteredUsers.value = allUsers
          .where(
            (user) => user.name.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  // Open chat with a specific user
  void openChat(ChatUser user) {
    currentChatUser.value = user;
    // Load messages if conversation ID exists
    if (user.conversationId != null) {
      fetchConversationMessages(user.conversationId!);
    } else {
      // No conversation yet, empty messages
      currentChatMessages.value = [];
    }
  }

  // Fetch messages from API for a specific conversation
  Future<void> fetchConversationMessages(int conversationId) async {
    try {
      EasyLoading.show(status: 'Loading messages...');

      debugPrint('=================================');
      debugPrint(
        'ChatController: Fetching messages for conversation $conversationId',
      );
      debugPrint('=================================');

      final response = await _conversationRepository.getConversationMessages(
        conversationId,
      );

      // Get current logged-in user ID
      final prefs = await SharedPreferences.getInstance();
      final loggedInUserId = prefs.getString('userId') ?? '';

      debugPrint('=================================');
      debugPrint('Logged-in User ID: "$loggedInUserId"');
      debugPrint('Got ${response.count} messages');
      debugPrint('=================================');

      // Convert API messages to ChatMessage list
      final List<ChatMessage> messages = response.results.map((message) {
        // Check if the message sender is the logged-in user
        // Compare with trim to ensure no whitespace issues
        final isMe = message.senderId.trim() == loggedInUserId.trim();

        // Determine message type and file path based on API response
        MessageType messageType = MessageType.text;
        String? filePath;
        String displayMessage = message.messageText ?? '';

        if (message.messageImage != null && message.messageImage!.isNotEmpty) {
          messageType = MessageType.image;
          filePath = message.messageImage;
          displayMessage = 'Image';
        } else if (message.messageFile != null &&
            message.messageFile!.isNotEmpty) {
          messageType = MessageType.file;
          filePath = message.messageFile;
          // Extract filename from URL if possible
          displayMessage = message.messageFile!.split('/').last;
        } else if (message.messageVoice != null &&
            message.messageVoice!.isNotEmpty) {
          messageType = MessageType.voice;
          filePath = message.messageVoice;
          displayMessage = 'Voice message';
        }

        debugPrint('-----------------------------------');
        debugPrint('Message: ${message.messageText}');
        debugPrint('  Sender ID: "${message.senderId}"');
        debugPrint('  Logged-in ID: "$loggedInUserId"');
        debugPrint(
          '  IDs Match: ${message.senderId.trim() == loggedInUserId.trim()}',
        );
        debugPrint('  Is Me (RIGHT side): $isMe');
        debugPrint('  Message Type: $messageType');
        debugPrint('  File Path: $filePath');
        debugPrint('-----------------------------------');

        return ChatMessage(
          id: message.messageId.toString(),
          senderId: message.senderId,
          senderName: message.senderName,
          message: displayMessage,
          time: _formatMessageTime(message.createdAt),
          isMe: isMe,
          isRead: false, // You can add read status logic if needed
          type: messageType,
          filePath: filePath,
        );
      }).toList();

      currentChatMessages.value = messages;

      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Error fetching messages: $e');

      Get.snackbar(
        'Error',
        'Failed to load messages: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  // Load chat messages for a specific user (OLD - DUMMY DATA)
  // This method is replaced by fetchConversationMessages
  void _loadChatMessages(String userId) {
    // This is now handled by fetchConversationMessages
    currentChatMessages.value = [];
  }

  // Send text message
  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    final user = currentChatUser.value;
    if (user == null || user.conversationId == null) {
      Get.snackbar(
        'Error',
        'No active conversation',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    final messageText = messageController.text.trim();

    // Add message to UI immediately for better UX
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      senderName: 'Me',
      message: messageText,
      time: _getCurrentTime(),
      isMe: true,
      isRead: false,
    );

    currentChatMessages.add(newMessage);
    messageController.clear();

    // Send message to API
    try {
      await _conversationRepository.sendMessage(
        conversationId: user.conversationId!,
        messageText: messageText,
      );

      debugPrint('Message sent successfully to API');
    } catch (e) {
      debugPrint('Error sending message: $e');
      Get.snackbar(
        'Error',
        'Failed to send message: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  // Toggle voice recording
  Future<void> toggleRecording() async {
    if (isRecording.value) {
      // Stop recording
      final path = await _audioRecorder.stop();
      final duration = _recordingStartTime != null
          ? DateTime.now().difference(_recordingStartTime!).inSeconds
          : 0;
      isRecording.value = false;
      _recordingStartTime = null;

      if (path != null) {
        _sendVoiceMessage(path, duration);
      }
    } else {
      // Start recording
      try {
        if (await _audioRecorder.hasPermission()) {
          final directory = await getApplicationDocumentsDirectory();
          final filePath =
              '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

          await _audioRecorder.start(const RecordConfig(), path: filePath);
          _recordingStartTime = DateTime.now();
          isRecording.value = true;
        }
      } catch (e) {
        debugPrint('Error starting recording: $e');
      }
    }
  }

  // Send voice message
  void _sendVoiceMessage(String audioPath, int durationInSeconds) {
    final voiceMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      senderName: 'Me',
      message: 'Voice message',
      time: _getCurrentTime(),
      isMe: true,
      type: MessageType.voice,
      filePath: audioPath,
      duration: durationInSeconds,
    );
    currentChatMessages.add(voiceMessage);
  }

  // Toggle emoji picker
  void toggleEmojiPicker() {
    showEmojiPicker.value = !showEmojiPicker.value;
  }

  // Add emoji to message
  void addEmoji(String emoji) {
    final currentText = messageController.text;
    final selection = messageController.selection;

    // Handle invalid selection
    final cursorPosition = selection.baseOffset >= 0
        ? selection.baseOffset
        : currentText.length;

    final newText =
        currentText.substring(0, cursorPosition) +
        emoji +
        currentText.substring(cursorPosition);

    messageController.text = newText;
    messageController.selection = TextSelection.collapsed(
      offset: cursorPosition + emoji.length,
    );
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        _sendImageMessage(image.path);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        _sendImageMessage(image.path);
      }
    } catch (e) {
      debugPrint('Error capturing image: $e');
    }
  }

  // Pick generic file (documents)
  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);

      if (result != null && result.files.isNotEmpty) {
        final picked = result.files.first;
        final path = picked.path;
        if (path != null) {
          _sendFileMessage(path, picked.name);
        }
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  // Send file/document message
  Future<void> _sendFileMessage(String filePath, String fileName) async {
    final user = currentChatUser.value;
    if (user == null || user.conversationId == null) {
      Get.snackbar(
        'Error',
        'No active conversation',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    // Add file message to UI immediately
    final fileMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      senderName: 'Me',
      message: fileName,
      time: _getCurrentTime(),
      isMe: true,
      type: MessageType.file,
      filePath: filePath,
    );
    currentChatMessages.add(fileMessage);

    // Send file to API
    try {
      final file = File(filePath);
      await _conversationRepository.sendMessage(
        conversationId: user.conversationId!,
        messageFile: file,
      );

      debugPrint('File sent successfully to API');
    } catch (e) {
      debugPrint('Error sending file: $e');
      Get.snackbar(
        'Error',
        'Failed to send file: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  // Send image message
  Future<void> _sendImageMessage(String imagePath) async {
    final user = currentChatUser.value;
    if (user == null || user.conversationId == null) {
      Get.snackbar(
        'Error',
        'No active conversation',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    // Add image message to UI immediately
    final imageMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      senderName: 'Me',
      message: 'Image',
      time: _getCurrentTime(),
      isMe: true,
      type: MessageType.image,
      filePath: imagePath,
    );
    currentChatMessages.add(imageMessage);

    // Send image to API
    try {
      final imageFile = File(imagePath);
      await _conversationRepository.sendMessage(
        conversationId: user.conversationId!,
        messageImage: imageFile,
      );

      debugPrint('Image sent successfully to API');
    } catch (e) {
      debugPrint('Error sending image: $e');
      Get.snackbar(
        'Error',
        'Failed to send image: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  // Send offer style message (as seen in design)
  void sendOfferMessage({OfferDetails? customDetails}) {
    final user = currentChatUser.value;
    final offerDetails =
        customDetails ??
        OfferDetails(
          title: 'Offer',
          workDetails:
              'As an AC service technician, I specialize in the installation, maintenance, and repair of air conditioning systems.',
          slots: [
            OfferSlot(
              dayLabel: '08 January',
              timeLabel: '10:00 AM',
              isSelected: true,
            ),
            OfferSlot(dayLabel: '09 January', timeLabel: '10:00 AM'),
          ],
          secondaryCtaText: 'Cancel Offer',
          primaryCtaText: 'Accept Offer',
        );

    final offerMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: user?.id ?? 'user',
      senderName: user?.name ?? 'Service Provider',
      message: 'Offer',
      time: _getCurrentTime(),
      isMe: false,
      type: MessageType.offer,
      offerDetails: offerDetails,
    );

    currentChatMessages.add(offerMessage);
  }

  // Get current time formatted
  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  // Accept or decline conversation
  Future<void> updateConversationStatus(
    int conversationId,
    String action,
  ) async {
    try {
      EasyLoading.show(
        status: '${action == 'accept' ? 'Accepting' : 'Declining'}...',
      );

      debugPrint('=================================');
      debugPrint('ChatController: Updating conversation status');
      debugPrint('Conversation ID: $conversationId');
      debugPrint('Action: $action');
      debugPrint('=================================');

      await _conversationRepository.updateConversationStatus(
        conversationId,
        action,
      );

      EasyLoading.dismiss();

      debugPrint('=================================');
      debugPrint('Conversation ${action}ed successfully');
      debugPrint('=================================');

      // Refresh conversations list
      await fetchAllConversations();

      // Show success message
      Get.snackbar(
        'Success',
        'Conversation ${action}ed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Error updating conversation status: $e');

      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  // Show accept/decline dialog for provider
  void showAcceptDeclineDialog() {
    final user = currentChatUser.value;
    if (user == null || user.conversationId == null) {
      debugPrint(
        'Cannot show dialog: user=$user, conversationId=${user?.conversationId}',
      );
      return;
    }

    // Check if conversation is pending (case-insensitive)
    if (user.conversationStatus?.toLowerCase() != 'pending') {
      debugPrint(
        'Cannot show dialog: status is not pending, it is "${user.conversationStatus}"',
      );
      return;
    }

    debugPrint('=================================');
    debugPrint('Showing accept/decline dialog');
    debugPrint('Conversation ID: ${user.conversationId}');
    debugPrint('Status: ${user.conversationStatus}');
    debugPrint('=================================');

    Get.dialog(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Do you want to accept message?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back(); // Close dialog
                          updateConversationStatus(
                            user.conversationId!,
                            'decline',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Decline',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back(); // Close dialog
                          updateConversationStatus(
                            user.conversationId!,
                            'accept',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Accept',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black54,
    );
  }

  // Clear search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    filterUsers();
  }
}
