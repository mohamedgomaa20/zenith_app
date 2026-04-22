import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../blocs/game_bloc/game_bloc.dart';
import '../widgets/match_screen_body.dart';
import 'lobby_screen.dart';
import 'swipe_screen.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  Future<void> _searchMovie(String title) async {
    final query = Uri.encodeComponent('$title watch');
    final url = Uri.parse('https://www.google.com/search?q=$query');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) {
        if (state.status == GameStatus.swiping) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SwipeScreen()));
        }
      },
      builder: (context, state) {
        final movie = state.matchedMovie;
        return Scaffold(
          body: MatchScreenBody(
            movie: movie,
            members: state.gameRoom?.members ?? [],
            onSearch: movie != null ? () => _searchMovie(movie.title) : () {},
            onPlayAgain: () => context.read<GameBloc>().add(PlayAgain()),
            onExit: () {
              context.read<GameBloc>().add(LeaveRoom());
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LobbyScreen()), (route) => false);
            },
          ),
        );
      },
    );
  }
}
