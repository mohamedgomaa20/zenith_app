import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import 'film_strip.dart';

class LobbyHeader extends StatelessWidget {
  const LobbyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'ROULETTE',
          style: GoogleFonts.bebasNeue(
            fontSize: 64,
            letterSpacing: 8,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '🎬 Choose together — no more fighting',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textDim,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
        ),
        const SizedBox(height: 32),
        const FilmStrip(),
      ],
    );
  }
}
