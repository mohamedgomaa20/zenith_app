import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/models/movie_model.dart';

part 'search_state.freezed.dart';

@freezed
class SearchState with _$MovieState {
  const factory SearchState.initial() = _Initial;
  const factory SearchState.loading() = _Loading;
  const factory SearchState.success(List<Movie> movies) = _Success;
  const factory SearchState.error(String message) = _Error;
}
