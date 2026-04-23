import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../movie_cubit.dart';
import '../widgets/movies_body.dart';
import '../widgets/search_text_field.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MovieCubit>().getPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
