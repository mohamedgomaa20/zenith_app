import 'package:flutter/material.dart';

import '../../data/models/movie_model.dart';
import 'movie_card_widget.dart';

class MoviesGrid extends StatelessWidget {
  final List<Movie> movies;

  const MoviesGrid({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: const PageStorageKey('movies_grid'),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) => MovieCardWidget(movie: movies[index]),
    );
  }
}
