class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final String time;
  final bool isMe;
  final bool isRead;
  final MessageType type;
  final String? filePath; // For voice or image files
  final int? duration; // For voice messages in seconds
  final OfferDetails? offerDetails;
  final OrderDetails? orderDetails;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.time,
    required this.isMe,
    this.isRead = false,
    this.type = MessageType.text,
    this.filePath,
    this.duration,
    this.offerDetails,
    this.orderDetails,
  });
}

enum MessageType {
  text,
  voice,
  image,
  file,
  offer,
  order,
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
  final int? conversationId;
  final String? conversationStatus;
  final String? lastMessageType;
  final String? lastMessageFilePath;
  final String? serviceTitle;

  ChatUser({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isVerified = false,
    this.conversationId,
    this.conversationStatus,
    this.lastMessageType,
    this.lastMessageFilePath,
    this.serviceTitle,
  });
}

class OfferDetails {
  final String title;
  final String workDetails;
  final List<OfferSlot> slots;
  final String primaryCtaText;
  final String secondaryCtaText;
  final int? quotationId;
  final String? quotationStatus;
  final String? acceptUrl;
  final String? rejectUrl;
  final String? paymentLink;
  final String? termsConditions;

  OfferDetails({
    required this.title,
    required this.workDetails,
    required this.slots,
    this.primaryCtaText = 'Accept Offer',
    this.secondaryCtaText = 'Cancel Offer',
    this.quotationId,
    this.quotationStatus,
    this.acceptUrl,
    this.rejectUrl,
    this.paymentLink, 
    this.termsConditions,
  });
}

class OfferSlot {
  final String dayLabel;
  final String timeLabel;
  final bool isSelected;

  OfferSlot({
    required this.dayLabel,
    required this.timeLabel,
    this.isSelected = false,
  });
}

class OrderDetails {
  final int orderId;
  final int quotationId;
  final String orderStatus;
  final String serviceTimeTaken;
  final String serviceCost;
  final String serviceTimeline;
  final String? serviceDescription;
  final String? completeUrl;
  final String? cancelUrl;

  OrderDetails({
    required this.orderId,
    required this.quotationId,
    required this.orderStatus,
    required this.serviceTimeTaken,
    required this.serviceCost,
    required this.serviceTimeline,
    this.serviceDescription,
    this.completeUrl,
    this.cancelUrl,
  });
}
