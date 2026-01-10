// Import ChatMessage from existing model
import 'chat_message_model.dart';

class WebSocketMessage {
  final int messageId;
  final String senderId;
  final String senderName;
  final String messageText;
  final String? messageImage;
  final String? messageFile;
  final String createdAt;

  WebSocketMessage({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    required this.messageText,
    this.messageImage,
    this.messageFile,
    required this.createdAt,
  });

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      messageId: json['message_id'] as int,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String,
      messageText: json['message_text'] as String? ?? '',
      messageImage: json['message_image'] as String?,
      messageFile: json['message_file'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'sender_id': senderId,
      'sender_name': senderName,
      'message_text': messageText,
      'message_image': messageImage,
      'message_file': messageFile,
      'created_at': createdAt,
    };
  }

  /// Convert WebSocket message to ChatMessage for UI
  ChatMessage toChatMessage(String currentUserId) {
    // Determine message type
    MessageType type = MessageType.text;
    String? filePath;

    if (messageImage != null && messageImage!.isNotEmpty) {
      type = MessageType.image;
      filePath = messageImage;
    } else if (messageFile != null && messageFile!.isNotEmpty) {
      type = MessageType.file;
      filePath = messageFile;
    }

    return ChatMessage(
      id: messageId.toString(),
      senderId: senderId,
      senderName: senderName,
      message: messageText,
      time: _formatMessageTime(createdAt),
      isMe: senderId == currentUserId,
      isRead: true,
      type: type,
      filePath: filePath,
    );
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
}
