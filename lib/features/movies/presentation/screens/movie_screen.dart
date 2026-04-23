import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/movie_repository.dart';
import '../../services/movie_services.dart';
import '../movie_cubit.dart';
import '../widgets/movies_body.dart';
import '../widgets/search_text_field.dart';

class MoviesScreen extends StatelessWidget {
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3/',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMzk3YTQzODRhYWI1NGIyN2RkOTY5MTQ0YWNmY2JjNiIsIm5iZiI6MTc3NjIwMzQwNC41NTAwMDAyLCJzdWIiOiI2OWRlYjY4YzZiMDE3NGRiOTIxZGE5YzciLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.glUCeuC1t2tXMIaDt8kelxKLLhDbbLyzMh4aI902UPQ',
          'accept': 'application/json',
        },
      ),
    );
    return BlocProvider(
      create: (_) => MovieCubit(MovieRepository(MovieService(dio))),

      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text("Search"), centerTitle: true),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SearchTextField(
                    onChanged: (query) {
                      if (query.isEmpty) {
                        context.read<MovieCubit>().clearSearch();
                      } else {
                        context.read<MovieCubit>().searchMovies(query);
                      }
                    },
                    onClear: () => context.read<MovieCubit>().clearSearch(),
                  ),
                ),

                Expanded(child: MoviesBody()),
              ],
            ),
          );
        },
      ),
    );
  }
}
