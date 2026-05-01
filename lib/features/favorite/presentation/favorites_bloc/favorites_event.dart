part of 'favorites_bloc.dart';

@immutable
sealed class FavoritesEvent {}

class WatchFavoritesEvent extends FavoritesEvent {}

class ToggleFavoriteEvent extends FavoritesEvent {
  final Movie movie;

  ToggleFavoriteEvent(this.movie);
}
