import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SectionCard extends StatelessWidget {
  final String label;
  final Widget child;
  const SectionCard({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 2,
            color: AppColors.textDim,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 14),
        child,
      ],
    ),
  );
}
