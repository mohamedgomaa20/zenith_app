import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/room.dart';

class MemberSlot extends StatelessWidget {
  final RoomMember? member;
  final bool isMe;
  const MemberSlot({super.key, this.member, this.isMe = false});

  @override
  Widget build(BuildContext context) {
    final joined = member != null;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: joined
            ? AppColors.green.withValues(alpha: 0.08)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: joined
              ? AppColors.green.withValues(alpha: 0.5)
              : AppColors.surface3,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: joined
                  ? AppColors.green.withValues(alpha: 0.2)
                  : AppColors.surface3,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              joined ? member!.emoji : '⏳',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  joined ? member!.name : 'Waiting...',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: joined ? FontWeight.w600 : FontWeight.w400,
                    color: joined ? AppColors.textPrimary : AppColors.textDim,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (isMe)
                  const Text(
                    'You',
                    style: TextStyle(fontSize: 10, color: AppColors.gold),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
