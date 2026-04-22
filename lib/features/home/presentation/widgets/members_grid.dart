import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/data/models/room.dart';
import 'member_slot.dart';

class MembersGrid extends StatelessWidget {
  final List<RoomMember> members;
  final String myId;

  const MembersGrid({
    super.key,
    required this.members,
    required this.myId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.4,
          ),
          itemCount: 4,
          itemBuilder: (_, i) {
            final member = i < members.length ? members[i] : null;
            return MemberSlot(
              member: member,
              isMe: member?.id == myId,
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          '${members.length}/4 members in the room',
          style: const TextStyle(
            color: AppColors.textDim,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
