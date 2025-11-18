class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final String time;
  final bool isMe;
  final bool isRead;
  final MessageType type;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.time,
    required this.isMe,
    this.isRead = false,
    this.type = MessageType.text,
  });
}

enum MessageType {
  text,
  voice,
  image,
}

class ChatUser {
  final String id;
  final String name;
  final String profileImage;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final bool isVerified;

  ChatUser({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isVerified = false,
  });
}
