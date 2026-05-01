part of 'favorites_bloc.dart';

enum FavoritesStatus { initial, loading, loaded, error }

@immutable
class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final List<Movie> favorites;
  final Set<int> processingIds;
  final String? errorMessage;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favorites = const [],
    this.processingIds = const {},
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    status,
    favorites,
    processingIds,
    errorMessage,
  ];

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<Movie>? favorites,
    Set<int>? processingIds,
    int? addProcessingId,
    int? removeProcessingId,
    String? errorMessage,
  }) {
    final updatedProcessingIds = Set<int>.from(this.processingIds);

    if (addProcessingId != null) {
      updatedProcessingIds.add(addProcessingId);
    }

    if (removeProcessingId != null) {
      updatedProcessingIds.remove(removeProcessingId);
    }

    return FavoritesState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      processingIds: processingIds ?? updatedProcessingIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }}
