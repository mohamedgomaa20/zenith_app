import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'action_button.dart';

class SwipeControls extends StatelessWidget {
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const SwipeControls({
    super.key,
    required this.onLike,
    required this.onDislike,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ActionButton(
                onTap: onDislike,
                icon: Icons.close_rounded,
                color: AppColors.red,
                size: 64,
              ),
              ActionButton(
                onTap: onLike,
                icon: Icons.favorite_rounded,
                color: AppColors.green,
                size: 64,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'Swipe right = LIKE   |   Swipe left = NOPE',
            style: TextStyle(fontSize: 11, color: AppColors.textDim),
          ),
        ),
      ],
    );
  }
}
