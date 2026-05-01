import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class WaitingActions extends StatelessWidget {
  final bool isHost;
  final bool canStart;
  final VoidCallback onStart;
  final VoidCallback onBack;

  const WaitingActions({
    super.key,
    required this.isHost,
    required this.canStart,
    required this.onStart,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),
        if (isHost) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canStart ? onStart : null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: AppColors.surface3,
                disabledForegroundColor: AppColors.textDim,
              ),
              child: const Text('🎬 Start movie night!'),
            ),
          ),
          if (!canStart)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Waiting... need at least 2 members',
                style: TextStyle(fontSize: 12, color: AppColors.textDim),
                textAlign: TextAlign.center,
              ),
            ),
        ] else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.gold,
                  ),
                ),
                SizedBox(width: 12),
                Text('Waiting... host will start'),
              ],
            ),
          ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: onBack,
          child: const Text(
            '← Back',
            style: TextStyle(color: AppColors.textDim),
          ),
        ),
      ],
    );
  }
}
