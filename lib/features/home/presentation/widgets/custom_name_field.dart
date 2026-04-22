import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CustomNameField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const CustomNameField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      textAlign: TextAlign.right,
      maxLength: 20,
      style: const TextStyle(color: AppColors.textPrimary),
    );
  }
}
