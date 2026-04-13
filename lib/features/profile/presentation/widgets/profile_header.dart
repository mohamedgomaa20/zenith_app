import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(height: 20),
        CircleAvatar(
          radius: 65,
          backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
          backgroundImage: AssetImage("assets/images/avatar.png"),
          // child: Icon(Icons.person, size: 60, color: theme.primaryColor),
        ),

        SizedBox(height: 16),
        Text(
          "Mohamed Gomaa",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "MohamedGomaa@gmail.com",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}
