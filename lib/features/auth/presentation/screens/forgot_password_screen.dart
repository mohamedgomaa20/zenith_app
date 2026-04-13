import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common_widgets/custom_button.dart';
import '../../../../core/common_widgets/theme_toggle_button.dart';

import '../../../../core/utils/app_snack_bar.dart';
import '../auth_bloc/auth_bloc.dart';
import '../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(actions: [ThemeToggleButton()]),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error &&
              state.forgotPasswordError != null) {
            AppSnackBar.error(context, state.forgotPasswordError!);
          }
          if (state.status == AuthStatus.forgotPasswordSuccess) {
            AppSnackBar.success(
              context,
              "Reset email sent successfully. Check your email.",
            );
            Future.delayed(Duration(seconds: 1), () {
              Navigator.pop(context);
            });
          }
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Recovery Password",
                    style: theme.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Please enter your email address to receive a verification code",
                    style: theme.textTheme.bodySmall,
                  ),
                  SizedBox(height: 30),
                  CustomAuthField(
                    label: "Email Address",
                    hint: "MohamedGomaa@gmail.com",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter your email";
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return "Invalid email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: "Continue",
                        isLoading: state.forgotPasswordLoading,
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          context.read<AuthBloc>().add(
                            ForgotPasswordEvent(_emailController.text.trim()),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Back to Login"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
