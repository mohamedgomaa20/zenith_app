import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class SectionLabel extends StatelessWidget {
  final String label;

  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 3,
        color: AppColors.primary,
      ),
    );
  }
}
