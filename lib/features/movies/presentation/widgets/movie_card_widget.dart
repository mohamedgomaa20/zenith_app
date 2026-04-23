import 'package:flutter/material.dart';

import '../../data/models/movie_model.dart';
import '../screens/movie_details_screen.dart';

class MovieCardWidget extends StatelessWidget {
  final Movie movie;

  const MovieCardWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MovieDetailsScreen(movie: movie)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.withValues(alpha: 0.1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Hero(
                tag: 'movie_poster_${movie.id}',
                child: Image.network(
                  movie.fullPosterPath,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  errorBuilder: (_, _, _) => const Center(
                    child: Icon(Icons.movie_filter_outlined, size: 60),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          movie.releaseDate.isNotEmpty
                              ? movie.releaseDate.split('-')[0]
                              : 'N/A',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              movie.voteAverage.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // TODO: Handle favorite button press
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
