import 'package:flutter/material.dart';
import '../../../home/data/models/movie.dart';
import '../../../home/data/models/room.dart';
import 'match_badge.dart';
import 'match_movie_poster.dart';
import 'match_movie_info.dart';
import 'match_agreed_by.dart';
import 'match_actions.dart';

class MatchScreenBody extends StatelessWidget {
  final Movie? movie;
  final List<RoomMember> members;
  final VoidCallback onSearch;
  final VoidCallback onPlayAgain;
  final VoidCallback onExit;

  const MatchScreenBody({
    super.key,
    required this.movie,
    required this.members,
    required this.onSearch,
    required this.onPlayAgain,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const MatchBadge(),
            const SizedBox(height: 28),
            if (movie != null) MatchMoviePoster(posterUrl: movie!.posterUrl),
            if (movie != null) MatchMovieInfo(movie: movie!),
            MatchAgreedBy(members: members),
            MatchActions(
              onSearch: onSearch,
              onPlayAgain: onPlayAgain,
              onExit: onExit,
            ),
          ],
        ),
      ),
    );
  }
}
