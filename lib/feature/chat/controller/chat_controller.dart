import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../model/chat_message_model.dart';
import 'package:service_connect/feature/conversation/repository/conversation_repository.dart';
import 'package:service_connect/feature/conversation/model/conversation_list_response_model.dart';

class ChatController extends GetxController {
  // Conversation repository
  final ConversationRepository _conversationRepository = ConversationRepository();
  
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
        return ChatUser(
          id: conversation.otherPerson.id,
          name: conversation.otherPerson.name,
          profileImage: conversation.otherPerson.image ?? '',
          lastMessage: conversation.lastMessage?.messageText ?? 'No messages yet',
          time: _formatTime(conversation.lastMessage?.createdAt ?? conversation.createdAt),
          unreadCount: 0, // You can add unread count logic if needed
          isOnline: false,
          isVerified: false,
        );
      }).toList();
      
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
          .where((user) =>
              user.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }

  // Open chat with a specific user
  void openChat(ChatUser user) {
    currentChatUser.value = user;
    _loadChatMessages(user.id);
  }

  // Load chat messages for a specific user
  void _loadChatMessages(String userId) {
    // Dummy messages for demonstration
    currentChatMessages.value = [
      ChatMessage(
        id: '1',
        senderId: userId,
        senderName: currentChatUser.value!.name,
        message: 'Hey, saw your tbr near the café! Wanna go grab a coffee on friday?',
        time: '9:41 AM',
        isMe: false,
      ),
      ChatMessage(
        id: '2',
        senderId: 'me',
        senderName: 'Me',
        message: 'I think that will perfect time',
        time: '9:42 AM',
        isMe: true,
        isRead: true,
      ),
      ChatMessage(
        id: '3',
        senderId: 'me',
        senderName: 'Me',
        message: 'Hey, I came Home sometimes. How about you ?',
        time: '9:43 AM',
        isMe: true,
        isRead: true,
      ),
      ChatMessage(
        id: '4',
        senderId: userId,
        senderName: currentChatUser.value!.name,
        message: 'Same! Want to grab a coffee together?',
        time: '9:45 AM',
        isMe: false,
      ),
      ChatMessage(
        id: '5',
        senderId: 'me',
        senderName: 'Me',
        message: 'Sure, this weekend?',
        time: '9:46 AM',
        isMe: true,
        isRead: true,
      ),
    ];
  }

  // Send text message
  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      senderName: 'Me',
      message: messageController.text.trim(),
      time: _getCurrentTime(),
      isMe: true,
      isRead: false,
    );

    currentChatMessages.add(newMessage);
    messageController.clear();
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
          final filePath = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
          
          await _audioRecorder.start(
            const RecordConfig(),
            path: filePath,
          );
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
    
    final newText = currentText.substring(0, cursorPosition) + 
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
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
      );

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
  void _sendFileMessage(String filePath, String fileName) {
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
  }
  
  // Send image message
  void _sendImageMessage(String imagePath) {
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
  }

  // Send offer style message (as seen in design)
  void sendOfferMessage({OfferDetails? customDetails}) {
    final user = currentChatUser.value;
    final offerDetails = customDetails ??
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
            OfferSlot(
              dayLabel: '09 January',
              timeLabel: '10:00 AM',
            ),
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

  // Clear search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    filterUsers();
  }
}