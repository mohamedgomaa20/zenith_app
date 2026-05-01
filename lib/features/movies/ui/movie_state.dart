import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/models/movie_model.dart';

part 'movie_state.freezed.dart';

@freezed
class MovieState with _$MovieState {
  const factory MovieState.initial() = _Initial;
  const factory MovieState.loading() = _Loading;
  const factory MovieState.success(List<Movie> movies, bool hasReachedMax) =
      _Success;
  const factory MovieState.error(String message) = _Error;
}
