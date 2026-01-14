class MessageResponse {
  final int count;
  final int conversation;
  final OtherPerson otherPerson;
  final String conversationStatus;
  final List<Message> results;

  MessageResponse({
    required this.count,
    required this.conversation,
    required this.otherPerson,
    required this.conversationStatus,
    required this.results,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      count: json['count'] ?? 0,
      conversation: json['conversation'] ?? 0,
      otherPerson: OtherPerson.fromJson(json['other_person'] ?? {}),
      conversationStatus: json['conversation_status'] ?? '',
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'conversation': conversation,
      'other_person': otherPerson.toJson(),
      'conversation_status': conversationStatus,
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}

class OtherPerson {
  final String id;
  final String name;
  final String email;
  final String? image;

  OtherPerson({
    required this.id,
    required this.name,
    required this.email,
    this.image,
  });

  factory OtherPerson.fromJson(Map<String, dynamic> json) {
    return OtherPerson(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
    };
  }
}

class Message {
  final int messageId;
  final int conversation;
  final String sender;
  final String receiverId;
  final String senderName;
  final String? messageText;
  final String? messageImage;
  final String senderId;
  final String receiverName;
  final String? messageFile;
  final String? messageVoice;
  final String createdAt;
  final int? quotationId;
  final String? quotationStatus;
  final String? acceptUrl;
  final String? rejectUrl;
  final String? termsConditions;

  Message({
    required this.messageId,
    required this.conversation,
    required this.sender,
    required this.receiverId,
    required this.senderName,
    this.messageText,
    this.messageImage,
    required this.senderId,
    required this.receiverName,
    this.messageFile,
    this.messageVoice,
    required this.createdAt,
    this.quotationId,
    this.quotationStatus,
    this.acceptUrl,
    this.rejectUrl,
    this.termsConditions,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['message_id'] ?? 0,
      conversation: json['conversation'] ?? 0,
      sender: json['sender'] ?? '',
      receiverId: json['receiver_id'] ?? '',
      senderName: json['sender_name'] ?? '',
      messageText: json['message_text'],
      messageImage: json['message_image'],
      senderId: json['sender_id'] ?? '',
      receiverName: json['receiver_name'] ?? '',
      messageFile: json['message_file'],
      messageVoice: json['message_voice'],
      createdAt: json['created_at'] ?? '',
      quotationId: json['quotation_id'] as int?,
      quotationStatus: json['quotation_status'] as String?,
      acceptUrl: json['accept_url'] as String?,
      rejectUrl: json['reject_url'] as String?,
      termsConditions: json['terms_conditions'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'conversation': conversation,
      'sender': sender,
      'receiver_id': receiverId,
      'sender_name': senderName,
      'message_text': messageText,
      'message_image': messageImage,
      'sender_id': senderId,
      'receiver_name': receiverName,
      'message_file': messageFile,
      'message_voice': messageVoice,
      'created_at': createdAt,
      'quotation_id': quotationId,
      'quotation_status': quotationStatus,
      'accept_url': acceptUrl,
      'reject_url': rejectUrl,
      'terms_conditions': termsConditions,
    };
  }
}
