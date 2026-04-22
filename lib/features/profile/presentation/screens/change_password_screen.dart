import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenith_app/core/utils/app_snack_bar.dart';
import 'package:zenith_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:zenith_app/features/auth/presentation/screens/login_screen.dart';
import '../../../../core/common_widgets/custom_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';
import '../profile_bloc/profile_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}
// الصول محمد عتمان
// اديها ل محمد مبروك

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _showReAuthSheet(BuildContext context) {
    final TextEditingController oldPassController = TextEditingController();
    final sheetFormKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.error) {
              AppSnackBar.error(
                context,
                state.errorMessage ?? "Error occurred",
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 30,
                left: 24,
                right: 24,
                top: 30,
              ),
              child: Form(
                key: sheetFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Confirm Current Password",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "For your security, please enter your old password.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    CustomAuthField(
                      label: "Current Password",
                      hint: "••••••••",
                      controller: oldPassController,
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_person_outlined),
                      validator: (v) =>
                          v!.isEmpty ? "Password is required" : null,
                    ),
                    const SizedBox(height: 30),

                    BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: "Verify & Update",
                          isLoading: state.status == ProfileStatus.loading,
                          onPressed: () {
                            if (sheetFormKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              context.read<ProfileBloc>().add(
                                ReAuthenticateEvent(
                                  oldPassword: oldPassController.text.trim(),
                                  newPassword: _newPassController.text.trim(),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final cardColor = isDark ? AppColors.surface2 : Colors.grey.shade100;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.updated) {
          if (Navigator.canPop(context)) Navigator.pop(context);
          AppSnackBar.success(context, "Password updated. Safety first!");
          context.read<AuthBloc>().add(LogoutEvent());
        }
        if (state.status == ProfileStatus.error) {
          AppSnackBar.error(context, state.errorMessage ?? "Error occurred");
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text("Security"),
          backgroundColor: backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildHeader(theme),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? AppColors.textDim.withOpacity(0.2)
                          : Colors.transparent,
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomAuthField(
                        label: "New Password",
                        hint: "Enter new password",
                        controller: _newPassController,
                        isPassword: true,
                        prefixIcon: const Icon(Icons.lock_outline),
                        validator: (v) => v!.length < 6 ? "Too short" : null,
                      ),
                      const SizedBox(height: 24),
                      CustomAuthField(
                        label: "Confirm New Password",
                        hint: "Repeat new password",
                        controller: _confirmPassController,
                        isPassword: true,
                        prefixIcon: const Icon(Icons.check_circle_outline),
                        validator: (v) => v != _newPassController.text.trim()
                            ? "No match"
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: "Update Password",
                  isLoading: false,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _showReAuthSheet(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_reset_rounded,
            color: AppColors.primary,
            size: 60,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Change Password",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Set a strong password to protect your account",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
