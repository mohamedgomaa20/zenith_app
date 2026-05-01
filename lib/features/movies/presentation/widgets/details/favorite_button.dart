import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../favorite/presentation/favorites_bloc/favorites_bloc.dart';
import '../../../data/models/movie_model.dart';

class FavoriteButton extends StatelessWidget {
  final Movie movie;

  const FavoriteButton({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          final isFav = state.favorites.any((m) => m.id == movie.id);
          final isProcessing = state.processingIds.contains(movie.id);
          return Material(
            color: Colors.black.withOpacity(0.45),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: isProcessing
                  ? null
                  : () => context.read<FavoritesBloc>().add(
                      ToggleFavoriteEvent(movie),
                    ),
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.white,
                        size: 20,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
