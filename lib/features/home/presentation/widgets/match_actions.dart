import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MatchActions extends StatelessWidget {
  final VoidCallback onSearch;
  final VoidCallback onPlayAgain;
  final VoidCallback onExit;

  const MatchActions({
    super.key,
    required this.onSearch,
    required this.onPlayAgain,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onSearch,
            icon: const Icon(Icons.play_arrow_rounded, size: 22),
            label: const Text('Search for movie & start'),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onPlayAgain,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.surface3),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('🔄 Search for another movie'),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: onExit,
          child: const Text(
            'Exit to main menu',
            style: TextStyle(color: AppColors.textDim),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
