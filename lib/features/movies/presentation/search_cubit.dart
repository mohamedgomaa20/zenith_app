import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/movie_model.dart';
import '../data/repos/movie_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final MovieRepository _repository;
  String lastQuery = "";
  Timer? _debounceTimer;

  SearchCubit(this._repository) : super(const SearchState.initial());

  Future<void> searchMovies(String query) async {
    lastQuery = query;
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      emit(const SearchState.loading());
      try {
        final movies = await _repository.searchMovies(query: query);
        emit(SearchState.success(movies));
      } catch (e) {
        if (lastQuery.isNotEmpty) {
          emit(SearchState.error(e.toString()));
        }
      }
    });
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    lastQuery = "";
    emit(const SearchState.initial());
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
