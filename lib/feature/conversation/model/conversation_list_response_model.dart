class ConversationListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<ConversationItem> results;

  ConversationListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ConversationListResponse.fromJson(Map<String, dynamic> json) {
    return ConversationListResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List?)
              ?.map((item) => ConversationItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class ConversationItem {
  final int conversationId;
  final OtherPerson otherPerson;
  final String conversationStatus;
  final String expiresAt;
  final LastMessage? lastMessage;
  final String createdAt;
  final String updatedAt;

  ConversationItem({
    required this.conversationId,
    required this.otherPerson,
    required this.conversationStatus,
    required this.expiresAt,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConversationItem.fromJson(Map<String, dynamic> json) {
    return ConversationItem(
      conversationId: json['conversation_id'],
      otherPerson: OtherPerson.fromJson(json['other_person']),
      conversationStatus: json['conversation_status'] ?? 'active',
      expiresAt: json['expires_at'] ?? '',
      lastMessage: json['last_message'] != null
          ? LastMessage.fromJson(json['last_message'])
          : null,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class OtherPerson {
  final String id;
  final String name;
  final String email;
  final String? image;
  final String? serviceTitle;

  OtherPerson({
    required this.id,
    required this.name,
    required this.email,
    this.image,
    this.serviceTitle,
  });

  factory OtherPerson.fromJson(Map<String, dynamic> json) {
    return OtherPerson(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
      serviceTitle: json['service_title'],
    );
  }
}

class LastMessage {
  final int messageId;
  final String senderId;
  final String messageText;
  final String createdAt;
  final String? messageType;
  final String? filePath;

  LastMessage({
    required this.messageId,
    required this.senderId,
    required this.messageText,
    required this.createdAt,
    this.messageType,
    this.filePath,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      messageId: json['message_id'],
      senderId: json['sender_id'] ?? '',
      messageText: json['message_text'] ?? '',
      createdAt: json['created_at'] ?? '',
      messageType: json['message_type'],
      filePath: json['file_path'],
    );
  }
}
