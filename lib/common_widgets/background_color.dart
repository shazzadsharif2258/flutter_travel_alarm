import 'package:assesment_flutter/constants/app_colors.dart';
import 'package:flutter/material.dart';

class BackgroundColor extends StatelessWidget {
  final Widget child;
  const BackgroundColor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gradientTop, AppColors.gradientBottom],
        ),
      ),
      child: child,
    );
  }
}
