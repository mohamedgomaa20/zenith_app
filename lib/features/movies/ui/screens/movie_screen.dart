import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/movie_model.dart';
import '../movie_cubit.dart';
import '../movie_state.dart';
import '../widgets/shimmer_movie_card.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  // We keep the controller only if we need to jump-to-top or manual control
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load initial movies when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieCubit>().getPopularMovies();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: BlocBuilder<MovieCubit, MovieState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: Text('Connecting to TMDB...')),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<MovieCubit>().getPopularMovies(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            success: (movies, hasReachedMax) {
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  // Trigger load when user is 200 pixels from bottom
                  if (notification is ScrollUpdateNotification) {
                    if (notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 200) {
                      if (!hasReachedMax) {
                        context.read<MovieCubit>().loadMoreMovies();
                      }
                    }
                  }
                  return false;
                },
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  // Add +1 for the loading shimmer at the bottom if not at the end
                  itemCount: hasReachedMax ? movies.length : movies.length + 2,
                  itemBuilder: (context, index) {
                    if (index < movies.length) {
                      return _MovieCard(movie: movies[index]);
                    } else {
                      // Bottom loading indicators
                      return const ShimmerMovieCard();
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;
  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    movie.fullPosterPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image, size: 40)),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
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
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
