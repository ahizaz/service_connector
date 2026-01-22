import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderInRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const OrderInRow({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
           Icon(icon, size: 16.sp, color: Color(0xFF757575)),
           SizedBox(width: 8.w),
             Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13.sp,
            color: Color(0xFF757575),
          ),
        ),
           Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              color: Color(0xFF212121),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
class DateFormatter {
  static String formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}