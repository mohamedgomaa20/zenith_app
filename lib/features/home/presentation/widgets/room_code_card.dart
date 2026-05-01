import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenith_app/core/theme/app_colors.dart';
import 'package:zenith_app/core/utils/app_snack_bar.dart';

class RoomCodeCard extends StatelessWidget {
  final String roomCode;

  const RoomCodeCard({super.key, required this.roomCode});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: roomCode));
        if (context.mounted) {
          AppSnackBar.success(context, 'Code copied ✓');
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.goldDim.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            const Text(
              'Room code',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 2,
                color: AppColors.textDim,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              roomCode,
              style: GoogleFonts.bebasNeue(
                fontSize: 52,
                letterSpacing: 10,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap to copy',
              style: TextStyle(fontSize: 12, color: AppColors.textDim),
            ),
          ],
        ),
      ),
    );
  }
}
