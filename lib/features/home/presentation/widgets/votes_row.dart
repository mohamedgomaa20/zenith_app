import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/room.dart';

class VotesRow extends StatelessWidget {
  final List<RoomMember> members;
  final List<RoomVote> votes;
  final int movieId;
  const VotesRow({
    super.key,
    required this.members,
    required this.votes,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ردود الصحاب:',
            style: TextStyle(fontSize: 12, color: AppColors.textDim),
          ),
          const SizedBox(height: 8),
          Row(
            children: members.map((m) {
              final vote = votes
                  .where((v) => v.memberId == m.id && v.movieId == movieId)
                  .firstOrNull;
              return Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: vote == null
                      ? AppColors.surface2
                      : vote.liked
                      ? AppColors.green.withValues(alpha: 0.15)
                      : AppColors.red.withValues(alpha: 0.1),
                  border: Border.all(
                    color: vote == null
                        ? AppColors.surface3
                        : vote.liked
                        ? AppColors.green
                        : AppColors.red,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(m.emoji, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
