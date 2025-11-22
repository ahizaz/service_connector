import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '../model/chat_message_model.dart';

class ChatController extends GetxController {
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
    _loadDummyData();
    
    // Listen to search query changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      filterUsers();
    });

    messageController.addListener(() {
      messageText.value = messageController.text;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    messageController.dispose();
    _audioRecorder.dispose();
    super.onClose();
  }

  // Load dummy data
  void _loadDummyData() {
    allUsers.value = [
      ChatUser(
        id: '1',
        name: 'Annette Black',
        profileImage: 'assets/images/user1.png',
        lastMessage: 'Thank you! I will see you to...',
        time: '1h',
        unreadCount: 0,
      ),
      ChatUser(
        id: '2',
        name: 'Eleanor Pena',
        profileImage: 'assets/images/user2.png',
        lastMessage: "I'm gonna loo som curtos ut io..",
        time: '3h',
        unreadCount: 0,
      ),
      ChatUser(
        id: '3',
        name: 'Annette Black',
        profileImage: 'assets/images/user3.png',
        lastMessage: 'Thank you! I will see you to...',
        time: '4h',
        unreadCount: 0,
      ),
      ChatUser(
        id: '4',
        name: 'Eleanor Pena',
        profileImage: 'assets/images/user4.png',
        lastMessage: "I'm gonna loo som curtos ut io..",
        time: '5h',
        unreadCount: 0,
      ),
      ChatUser(
        id: '5',
        name: 'Eleanor Pena',
        profileImage: 'assets/images/user5.png',
        lastMessage: 'Could you send me a link t...',
        time: '6h',
        isVerified: true,
      ),
      ChatUser(
        id: '6',
        name: 'Annette Black',
        profileImage: 'assets/images/user6.png',
        lastMessage: 'Thank you! I will see you to...',
        time: '7h',
        unreadCount: 0,
      ),
      ChatUser(
        id: '7',
        name: 'Marvin McKinney',
        profileImage: 'assets/images/user7.png',
        lastMessage: 'Incoming...',
        time: '10h',
        unreadCount: 0,
      ),
      ChatUser(
        id: '8',
        name: 'Annette Black',
        profileImage: 'assets/images/user8.png',
        lastMessage: 'Thank you! I will see you to...',
        time: '4h',
        unreadCount: 0,
      ),
    ];
    filteredUsers.value = allUsers;
  }

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
    sendOfferMessage();
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