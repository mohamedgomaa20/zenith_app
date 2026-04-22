import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProgressDots extends StatelessWidget {
  final int current;
  final int total;
  const ProgressDots({super.key, required this.current, required this.total});

  @override
  Widget build(BuildContext context) => Row(
    children: List.generate(
      total.clamp(0, 12),
      (i) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 20,
        height: 3,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: i < current ? AppColors.gold : AppColors.surface3,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    ),
  );
}
