class ProviderReviewsResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<ReviewModel> results;

  ProviderReviewsResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ProviderReviewsResponse.fromJson(Map<String, dynamic> json) {
    return ProviderReviewsResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ReviewModel {
  final int id;
  final String providerUserId;
  final String receiverUserId;
  final int provider;
  final int receiver;
  final int order;
  final String providerName;
  final String receiverName;
  final String? receiverImage;
  final int rating;
  final String reviewText;
  final String createdAt;

  ReviewModel({
    required this.id,
    required this.providerUserId,
    required this.receiverUserId,
    required this.provider,
    required this.receiver,
    required this.order,
    required this.providerName,
    required this.receiverName,
    this.receiverImage,
    required this.rating,
    required this.reviewText,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? 0,
      providerUserId: json['provider_user_id'] ?? '',
      receiverUserId: json['receiver_user_id'] ?? '',
      provider: json['provider'] ?? 0,
      receiver: json['receiver'] ?? 0,
      order: json['order'] ?? 0,
      providerName: json['provider_name'] ?? '',
      receiverName: json['receiver_name'] ?? '',
      receiverImage: json['receiver_image'],
      rating: json['rating'] ?? 0,
      reviewText: json['review_text'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  // Helper method to get formatted time ago
  String getTimeAgo() {
    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'min' : 'mins'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }
}
