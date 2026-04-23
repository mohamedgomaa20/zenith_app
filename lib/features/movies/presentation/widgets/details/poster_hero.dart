import 'package:flutter/material.dart';
import '../../../data/models/movie_model.dart';
import '../../../../../core/theme/app_colors.dart';
import 'rating_badge.dart';

class PosterHero extends StatelessWidget {
  final Movie movie;
  final bool isDark;

  const PosterHero({super.key, required this.movie, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: 'movie_poster_${movie.id}',
          child: Image.network(
            movie.fullPosterPath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: isDark ? AppColors.surface2 : AppColors.grey,
              child: const Icon(Icons.broken_image, size: 60, color: Colors.white38),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: const Alignment(0, -0.3),
                colors: [Colors.black.withOpacity(0.55), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: const Alignment(0, 0.2),
                colors: [
                  isDark ? AppColors.darkBackground : AppColors.lightBackground,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          right: 60,
          child: RatingBadge(rating: movie.voteAverage),
        ),
      ],
    );
  }
}