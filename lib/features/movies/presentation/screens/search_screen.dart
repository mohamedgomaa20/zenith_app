import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/tmdb_api_client.dart';
import '../../data/repos/movie_repository.dart';
import '../../services/movie_services.dart';
import '../search_cubit.dart';
import '../widgets/movies_body.dart';
import '../widgets/search_text_field.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => SearchCubit(MovieRepository(MovieService(TmdbApiClient().dio))),
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
                      if (query.trim().isEmpty) {
                        context.read<SearchCubit>().clearSearch();
                      } else {
                        context.read<SearchCubit>().searchMovies(query);
                      }
                    },
                    onClear: () => context.read<SearchCubit>().clearSearch(),
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
