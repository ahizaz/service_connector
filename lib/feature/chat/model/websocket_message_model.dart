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
  final int? quotationId;
  final String? quotationStatus;
  final String? acceptUrl;
  final String? rejectUrl;
  final String? termsConditions;

  WebSocketMessage({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    required this.messageText,
    this.messageImage,
    this.messageFile,
    required this.createdAt,
    this.quotationId,
    this.quotationStatus,
    this.acceptUrl,
    this.rejectUrl,
    this.termsConditions,
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
      'sender_id': senderId,
      'sender_name': senderName,
      'message_text': messageText,
      'message_image': messageImage,
      'message_file': messageFile,
      'created_at': createdAt,
      'quotation_id': quotationId,
      'quotation_status': quotationStatus,
      'accept_url': acceptUrl,
      'reject_url': rejectUrl,
      'terms_conditions': termsConditions,
    };
  }

  /// Convert WebSocket message to ChatMessage for UI
  ChatMessage toChatMessage(String currentUserId) {
    // Determine message type
    MessageType type = MessageType.text;
    String? filePath;
    OfferDetails? offerDetails;

    if (messageImage != null && messageImage!.isNotEmpty) {
      type = MessageType.image;
      filePath = messageImage;
    } else if (messageFile != null && messageFile!.isNotEmpty) {
      type = MessageType.file;
      filePath = messageFile;
    } else if (quotationId != null) {
      // This is an offer message
      type = MessageType.offer;
      offerDetails = OfferDetails(
        title: 'New Offer',
        workDetails: messageText,
        slots: [],
        quotationId: quotationId,
        quotationStatus: quotationStatus,
        acceptUrl: acceptUrl,
        rejectUrl: rejectUrl,
        termsConditions: termsConditions,
      );
    }

    // Always include terms & conditions in the message display if present
    String displayMessage = messageText;
    if (termsConditions != null && termsConditions!.isNotEmpty) {
      displayMessage = '$messageText\n\nTerms & Conditions: $termsConditions';
    }

    return ChatMessage(
      id: messageId.toString(),
      senderId: senderId,
      senderName: senderName,
      message: displayMessage,
      time: _formatMessageTime(createdAt),
      isMe: senderId == currentUserId,
      isRead: true,
      type: type,
      filePath: filePath,
      offerDetails: offerDetails,
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

      return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return 'now';
    }
  }
}
