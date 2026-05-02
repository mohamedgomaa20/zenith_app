import 'package:flutter/material.dart';

import '../../data/models/movie_model.dart';

class MovieCardSmall extends StatelessWidget {
  final Movie movie;
  const MovieCardSmall({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'movie-${movie.id}', // Prep for Hero animation to detail screen
      child: Container(
        width: 130,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(movie.fullPosterPath), // Uses your extension!
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
