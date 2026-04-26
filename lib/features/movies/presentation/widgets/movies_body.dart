import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common_widgets/empty_state_widget.dart';
import '../../../../core/common_widgets/error_state_widget.dart';
import '../search_cubit.dart';
import '../search_state.dart';
import 'movies_grid.dart';
import 'movies_skeleton_grid.dart';

class MoviesBody extends StatelessWidget {
  const MoviesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final cubit = context.read<SearchCubit>();
        return state.when(
          initial: () => const EmptyStateWidget(
            icon: Icons.movie_filter_outlined,
            label: 'Explore ReelMatch Cinema!',
            subLabel: 'Start typing to find your next favorite movie.',
          ),
          loading: () => const MoviesSkeletonGrid(),
          error: (message) => ErrorStateWidget(
            message: message,
            onRetry: () => cubit.searchMovies(cubit.lastQuery),
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
