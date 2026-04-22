import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import 'progress_dots.dart';

class SwipeHeader extends StatelessWidget {
  final String roomCode;
  final int currentIndex;
  final int totalMovies;

  const SwipeHeader({
    super.key,
    required this.roomCode,
    required this.currentIndex,
    required this.totalMovies,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Room',
                    style: TextStyle(fontSize: 11, color: AppColors.textDim),
                  ),
                  Text(
                    roomCode,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 18,
                      color: AppColors.gold,
                      letterSpacing: 2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: ProgressDots(
                    current: currentIndex,
                    total: totalMovies,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${currentIndex + 1}/$totalMovies',
                style: const TextStyle(fontSize: 12, color: AppColors.textDim),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
