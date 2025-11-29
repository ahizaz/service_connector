import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String imageUrl;
  final String badgeText;
  final String title;
  final String provider;
  final double rating;
  final String price; // e.g. "\$23/hour"
  final VoidCallback? onBook;

  const ServiceCard({
    Key? key,
    required this.imageUrl,
    this.badgeText = '',
    required this.title,
    required this.provider,
    this.rating = 0.0,
    required this.price,
    this.onBook,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 96,
                    height: 96,
                    color: Colors.grey[200],
                    child: Icon(Icons.image, color: Colors.grey[400]),
                  ),
                ),
              ),

              if (badgeText.isNotEmpty)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: title and Book Now button at the right
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 34,
                      child: ElevatedButton(
                        onPressed: onBook ?? () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDE2B2B),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          elevation: 0,
                        ),
                        child: const Text('Book Now', style: TextStyle(fontSize: 13, color: Colors.white)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Provider and rating inline
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        provider,
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber[700], size: 12),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(rating % 1 == 0 ? 0 : 1),
                          style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Price only on a separate line
                Builder(builder: (context) {
                  final parts = price.split('/');
                  final amount = parts.isNotEmpty ? parts[0] : price;
                  final suffix = parts.length > 1 ? '/${parts.sublist(1).join('/')}' : '';
                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: amount,
                          style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: suffix,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
