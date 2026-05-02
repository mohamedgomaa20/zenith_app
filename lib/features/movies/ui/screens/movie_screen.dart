import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenith_app/core/di/injection_container.dart'; //
import '../../presentation/screens/search_screen.dart';
import '../movie_category_cubit.dart';
import '../movie_state.dart';
import '../widgets/movie_card.dart';
import '../widgets/shimmer_movie_card.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  // Separate controllers to maintain scroll position for each tab
  final ScrollController _popularController = ScrollController();
  final ScrollController _topRatedController = ScrollController();
  final ScrollController _nowPlayingController = ScrollController();

  @override
  void dispose() {
    _popularController.dispose();
    _topRatedController.dispose();
    _nowPlayingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movies'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.red,
            tabs: [
              Tab(text: 'Popular'),
              Tab(text: 'Top Rated'),
              Tab(text: 'Now Playing'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCategoryGrid(
              instanceName: 'popular',
              controller: _popularController,
            ),
            _buildCategoryGrid(
              instanceName: 'topRated',
              controller: _topRatedController,
            ),
            _buildCategoryGrid(
              instanceName: 'nowPlaying',
              controller: _nowPlayingController,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _scrollToTop(DefaultTabController.of(context).index),
          child: const Icon(Icons.arrow_upward),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid({
    required String instanceName,
    required ScrollController controller,
  }) {
    // Access the specific named instance from GetIt
    final cubit = getIt<MovieCategoryCubit>(instanceName: instanceName);

    return BlocBuilder<MovieCategoryCubit, MovieState>(
      bloc: cubit,
      builder: (context, state) {
        return state.when(
          initial: () {
            cubit.loadMovies(); // Trigger initial load
            return const Center(child: CircularProgressIndicator());
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => _buildErrorWidget(message, cubit),
          success: (movies, hasReachedMax) {
            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification &&
                    notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 200) {
                  if (!hasReachedMax) cubit.loadMovies(); // Pagination logic
                }
                return false;
              },
              child: GridView.builder(
                controller: controller, // Linked to avoid AssertionError
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: hasReachedMax ? movies.length : movies.length + 2,
                itemBuilder: (context, index) {
                  if (index < movies.length) {
                    return MovieCard(movie: movies[index]);
                  }
                  return const ShimmerMovieCard();
                },
              ),
            );
          },
        );
      },
    );
  }

  void _scrollToTop(int tabIndex) {
    final controllers = [
      _popularController,
      _topRatedController,
      _nowPlayingController,
    ];
    final activeController = controllers[tabIndex];

    if (activeController.hasClients) {
      // Safety check
      activeController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildErrorWidget(String message, MovieCategoryCubit cubit) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          Text(message, textAlign: TextAlign.center),
          ElevatedButton(
            onPressed: () => cubit.loadMovies(isRefresh: true),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
