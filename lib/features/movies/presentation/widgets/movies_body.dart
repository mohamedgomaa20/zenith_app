import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common_widgets/empty_state_widget.dart';
import '../../../../core/common_widgets/error_state_widget.dart';
import '../movie_cubit.dart';
import '../movie_state.dart';
import 'movies_grid.dart';
import 'movies_skeleton_grid.dart';

class MoviesBody extends StatelessWidget {
  const MoviesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieCubit, MovieState>(
      builder: (context, state) {
        return state.when(
          initial: () => const EmptyStateWidget(
            icon: Icons.movie_filter_outlined,
            label: 'Explore ReelMatch Cinema!',
            subLabel: 'Start typing to find your next favorite movie.',
          ),
          loading: () => const MoviesSkeletonGrid(),
          error: (message) => ErrorStateWidget(
            message: message,
            onRetry: () => context.read<MovieCubit>().getPopularMovies(),
          ),
          success: (movies) => movies.isEmpty
              ? const EmptyStateWidget(
                  icon: Icons.search_off_rounded,
                  label: 'No Results Found',
                  subLabel: "We couldn't find any movies matching your search.",
                )
              : MoviesGrid(movies: movies),
        );
      },
    );
  }
}
