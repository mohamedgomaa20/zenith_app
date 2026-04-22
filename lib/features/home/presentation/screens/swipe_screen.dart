import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/game_bloc/game_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/movie_card.dart';
import '../widgets/votes_row.dart';
import '../widgets/swipe_header.dart';
import '../widgets/swipe_controls.dart';
import 'match_screen.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});
  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  final CardSwiperController _swiperCtrl = CardSwiperController();

  @override
  void dispose() {
    _swiperCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) {
        if (state.status == GameStatus.matched) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MatchScreen()));
        }
      },
      builder: (context, state) {
        final movies = state.movies;
        if (movies.isEmpty) {
          return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.gold)));
        }

        return Scaffold(
          body: Column(
            children: [
              SwipeHeader(roomCode: state.roomCode, currentIndex: state.currentIndex, totalMovies: movies.length),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CardSwiper(
                    key: ValueKey(state.roomCode),
                    controller: _swiperCtrl,
                    cardsCount: movies.length,
                    numberOfCardsDisplayed: 3,
                    initialIndex: state.currentIndex,
                    backCardOffset: const Offset(0, 20),
                    scale: 0.93,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    onSwipe: (prev, curr, dir) {
                      context.read<GameBloc>().add(SwipeMovie(dir == CardSwiperDirection.right));
                      return true;
                    },
                    cardBuilder: (ctx, index, hPercent, vPercent) {
                      return index < movies.length ? MovieCard(movie: movies[index]) : const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              VotesRow(
                members: state.gameRoom?.members ?? [],
                votes: state.gameRoom?.votes ?? [],
                movieId: state.currentMovie?.id ?? -1,
              ),
              SwipeControls(
                onLike: () => _swiperCtrl.swipe(CardSwiperDirection.right),
                onDislike: () => _swiperCtrl.swipe(CardSwiperDirection.left),
              ),
            ],
          ),
        );
      },
    );
  }
}
