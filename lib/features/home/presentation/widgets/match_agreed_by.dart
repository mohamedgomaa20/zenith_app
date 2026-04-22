import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/data/models/room.dart';

class MatchAgreedBy extends StatelessWidget {
  final List<RoomMember> members;

  const MatchAgreedBy({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Agreed by',
            style: TextStyle(fontSize: 12, color: AppColors.textDim),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: members
                .map((m) => Container(
                      width: 38,
                      height: 38,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.green.withValues(alpha: 0.15),
                        border: Border.all(color: AppColors.green, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(m.emoji, style: const TextStyle(fontSize: 18)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
