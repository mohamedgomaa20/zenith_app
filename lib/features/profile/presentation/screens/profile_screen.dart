import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenith_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:zenith_app/features/auth/presentation/screens/login_screen.dart';
import 'package:zenith_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:zenith_app/features/profile/presentation/screens/change_password_screen.dart';
import '../../../../core/common_widgets/theme_toggle_button.dart';
import '../../../../core/theme/theme_manager/theme_manager_bloc.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
        actions: [ThemeToggleButton()],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            ProfileHeader(),
            SizedBox(height: 30),
            ProfileMenuItem(
              icon: Icons.person_outline,
              title: "Edit Profile",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
            ),
            ProfileMenuItem(
              icon: Icons.lock_outline,
              title: "Password & Security",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(),
                  ),
                );
              },
            ),
            ProfileMenuItem(
              icon: Icons.notifications_none,
              title: "Notifications",
              onTap: () {},
            ),

            BlocBuilder<ThemeManagerBloc, ThemeManagerState>(
              builder: (context, state) {
                return ProfileMenuItem(
                  icon: state.themeMode == ThemeMode.dark
                      ? CupertinoIcons.brightness
                      : CupertinoIcons.moon_fill,
                  title: "Theme Mode",
                  trailingWidget: Switch(
                    value: state.themeMode == ThemeMode.dark,
                    onChanged: (_) {
                      context.read<ThemeManagerBloc>().add(ToggleThemeEvent());
                    },
                  ),
                  onTap: () {},
                );
              },
            ),
            Divider(height: 40),
            ProfileMenuItem(
              icon: Icons.logout,
              title: "Log Out",
              isLogout: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Log Out"),
                    content: Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(LogoutEvent());
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Log Out",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
