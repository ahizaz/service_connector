import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        totalSteps,
        (index) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < totalSteps - 1 ? 8.w : 0),
            height: 4.h,
            decoration: BoxDecoration(
              color: index < currentStep
                  ? const Color(0xffE63946) // Red color for completed/current steps
                  : const Color(0xffE0E0E0), // Gray for incomplete steps
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ),
      ),
    );
  }
}
