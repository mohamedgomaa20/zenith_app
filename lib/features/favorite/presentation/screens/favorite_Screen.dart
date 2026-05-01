import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenith_app/features/movies/presentation/widgets/movies_grid.dart';
import 'package:zenith_app/features/movies/presentation/widgets/movies_skeleton_grid.dart';
import '../../../../core/common_widgets/empty_state_widget.dart';
import '../../../../core/common_widgets/error_state_widget.dart';
import '../favorites_bloc/favorites_bloc.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Favorites",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state.status == FavoritesStatus.loading) {
            return MoviesSkeletonGrid();
          }
          if (state.status == FavoritesStatus.loaded) {
            if (state.favorites.isEmpty) {
              return const EmptyStateWidget(
                icon: Icons.favorite_border_rounded,
                label: "Your list is empty",
                subLabel:
                    "Start adding your favorite movies to see them here at any time!",
              );
            }
            return MoviesGrid(movies: state.favorites);
          }
          if (state.status == FavoritesStatus.error) {
            return ErrorStateWidget(
              message: state.errorMessage ?? "Failed to load favorites",
              onRetry: () =>
                  context.read<FavoritesBloc>().add(WatchFavoritesEvent()),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
