import 'package:flutter/material.dart';

class EditProfileImage extends StatelessWidget {
  const EditProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 65,
            backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
            backgroundImage: AssetImage("assets/images/avatar.png"),
            // child: Icon(Icons.person, size: 60, color: theme.primaryColor),
          ),

          Positioned(
            bottom: 0,
            right: 5,
            child: GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 18,
                backgroundColor: theme.primaryColor,
                child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
