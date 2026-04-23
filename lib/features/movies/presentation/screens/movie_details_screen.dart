import 'package:flutter/material.dart';
import '../../data/models/movie_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/tmdb_genres.dart';
import '../widgets/details/detail_back_button.dart';
import '../widgets/details/poster_hero.dart';
import '../widgets/details/meta_row.dart';
import '../widgets/details/genre_chips.dart';
import '../widgets/details/rating_bar.dart';
import '../widgets/details/expandable_overview.dart';
import '../widgets/details/info_grid.dart';
import '../widgets/details/section_label.dart';
import '../widgets/details/watch_button.dart';
import '../widgets/details/favorite_button.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final year = movie.releaseDate.isNotEmpty
        ? movie.releaseDate.split('-')[0]
        : 'N/A';
    final genres = TmdbGenres.getNames(movie.genreIds);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 500,
            pinned: true,
            leading: const DetailBackButton(),
            actions: [FavoriteButton(movie: movie)],
            flexibleSpace: FlexibleSpaceBar(
              background: PosterHero(movie: movie, isDark: isDark),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: 48,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 14),
                  MetaRow(
                    year: year,
                    rating: movie.voteAverage.toStringAsFixed(1),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  if (genres.isNotEmpty) ...[
                    GenreChips(genres: genres, isDark: isDark),
                    const SizedBox(height: 24),
                  ],
                  RatingBar(rating: movie.voteAverage, isDark: isDark),
                  _Divider(isDark: isDark),
                  const SectionLabel(label: 'Story line'),
                  const SizedBox(height: 12),
                  ExpandableOverview(
                    overview: movie.overview.isNotEmpty
                        ? movie.overview
                        : 'No overview available.',
                    isDark: isDark,
                  ),
                  _Divider(isDark: isDark),
                  const SectionLabel(label: 'Movie info'),
                  const SizedBox(height: 16),
                  InfoGrid(movie: movie, year: year, isDark: isDark),
                  const SizedBox(height: 40),
                  const WatchButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;

  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Divider(thickness: 1, height: 50);
  }
}
