import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class LobbyDivider extends StatelessWidget {
  const LobbyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.surface3),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const Expanded(
          child: Divider(color: AppColors.surface3),
        ),
      ],
    );
  }
}
