import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/game_bloc/game_bloc.dart';
import '../widgets/room_code_card.dart';
import '../widgets/members_grid.dart';
import '../widgets/waiting_actions.dart';
import 'swipe_screen.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) {
        if (state.status == GameStatus.swiping) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SwipeScreen()));
        }
      },
      builder: (context, state) {
        final members = state.gameRoom?.members ?? [];
        final isHost = state.gameRoom?.hostId == state.myId;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - 48,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Waiting...', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 24),
                        RoomCodeCard(roomCode: state.roomCode),
                        const SizedBox(height: 24),
                        MembersGrid(members: members, myId: state.myId),
                      ],
                    ),
                    WaitingActions(
                      isHost: isHost,
                      canStart: state.gameRoom?.canStart == true,
                      onStart: () => context.read<GameBloc>().add(StartGame()),
                      onBack: () {
                        context.read<GameBloc>().add(LeaveRoom());
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
