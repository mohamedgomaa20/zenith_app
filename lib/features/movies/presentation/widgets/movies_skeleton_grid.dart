import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/movie_model.dart';
import 'movie_card_widget.dart';

class MoviesSkeletonGrid extends StatelessWidget {
  const MoviesSkeletonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fakeMovie = Movie(
      id: 0,
      title: 'Loading...',
      overview: 'Loading overview text...',
      posterPath: '/fake.jpg',
      voteAverage: 0.0,
      releaseDate: '2024-01-01',
    );

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: 6,
      itemBuilder: (_, _) => Skeletonizer(
        enabled: true,
        effect: ShimmerEffect(
          baseColor: isDark ? AppColors.surface2 : AppColors.grey,
          highlightColor: isDark ? AppColors.surface3 : Colors.white,
        ),
        child: MovieCardWidget(movie: fakeMovie),
      ),
    );
  }
}
