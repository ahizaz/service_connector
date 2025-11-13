import 'package:flutter/material.dart';
import 'package:service_connect/core/utils/constants/image_path.dart';

class LastOnboardingScreen extends StatelessWidget {
  const LastOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: [
            SizedBox.expand(
              child: Image.asset(
                ImagePath.lastOnboarding,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),

    );
  }
}