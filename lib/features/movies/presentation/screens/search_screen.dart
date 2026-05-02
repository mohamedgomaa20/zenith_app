import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../search_cubit.dart';
import '../search_state.dart';
import '../widgets/movies_body.dart';
import '../widgets/search_text_field.dart';
import 'package:zenith_app/core/di/injection_container.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Search"), centerTitle: true),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  return SearchTextField(
                    onChanged: (query) {
                      if (query.trim().isEmpty) {
                        context.read<SearchCubit>().clearSearch();
                      } else {
                        context.read<SearchCubit>().searchMovies(query);
                      }
                    },
                    onClear: () => context.read<SearchCubit>().clearSearch(),
                  );
                },
              ),
            ),
            const Expanded(child: MoviesBody()),
          ],
        ),
      ),
    );
  }
}
