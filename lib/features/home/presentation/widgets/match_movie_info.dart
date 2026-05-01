import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/data/models/movie.dart';

class MatchMovieInfo extends StatelessWidget {
  final Movie movie;

  const MatchMovieInfo({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          movie.title,
          style: Theme.of(context).textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              movie.year,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const Text('  •  ', style: TextStyle(color: AppColors.textDim)),
            const Text('⭐', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              movie.ratingFormatted,
              style: const TextStyle(
                color: AppColors.gold,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            if (movie.genres.isNotEmpty) ...[
              const Text('  •  ', style: TextStyle(color: AppColors.textDim)),
              Text(
                movie.genres.first,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
