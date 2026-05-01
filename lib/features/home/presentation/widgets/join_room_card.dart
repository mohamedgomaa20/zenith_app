import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import 'section_card.dart';

class JoinRoomCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController codeController;
  final bool loading;
  final VoidCallback onJoin;

  const JoinRoomCard({
    super.key,
    required this.nameController,
    required this.codeController,
    required this.loading,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      label: 'Join existing room',
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Your name',
            ),
            textAlign: TextAlign.right,
            maxLength: 20,
            style: const TextStyle(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: codeController,
                  decoration: const InputDecoration(
                    hintText: 'Room code',
                  ),
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 6,
                  style: GoogleFonts.bebasNeue(
                    fontSize: 22,
                    letterSpacing: 6,
                    color: AppColors.gold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: loading ? null : onJoin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
                child: const Text('Join'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
