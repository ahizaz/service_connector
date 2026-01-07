class ConversationResponse {
  final bool success;
  final int statusCode;
  final String message;
  final ConversationData data;

  ConversationResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ConversationResponse.fromJson(Map<String, dynamic> json) {
    return ConversationResponse(
      success: json['success'] ?? true,
      statusCode: json['statusCode'] ?? 201,
      message: json['message'] ?? '',
      data: ConversationData.fromJson(json['data']),
    );
  }
}

class ConversationData {
  final int conversationId;
  final MessageReceiver messageReceiver;
  final MessageSender messageSender;
  final String conversationStatus;
  final String expiresAt;
  final List<Message> messages;
  final String createdAt;
  final String updatedAt;

  ConversationData({
    required this.conversationId,
    required this.messageReceiver,
    required this.messageSender,
    required this.conversationStatus,
    required this.expiresAt,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConversationData.fromJson(Map<String, dynamic> json) {
    return ConversationData(
      conversationId: json['conversation_id'],
      messageReceiver: MessageReceiver.fromJson(json['message_receiver']),
      messageSender: MessageSender.fromJson(json['message_sender']),
      conversationStatus: json['conversation_status'] ?? 'active',
      expiresAt: json['expires_at'] ?? '',
      messages: (json['messages'] as List?)
              ?.map((m) => Message.fromJson(m))
              .toList() ??
          [],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class MessageReceiver {
  final String id;
  final String name;
  final String email;

  MessageReceiver({
    required this.id,
    required this.name,
    required this.email,
  });

  factory MessageReceiver.fromJson(Map<String, dynamic> json) {
    return MessageReceiver(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class MessageSender {
  final User user;
  final String serviceTitle;

  MessageSender({
    required this.user,
    required this.serviceTitle,
  });

  factory MessageSender.fromJson(Map<String, dynamic> json) {
    return MessageSender(
      user: User.fromJson(json['user']),
      serviceTitle: json['service_title'] ?? '',
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class Message {
  final int messageId;
  final int conversation;
  final String sender;
  final String receiverId;
  final String senderName;
  final String messageText;
  final String? messageImage;
  final String senderId;
  final String receiverName;
  final String? messageFile;
  final String? messageVoice;
  final String createdAt;

  Message({
    required this.messageId,
    required this.conversation,
    required this.sender,
    required this.receiverId,
    required this.senderName,
    required this.messageText,
    this.messageImage,
    required this.senderId,
    required this.receiverName,
    this.messageFile,
    this.messageVoice,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['message_id'],
      conversation: json['conversation'],
      sender: json['sender'] ?? '',
      receiverId: json['receiver_id'] ?? '',
      senderName: json['sender_name'] ?? '',
      messageText: json['message_text'] ?? '',
      messageImage: json['message_image'],
      senderId: json['sender_id'] ?? '',
      receiverName: json['receiver_name'] ?? '',
      messageFile: json['message_file'],
      messageVoice: json['message_voice'],
      createdAt: json['created_at'] ?? '',
    );
  }
}
