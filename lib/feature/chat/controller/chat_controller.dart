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
import 'package:url_launcher/url_launcher.dart';
import '../model/chat_message_model.dart';
import '../model/websocket_message_model.dart';
import 'package:service_connect/feature/conversation/repository/conversation_repository.dart';
import 'package:service_connect/core/services/websocket_service.dart';
import 'package:service_connect/core/auth/auth_service.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:service_connect/core/urls/urls.dart';

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

  // WebSocket service
  final WebSocketService _webSocketService = WebSocketService();
  final RxBool isWebSocketConnected = false.obs;
  StreamSubscription? _webSocketMessageSubscription;
  StreamSubscription? _webSocketConnectionSubscription;
  String? _currentUserId;

  @override
  void onInit() async {
    super.onInit();

    // Get current user ID
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getString('userId') ?? '';

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

    // Listen to WebSocket messages
    _setupWebSocketListeners();
  }

  /// Setup WebSocket listeners
  void _setupWebSocketListeners() {
    // Listen to incoming messages
    _webSocketMessageSubscription = _webSocketService.messageStream.listen((
      data,
    ) {
      debugPrint('📩 WebSocket message received in controller: $data');
      _handleWebSocketMessage(data);
    });

    // Listen to connection status
    _webSocketConnectionSubscription = _webSocketService.connectionStatusStream
        .listen((isConnected) {
          debugPrint('🔌 WebSocket connection status: $isConnected');
          isWebSocketConnected.value = isConnected;

          if (isConnected) {
            EasyLoading.showSuccess('Connected to live chat');
          } else {
            EasyLoading.showError('Disconnected from live chat');
          }
        });
  }

  /// Handle incoming WebSocket messages
  void _handleWebSocketMessage(Map<String, dynamic> data) {
    try {
      debugPrint('=================================');
      debugPrint('📩 WebSocket Data Received: $data');
      debugPrint('=================================');

      // Parse WebSocket message
      final wsMessage = WebSocketMessage.fromJson(data);

      debugPrint('✅ Parsed message: ${wsMessage.messageText}');
      debugPrint('   From: ${wsMessage.senderName} (${wsMessage.senderId})');

      // Check if this is a payment link message (offer accepted)
      // Only show payment link to the service receiver (the one who accepted the offer)
      if (wsMessage.quotationStatus == 'accepted' &&
          wsMessage.paymentLink != null &&
          wsMessage.paymentLink!.isNotEmpty &&
          wsMessage.senderId == _currentUserId) {
        debugPrint('=================================');
        debugPrint('💳 PAYMENT LINK RECEIVED');
        debugPrint('Quotation ID: ${wsMessage.quotationId}');
        debugPrint('Payment Link: ${wsMessage.paymentLink}');
        debugPrint('Sender ID: ${wsMessage.senderId}');
        debugPrint('Current User ID: $_currentUserId');
        debugPrint('You accepted the offer - showing payment dialog');
        debugPrint('=================================');

        EasyLoading.showSuccess('Offer accepted! Payment link received.');

        // Show payment dialog after a brief delay
        Future.delayed(Duration(milliseconds: 500), () {
          _showPaymentLinkDialog(
            wsMessage.paymentLink!,
            wsMessage.quotationId ?? 0,
          );
        });

        // If this is just a status update without a proper message, update existing offer if found
        if (wsMessage.messageId == null) {
          debugPrint(
            '⚠️ Status update only, checking if we need to update existing offer',
          );

          // Try to update existing offer message if quotation ID matches
          if (wsMessage.quotationId != null &&
              wsMessage.quotationStatus != null) {
            final offerIndex = currentChatMessages.indexWhere(
              (msg) => msg.offerDetails?.quotationId == wsMessage.quotationId,
            );

            if (offerIndex != -1) {
              final existingMessage = currentChatMessages[offerIndex];
              // Normalize status to lowercase for consistency
              final normalizedStatus = wsMessage.quotationStatus
                  ?.toLowerCase()
                  .trim();
              final updatedOffer = OfferDetails(
                title: existingMessage.offerDetails!.title,
                workDetails: existingMessage.offerDetails!.workDetails,
                slots: existingMessage.offerDetails!.slots,
                primaryCtaText: existingMessage.offerDetails!.primaryCtaText,
                secondaryCtaText:
                    existingMessage.offerDetails!.secondaryCtaText,
                quotationId: existingMessage.offerDetails!.quotationId,
                quotationStatus: normalizedStatus,
                acceptUrl: existingMessage.offerDetails!.acceptUrl,
                rejectUrl: existingMessage.offerDetails!.rejectUrl,
                paymentLink:
                    wsMessage.paymentLink ??
                    existingMessage.offerDetails!.paymentLink,
                termsConditions: existingMessage.offerDetails!.termsConditions,
              );

              currentChatMessages[offerIndex] = ChatMessage(
                id: existingMessage.id,
                senderId: existingMessage.senderId,
                senderName: existingMessage.senderName,
                message: existingMessage.message,
                time: existingMessage.time,
                isMe: existingMessage.isMe,
                isRead: existingMessage.isRead,
                type: existingMessage.type,
                filePath: existingMessage.filePath,
                duration: existingMessage.duration,
                offerDetails: updatedOffer,
              );

              debugPrint(
                '✅ Updated existing offer status via WebSocket to: ${wsMessage.quotationStatus}',
              );
            }
          }
          return;
        }
      } else if (wsMessage.quotationStatus == 'accepted' &&
          wsMessage.paymentLink != null &&
          wsMessage.paymentLink!.isNotEmpty &&
          wsMessage.senderId != _currentUserId) {
        debugPrint('=================================');
        debugPrint('✅ OFFER ACCEPTED CONFIRMATION');
        debugPrint('Service receiver accepted your offer');
        debugPrint('Sender ID: ${wsMessage.senderId}');
        debugPrint('Current User ID: $_currentUserId');
        debugPrint('Not showing payment link to service provider');
        debugPrint('=================================');
      }

      // Convert to ChatMessage and add to list (only if it has a valid message ID)
      if (wsMessage.messageId != null) {
        final chatMessage = wsMessage.toChatMessage(_currentUserId ?? '');

        // Check if message already exists (to avoid duplicates)
        final existingIndex = currentChatMessages.indexWhere(
          (msg) => msg.id == chatMessage.id,
        );

        if (existingIndex == -1) {
          // If this is our own message, check if we have a temporary optimistic message
          if (chatMessage.isMe) {
            // Find the most recent temporary message with matching type
            // For image/file, we match by type and recency (within last 10 seconds)
            int tempIndex = -1;

            if (chatMessage.type == MessageType.image ||
                chatMessage.type == MessageType.file) {
              // For images/files, find the last temp message of same type (recent one)
              for (int i = currentChatMessages.length - 1; i >= 0; i--) {
                final msg = currentChatMessages[i];
                if (msg.isMe &&
                    msg.id.startsWith('temp_') &&
                    msg.type == chatMessage.type) {
                  tempIndex = i;
                  break; // Found the most recent temp message
                }
              }
            } else {
              // For text messages, match by content
              tempIndex = currentChatMessages.indexWhere(
                (msg) =>
                    msg.isMe &&
                    msg.id.startsWith('temp_') &&
                    msg.type == chatMessage.type &&
                    msg.message == chatMessage.message,
              );
            }

            if (tempIndex != -1) {
              // Replace temporary message with real one
              currentChatMessages[tempIndex] = chatMessage;
              debugPrint(
                '✅ Replaced temporary message with real message (type: ${chatMessage.type})',
              );
              return;
            }
          }

          // Add new message
          currentChatMessages.add(chatMessage);
          debugPrint('✅ Message added to chat list');
        } else {
          // If it's a duplicate message but has status update, update the existing message
          if (wsMessage.quotationId != null &&
              wsMessage.quotationStatus != null &&
              chatMessage.offerDetails != null) {
            final existingMessage = currentChatMessages[existingIndex];
            // Update offer status if it exists
            if (existingMessage.offerDetails?.quotationId ==
                wsMessage.quotationId) {
              // Normalize status to lowercase for consistency
              final normalizedStatus = wsMessage.quotationStatus
                  ?.toLowerCase()
                  .trim();
              final updatedOffer = OfferDetails(
                title: existingMessage.offerDetails!.title,
                workDetails: existingMessage.offerDetails!.workDetails,
                slots: existingMessage.offerDetails!.slots,
                primaryCtaText: existingMessage.offerDetails!.primaryCtaText,
                secondaryCtaText:
                    existingMessage.offerDetails!.secondaryCtaText,
                quotationId: existingMessage.offerDetails!.quotationId,
                quotationStatus: normalizedStatus,
                acceptUrl: existingMessage.offerDetails!.acceptUrl,
                rejectUrl: existingMessage.offerDetails!.rejectUrl,
                paymentLink:
                    wsMessage.paymentLink ??
                    existingMessage.offerDetails!.paymentLink,
                termsConditions: existingMessage.offerDetails!.termsConditions,
              );

              currentChatMessages[existingIndex] = ChatMessage(
                id: existingMessage.id,
                senderId: existingMessage.senderId,
                senderName: existingMessage.senderName,
                message: existingMessage.message,
                time: existingMessage.time,
                isMe: existingMessage.isMe,
                isRead: existingMessage.isRead,
                type: existingMessage.type,
                filePath: existingMessage.filePath,
                duration: existingMessage.duration,
                offerDetails: updatedOffer,
              );

              debugPrint(
                '✅ Updated existing offer status to: ${wsMessage.quotationStatus}',
              );
              return;
            }
          }
          debugPrint('⚠️ Duplicate message, skipping');
        }
      }
    } catch (e, stackTrace) {
      debugPrint('=================================');
      debugPrint('❌ Error handling WebSocket message: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('=================================');
    }
  }

  /// Connect to WebSocket for a conversation
  void connectToWebSocket(int conversationId) {
    final token = AuthService.getToken();

    if (token == null || token.isEmpty) {
      debugPrint('❌ Cannot connect to WebSocket: No auth token');
      EasyLoading.showError('Authentication required');
      return;
    }

    final url =
        'wss://6zpmb4x8-8009.inc1.devtunnels.ms/ws/chat/$conversationId/?token=$token';

    debugPrint('🔌 Connecting to WebSocket: $url');
    EasyLoading.show(status: 'Connecting to live chat...');

    _webSocketService.connect(url);
  }

  /// Disconnect from WebSocket
  void disconnectWebSocket() {
    debugPrint('🔌 Disconnecting from WebSocket');
    _webSocketService.disconnect();
  }

  /// Send message through WebSocket
  void sendWebSocketMessage(Map<String, dynamic> message) {
    if (!isWebSocketConnected.value) {
      debugPrint('❌ Cannot send WebSocket message: Not connected');
      return;
    }

    try {
      _webSocketService.sendMessage(message);
      debugPrint('✅ WebSocket message sent successfully');
    } catch (e) {
      debugPrint('❌ Error sending WebSocket message: $e');
    }
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

        // Determine last message display text based on type
        String lastMessageDisplay = 'No messages yet';
        if (conversation.lastMessage != null) {
          final messageType = conversation.lastMessage!.messageType;
          if (messageType == 'image') {
            lastMessageDisplay = '📷 Photo';
          } else if (messageType == 'voice') {
            lastMessageDisplay = '🎤 Voice message';
          } else if (messageType == 'file') {
            lastMessageDisplay = '📎 File';
          } else if (messageType == 'order') {
            lastMessageDisplay = '📦 New Order';
          } else if (messageType == 'offer') {
            lastMessageDisplay = '💼 New Offer';
          } else {
            lastMessageDisplay = conversation.lastMessage!.messageText;
          }
        }

        return ChatUser(
          id: conversation.otherPerson.id,
          name: conversation.otherPerson.name,
          profileImage: conversation.otherPerson.image ?? '',
          lastMessage: lastMessageDisplay,
          time: _formatTime(
            conversation.lastMessage?.createdAt ?? conversation.createdAt,
          ),
          unreadCount: 0, // You can add unread count logic if needed
          isOnline: false,
          isVerified: false,
          conversationId: conversation.conversationId,
          conversationStatus: conversation.conversationStatus,
          lastMessageType: conversation.lastMessage?.messageType,
          lastMessageFilePath: conversation.lastMessage?.filePath,
          serviceTitle: conversation.otherPerson.serviceTitle,
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
        backgroundColor: Colors.red.withValues(alpha: .9),
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

      return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return 'now';
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    messageController.dispose();
    _audioRecorder.dispose();

    // Dispose WebSocket resources
    _webSocketMessageSubscription?.cancel();
    _webSocketConnectionSubscription?.cancel();
    _webSocketService.dispose();

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

    // Disconnect from previous WebSocket if any
    disconnectWebSocket();

    // Load messages if conversation ID exists
    if (user.conversationId != null) {
      fetchConversationMessages(user.conversationId!);

      // Connect to WebSocket for live messaging
      connectToWebSocket(user.conversationId!);
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
        OfferDetails? offerDetails;
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
        } else if (message.quotationId != null) {
          // This is an offer message
          messageType = MessageType.offer;

          // Normalize quotation status to lowercase for consistent comparison
          final normalizedStatus = message.quotationStatus
              ?.toLowerCase()
              .trim();

          debugPrint('📋 OFFER MESSAGE - ID: ${message.quotationId}');
          debugPrint(
            '   Raw Quotation Status from API: "${message.quotationStatus}"',
          );
          debugPrint('   Normalized Status: "$normalizedStatus"');
          debugPrint('   Is Accepted: ${normalizedStatus == "accepted"}');
          debugPrint('   Is Declined: ${normalizedStatus == "declined"}');

          offerDetails = OfferDetails(
            title: 'New Offer',
            workDetails: message.messageText ?? '',
            slots: [],
            quotationId: message.quotationId,
            quotationStatus:
                normalizedStatus, // Store normalized (lowercase) status
            acceptUrl: message.acceptUrl,
            rejectUrl: message.rejectUrl,
            termsConditions: message.termsConditions,
          );

          debugPrint(
            '   ✅ Offer Details created with status: "${offerDetails.quotationStatus}"',
          );
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
        debugPrint('  Quotation ID: ${message.quotationId}');
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
          offerDetails: offerDetails,
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
        backgroundColor: Colors.red.withValues(alpha: .9),
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
        backgroundColor: Colors.red.withValues(alpha: .9),
        colorText: Colors.white,
      );
      return;
    }

    final messageText = messageController.text.trim();

    // Add message to UI immediately for better UX (optimistic update)
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final newMessage = ChatMessage(
      id: tempId,
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

      debugPrint('✅ Message sent successfully to API');
      debugPrint(
        '📩 WebSocket will receive the message and update UI automatically',
      );
    } catch (e) {
      debugPrint('❌ Error sending message: $e');
      Get.snackbar(
        'Error',
        'Failed to send message: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: .9),
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
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final voiceMessage = ChatMessage(
      id: tempId,
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
        backgroundColor: Colors.red.withValues(alpha: .9),
        colorText: Colors.white,
      );
      return;
    }

    // Add file message to UI immediately (optimistic update)
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final fileMessage = ChatMessage(
      id: tempId,
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
        backgroundColor: Colors.red.withValues(alpha: .9),
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
        backgroundColor: Colors.red.withValues(alpha: .9),
        colorText: Colors.white,
      );
      return;
    }

    // Add image message to UI immediately (optimistic update)
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final imageMessage = ChatMessage(
      id: tempId,
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
        backgroundColor: Colors.red.withValues(alpha: .9),
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
        backgroundColor: Colors.green.withValues(alpha: .9),
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
        backgroundColor: Colors.red.withValues(alpha: .9),
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
                        child: const Text(
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

  // Cancel Offer (for service receiver)
  Future<void> cancelOffer(int quotationId, String cancellationReason) async {
    try {
      EasyLoading.show(status: 'Canceling offer...');

      final token = AuthService.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ Authentication token is missing');
        EasyLoading.dismiss();
        Get.snackbar(
          'Authentication Error',
          'Please login again',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: .9),
          colorText: Colors.white,
        );
        return;
      }

      debugPrint('=================================');
      debugPrint('📤 CANCELING OFFER');
      debugPrint('Quotation ID: $quotationId');
      debugPrint('Cancellation Reason: $cancellationReason');
      debugPrint('API URL: ${Url.cancelquotebyReceiver(quotationId)}');
      debugPrint('Authorization: Bearer $token');
      debugPrint('=================================');

      final requestBody = json.encode({
        'cancellation_reason': cancellationReason,
      });

      debugPrint('📦 Request Body: $requestBody');

      final response = await http.post(
        Uri.parse(Url.cancelquotebyReceiver(quotationId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      debugPrint('=================================');
      debugPrint('📥 API RESPONSE');
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");
      debugPrint('=================================');

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Offer canceled successfully in API');

        // Update the offer status to 'canceled' in the message list
        final messageIndex = currentChatMessages.indexWhere(
          (msg) => msg.offerDetails?.quotationId == quotationId,
        );

        if (messageIndex != -1) {
          final message = currentChatMessages[messageIndex];
          final updatedOffer = OfferDetails(
            title: message.offerDetails!.title,
            workDetails: message.offerDetails!.workDetails,
            slots: message.offerDetails!.slots,
            primaryCtaText: message.offerDetails!.primaryCtaText,
            secondaryCtaText: message.offerDetails!.secondaryCtaText,
            quotationId: message.offerDetails!.quotationId,
            quotationStatus: 'canceled', // Set status to canceled
            acceptUrl: message.offerDetails!.acceptUrl,
            rejectUrl: message.offerDetails!.rejectUrl,
            paymentLink: message.offerDetails!.paymentLink,
            termsConditions: message.offerDetails!.termsConditions,
          );

          currentChatMessages[messageIndex] = ChatMessage(
            id: message.id,
            senderId: message.senderId,
            senderName: message.senderName,
            message: message.message,
            time: message.time,
            isMe: message.isMe,
            isRead: message.isRead,
            type: message.type,
            filePath: message.filePath,
            duration: message.duration,
            offerDetails: updatedOffer,
          );

          debugPrint('✅ Updated offer status to canceled in UI');
        }

        Get.snackbar(
          'Success',
          'Offer canceled successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: .9),
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      } else if (response.statusCode == 400) {
        // Handle 400 errors - offer already converted to order or already canceled
        String errorMessage = 'Failed to cancel offer. Please try again.';
        
        try {
          final errorBody = json.decode(response.body);
          final errorText = errorBody['error']?.toString() ?? errorBody['message']?.toString() ?? '';
          
          if (errorText.toLowerCase().contains('order already created')) {
            errorMessage = 'This offer has been converted to an order. Please use order cancellation instead.';
            debugPrint("⚠️ Offer already converted to order");
          } else if (errorText.toLowerCase().contains('already cancel')) {
            errorMessage = 'This offer has already been cancelled.';
            debugPrint("⚠️ Offer already cancelled");
          } else if (errorText.isNotEmpty) {
            errorMessage = errorText;
          }
        } catch (e) {
          debugPrint("⚠️ Could not parse error response: $e");
        }
        
        debugPrint("❌ Failed to cancel offer: ${response.statusCode} - $errorMessage");
        Get.snackbar(
          'Cannot Cancel Offer',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withValues(alpha: .9),
          colorText: Colors.white,
          duration: Duration(seconds: 4),
        );
      } else {
        debugPrint("❌ Failed to cancel offer: ${response.statusCode}");
        Get.snackbar(
          'Error',
          'Failed to cancel offer. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: .9),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ Error canceling offer: $e');
      Get.snackbar(
        'Error',
        "Failed to cancel offer: ${e.toString().replaceAll('Exception: ', '')}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: .9),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  // Update Offer Status (Accept/Decline)
  Future<void> updateOfferStatus(int quotationId, String status) async {
    try {
      EasyLoading.show(status: 'Updating offer status...');

      final token = AuthService.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ Authentication token is missing');
        EasyLoading.dismiss();
        Get.snackbar(
          'Authentication Error',
          'Please login again',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: .9),
          colorText: Colors.white,
        );
        return;
      }

      debugPrint('=================================');
      debugPrint('📤 UPDATING OFFER STATUS');
      debugPrint('Quotation ID: $quotationId');
      debugPrint('Status: $status');
      debugPrint('API URL: ${Url.updateOfferStatus(quotationId)}');
      debugPrint('=================================');

      final response = await http.patch(
        Uri.parse(Url.updateOfferStatus(quotationId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'quotation_status': status}),
      );

      debugPrint('=================================');
      debugPrint('📥 API RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('=================================');

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Offer status updated successfully in API');

        // Update the offer status in the message list
        final messageIndex = currentChatMessages.indexWhere(
          (msg) => msg.offerDetails?.quotationId == quotationId,
        );

        if (messageIndex != -1) {
          final message = currentChatMessages[messageIndex];
          // Normalize status to lowercase for consistency
          final normalizedStatus = status.toLowerCase().trim();
          final updatedOffer = OfferDetails(
            title: message.offerDetails!.title,
            workDetails: message.offerDetails!.workDetails,
            slots: message.offerDetails!.slots,
            primaryCtaText: message.offerDetails!.primaryCtaText,
            secondaryCtaText: message.offerDetails!.secondaryCtaText,
            quotationId: message.offerDetails!.quotationId,
            quotationStatus: normalizedStatus, // Store normalized status
            acceptUrl: message.offerDetails!.acceptUrl,
            rejectUrl: message.offerDetails!.rejectUrl,
            paymentLink: message.offerDetails!.paymentLink,
            termsConditions: message.offerDetails!.termsConditions,
          );

          currentChatMessages[messageIndex] = ChatMessage(
            id: message.id,
            senderId: message.senderId,
            senderName: message.senderName,
            message: message.message,
            time: message.time,
            isMe: message.isMe,
            isRead: message.isRead,
            type: message.type,
            filePath: message.filePath,
            duration: message.duration,
            offerDetails: updatedOffer,
          );

          debugPrint('✅ Updated offer status in UI');
        }

        Get.snackbar(
          'Success',
          'Offer ${status == "accepted" ? "accepted" : "declined"} successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: .9),
          colorText: Colors.white,
        );
      } else {
        debugPrint('❌ API Error: Status ${response.statusCode}');
        String message = 'Failed to update offer status';
        try {
          final Map<String, dynamic> resp = jsonDecode(response.body);
          if (resp.containsKey('detail')) message = resp['detail'].toString();
          if (resp.containsKey('message')) message = resp['message'].toString();
          debugPrint('Error Message: $message');
        } catch (_) {}

        Get.snackbar(
          'Error',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: .9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('=================================');
      debugPrint('❌ EXCEPTION IN UPDATE OFFER STATUS');
      debugPrint('Error: $e');
      debugPrint('=================================');
      Get.snackbar(
        'Error',
        'Network error: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: .9),
        colorText: Colors.white,
      );
    }
  }

  /// Show payment link dialog
  void _showPaymentLinkDialog(String paymentLink, int quotationId) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.payment, color: Colors.green),
            SizedBox(width: 8),
            Text('Payment Required'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your offer has been accepted! Please proceed to payment.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              'Quotation ID: #$quotationId',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              debugPrint('❌ Payment cancelled by user');
            },
            child: Text('Later', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.open_in_browser, size: 18),
            label: Text('Proceed to Payment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Get.back();
              debugPrint('=================================');
              debugPrint('💳 Opening payment link: $paymentLink');
              debugPrint('=================================');

              try {
                final Uri url = Uri.parse(paymentLink);

                // First try to check if URL can be launched
                bool canLaunch = false;
                try {
                  canLaunch = await canLaunchUrl(url);
                  debugPrint('✓ Can launch URL: $canLaunch');
                } catch (e) {
                  debugPrint('⚠️ canLaunchUrl check failed: $e');
                  // Continue anyway - sometimes the check fails but launch works
                  canLaunch = true;
                }

                if (canLaunch) {
                  // Try to launch URL with external application mode
                  final launched =
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      ).timeout(
                        const Duration(seconds: 10),
                        onTimeout: () {
                          debugPrint('❌ URL launch timeout');
                          return false;
                        },
                      );

                  if (launched) {
                    EasyLoading.showSuccess('Opening payment gateway...');
                    debugPrint('✅ Payment link opened successfully');
                  } else {
                    debugPrint('❌ Failed to launch URL');
                    EasyLoading.showError('Failed to open payment link');
                  }
                } else {
                  debugPrint('❌ Cannot launch URL');
                  EasyLoading.showError('No app available to handle this link');
                }
              } catch (e) {
                debugPrint('❌ Error opening payment link: $e');
                // Show error dialog with the payment link so user can copy it
                Get.dialog(
                  AlertDialog(
                    title: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.orange),
                        SizedBox(width: 8),
                        Text('Unable to Open Link'),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Please copy this link and open it in your browser:',
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: SelectableText(
                            paymentLink,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Update Order Status (Complete/Cancel)
  Future<void> updateOrderStatus(String statusUrl, String action) async {
    try {
      EasyLoading.show(status: 'Updating order status...');

      final token = AuthService.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ Authentication token is missing');
        EasyLoading.dismiss();
        Get.snackbar(
          'Authentication Error',
          'Please login again',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: .9),
          colorText: Colors.white,
        );
        return;
      }

      debugPrint('=================================');
      debugPrint('📤 UPDATING ORDER STATUS');
      debugPrint('Action: $action');
      debugPrint('API URL: $statusUrl');
      debugPrint('=================================');

      final response = await http.patch(
        Uri.parse(statusUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'order_status': action}),
      );

      debugPrint('=================================');
      debugPrint('📥 API RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('=================================');

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Order status updated successfully');

        Get.snackbar(
          'Success',
          'Order ${action == "completed" ? "completed" : "cancelled"} successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: .9),
          colorText: Colors.white,
        );

        // Refresh messages to get updated order status
        final user = currentChatUser.value;
        if (user != null && user.conversationId != null) {
          await fetchConversationMessages(user.conversationId!);
        }
      } else {
        debugPrint('❌ API Error: Status ${response.statusCode}');
        String message = 'Failed to update order status';
        try {
          final Map<String, dynamic> resp = jsonDecode(response.body);
          if (resp.containsKey('detail')) message = resp['detail'].toString();
          if (resp.containsKey('message')) message = resp['message'].toString();
          debugPrint('Error Message: $message');
        } catch (_) {}

        Get.snackbar(
          'Error',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: .9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('=================================');
      debugPrint('❌ EXCEPTION IN UPDATE ORDER STATUS');
      debugPrint('Error: $e');
      debugPrint('=================================');
      Get.snackbar(
        'Error',
        'Network error: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: .9),
        colorText: Colors.white,
      );
    }
  }
}
