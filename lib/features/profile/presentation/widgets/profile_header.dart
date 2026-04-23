import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../profile_bloc/profile_bloc.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.status == ProfileStatus.loading) {
          return Center(child: const CircularProgressIndicator());
        }
        final user = state.user;
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
              user?.name ?? "User",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              user?.email ?? "",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        );
      },
    );
  }
}
