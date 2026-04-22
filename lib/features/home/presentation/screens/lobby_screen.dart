import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/game_bloc/game_bloc.dart';
import '../../../../core/utils/app_snack_bar.dart';
import '../widgets/lobby_header.dart';
import '../widgets/create_room_card.dart';
import '../widgets/join_room_card.dart';
import '../widgets/lobby_divider.dart';
import 'waiting_screen.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});
  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> with TickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _joinNameCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _joinNameCtrl.dispose();
    super.dispose();
  }

  void _createRoom() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      AppSnackBar.error(context, 'Please enter your name');
      return;
    }
    context.read<GameBloc>().add(SetIdentity(name));
    context.read<GameBloc>().add(CreateRoom());
  }

  void _joinRoom() {
    final name = _joinNameCtrl.text.trim();
    final code = _codeCtrl.text.trim().toUpperCase();
    if (name.isEmpty || code.isEmpty) {
      AppSnackBar.error(context, 'Please enter your name');
      return;
    }
    context.read<GameBloc>().add(SetIdentity(name));
    context.read<GameBloc>().add(JoinRoom(code));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) {
        if (state.status == GameStatus.waiting) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const WaitingScreen()));
        } else if (state.status == GameStatus.error && state.error != null) {
          AppSnackBar.error(context, state.error!);
        }
      },
      builder: (context, state) {
        final loading = state.status == GameStatus.loading;
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const LobbyHeader(),
                  const SizedBox(height: 40),
                  CreateRoomCard(controller: _nameCtrl, loading: loading, onCreate: _createRoom),
                  const SizedBox(height: 16),
                  const LobbyDivider(),
                  const SizedBox(height: 16),
                  JoinRoomCard(nameController: _joinNameCtrl, codeController: _codeCtrl, loading: loading, onJoin: _joinRoom),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
