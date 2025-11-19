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
  });
}

enum MessageType {
  text,
  voice,
  image,
  offer,
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

class OfferDetails {
  final String title;
  final String workDetails;
  final List<OfferSlot> slots;
  final String primaryCtaText;
  final String secondaryCtaText;

  OfferDetails({
    required this.title,
    required this.workDetails,
    required this.slots,
    this.primaryCtaText = 'Accept Offer',
    this.secondaryCtaText = 'Cancel Offer',
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
