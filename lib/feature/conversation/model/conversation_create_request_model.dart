class ConversationCreateRequest {
  final String providerId;

  ConversationCreateRequest({
    required this.providerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider_id': providerId,
    };
  }
}
