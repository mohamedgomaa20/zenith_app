import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../movie_category_cubit.dart';
import '../movie_state.dart';
import 'movie_card_small.dart';
import 'shimmer_row_loader.dart';

class CategoryRow extends StatelessWidget {
  final String title;
  final MovieCategoryCubit cubit; // We'll use the specific category cubit here

  const CategoryRow({super.key, required this.title, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ),
        SizedBox(
          height: 200,
          child: BlocBuilder<MovieCategoryCubit, MovieState>(
            bloc: cubit,
            builder: (context, state) {
              return state.maybeWhen(
                success: (movies, hasReachedMax) => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: hasReachedMax ? movies.length : movies.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= movies.length) {
                      cubit.loadMovies();
                      return const Center(child: CircularProgressIndicator());
                    }
                    return MovieCardSmall(movie: movies[index]);
                  },
                ),
                loading: () => const ShimmerRowLoader(),
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
        ),
      ],
    );
  }
}
