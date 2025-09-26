import 'package:assesment_flutter/constants/app_colors.dart';
import 'package:flutter/material.dart';


class DotIndicator extends StatelessWidget {
  final int active, total;
  const DotIndicator({super.key, required this.active, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        total,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: i == active ? 18 : 8,
          decoration: BoxDecoration(
            color: i == active
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.19),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
