import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  final bool isDark;

  const RatingBar({super.key, required this.rating, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final fill = rating / 10;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Audience Score'.toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
                color: AppColors.primary,
              ),
            ),
            Text(
              '${(fill * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _scoreColor(fill),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fill,
            minHeight: 6,
            backgroundColor: isDark ? AppColors.surface3 : AppColors.grey,
            color: _scoreColor(fill),
          ),
        ),
      ],
    );
  }

  Color _scoreColor(double fill) {
    if (fill >= 0.75) return AppColors.green;
    if (fill >= 0.5) return AppColors.gold;
    return AppColors.red;
  }
}
