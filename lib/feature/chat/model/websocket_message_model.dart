// Import ChatMessage from existing model
import 'chat_message_model.dart';

class WebSocketMessage {
  final int? messageId;
  final String? senderId;
  final String? senderName;
  final String messageText;
  final String? messageImage;
  final String? messageFile;
  final String? createdAt;
  final int? quotationId;
  final String? quotationStatus;
  final String? acceptUrl;
  final String? rejectUrl;
  final String? paymentLink;
  final String? termsConditions;
  final int? orderId;
  final String? orderStatus;
  final String? serviceTimeTaken;

  WebSocketMessage({
    this.messageId,
    this.senderId,
    this.senderName,
    required this.messageText,
    this.messageImage,
    this.messageFile,
    this.createdAt,
    this.quotationId,
    this.quotationStatus,
    this.acceptUrl,
    this.rejectUrl,
    this.paymentLink,
    this.termsConditions,
    this.orderId,
    this.orderStatus,
    this.serviceTimeTaken,
  });

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      messageId: json['message_id'] as int?,
      senderId: json['sender_id'] as String?,
      senderName: json['sender_name'] as String?,
      messageText: json['message_text'] as String? ?? '',
      messageImage: json['message_image'] as String?,
      messageFile: json['message_file'] as String?,
      createdAt: json['created_at'] as String?,
      quotationId: json['quotation_id'] as int?,
      quotationStatus: json['quotation_status'] as String?,
      acceptUrl: json['accept_url'] as String?,
      rejectUrl: json['reject_url'] as String?,
      paymentLink: json['payment_link'] as String?,
      termsConditions: json['terms_conditions'] as String?,
      orderId: json['order_id'] as int?,
      orderStatus: json['order_status'] as String?,
      serviceTimeTaken: json['service_time_taken'] as String?,
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
      'payment_link': paymentLink,
      'terms_conditions': termsConditions,
      'order_id': orderId,
      'order_status': orderStatus,
      'service_time_taken': serviceTimeTaken,
    };
  }

  /// Convert WebSocket message to ChatMessage for UI
  ChatMessage toChatMessage(String currentUserId) {
    // Determine message type
    MessageType type = MessageType.text;
    String? filePath;
    OfferDetails? offerDetails;
    OrderDetails? orderDetails;

    if (messageImage != null && messageImage!.isNotEmpty) {
      type = MessageType.image;
      filePath = messageImage;
    } else if (messageFile != null && messageFile!.isNotEmpty) {
      type = MessageType.file;
      filePath = messageFile;
    } else if (orderId != null) {
      // This is an order message
      type = MessageType.order;
      orderDetails = OrderDetails(
        orderId: orderId!,
        quotationId: quotationId ?? 0,
        orderStatus: orderStatus ?? 'pending',
        serviceTimeTaken: serviceTimeTaken ?? '',
        serviceCost: '', // Will be filled from quotation data
        serviceTimeline: '', // Will be filled from quotation data
        serviceDescription: messageText,
      );
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
        paymentLink: paymentLink,
        termsConditions: termsConditions,
      );
    }

    // Always include terms & conditions in the message display if present
    String displayMessage = messageText;
    if (termsConditions != null && termsConditions!.isNotEmpty) {
      displayMessage = '$messageText\n\nTerms & Conditions: $termsConditions';
    }

    return ChatMessage(
      id:
          messageId?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId ?? '',
      senderName: senderName ?? 'Unknown',
      message: displayMessage,
      time: _formatMessageTime(createdAt),
      isMe: senderId == currentUserId,
      isRead: true,
      type: type,
      filePath: filePath,
      offerDetails: offerDetails,
      orderDetails: orderDetails,
    );
  }

  /// Format message timestamp to time (9:41 AM)
  String _formatMessageTime(String? timestamp) {
    if (timestamp == null) return 'now';

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
