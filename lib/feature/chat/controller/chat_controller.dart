import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/chat_message_model.dart';

class ChatController extends GetxController {
  // Search controller
  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Message input controller
  final messageController = TextEditingController();

  // Observable lists
  final RxList<ChatUser> allUsers = <ChatUser>[].obs;
  final RxList<ChatUser> filteredUsers = <ChatUser>[].obs;
  final RxList<ChatMessage> currentChatMessages = <ChatMessage>[].obs;

  // Current chat user
  final Rx<ChatUser?> currentChatUser = Rx<ChatUser?>(null);

  // Voice recording
  final RxBool isRecording = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
    
    // Listen to search query changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      filterUsers();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    messageController.dispose();
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
  void toggleRecording() {
    isRecording.value = !isRecording.value;
    if (!isRecording.value) {
      // Save voice message
      _sendVoiceMessage();
    }
  }

  // Send voice message
  void _sendVoiceMessage() {
    final voiceMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      senderName: 'Me',
      message: 'Voice message',
      time: _getCurrentTime(),
      isMe: true,
      type: MessageType.voice,
    );
    currentChatMessages.add(voiceMessage);
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