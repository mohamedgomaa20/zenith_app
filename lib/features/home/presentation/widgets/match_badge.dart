import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class MatchBadge extends StatelessWidget {
  const MatchBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: AppColors.goldDim.withValues(alpha: 0.5)),
          ),
          child: Text(
            '✦  IT\'S A MATCH  ✦',
            style: GoogleFonts.bebasNeue(
              fontSize: 14,
              letterSpacing: 4,
              color: AppColors.gold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'It\'s a Match!',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 4),
        const Text(
          'Everyone liked this movie',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
