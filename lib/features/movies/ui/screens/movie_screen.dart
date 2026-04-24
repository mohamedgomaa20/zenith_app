import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/movie_model.dart';
import '../movie_cubit.dart';
import '../movie_state.dart';
import '../widgets/movie_card.dart';
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
                      return MovieCard(movie: movies[index]);
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
