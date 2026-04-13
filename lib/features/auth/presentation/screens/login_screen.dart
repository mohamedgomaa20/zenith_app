import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenith_app/features/home/presentation/screens/home_Screen.dart';

import '../../../../core/common_widgets/custom_button.dart';
import '../../../../core/common_widgets/theme_toggle_button.dart';

import '../../../../core/utils/app_snack_bar.dart';
import '../../data/models/user_data_class.dart';
import '../auth_bloc/auth_bloc.dart';
import '../widgets/custom_text_field.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(actions: [ThemeToggleButton()]),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error) {
            final error = state.loginError ?? state.googleError;

            if (error != null) {
              AppSnackBar.error(context, error);
            }
          }
          if (state.status == AuthStatus.loginSuccess ||
              state.status == AuthStatus.googleSuccess) {
            AppSnackBar.success(context, "Login successful");

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text("Hello Again!", style: theme.textTheme.headlineSmall),
                  SizedBox(height: 6),
                  Text(
                    "Welcome Back You've Been Missed",
                    style: theme.textTheme.bodySmall,
                  ),
                  SizedBox(height: 40),
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
                  SizedBox(height: 20),
                  CustomAuthField(
                    label: "Password",
                    hint: "********",
                    controller: _passController,
                    isPassword: true,
                    prefixIcon: Icon(Icons.lock_outline),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter password";
                      }
                      if (value.length < 6) {
                        return "Minimum 6 characters";
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text("Forgot Password?"),
                    ),
                  ),
                  SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: "Sign In",
                        isLoading: state.loginLoading,
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          context.read<AuthBloc>().add(
                            LoginEvent(
                              UserDataClass(
                                email: _emailController.text,
                                password: _passController.text,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 55),
                        ),
                        onPressed: state.googleLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(
                                  GoogleLoginEvent(),
                                );
                              },
                        icon: state.googleLoading
                            ? null
                            : Image.asset(
                                "assets/images/google-icon.png",
                                height: 22,
                              ),
                        label: state.googleLoading
                            ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              )
                            : Text("Sign in with Google"),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: theme.textTheme.bodySmall,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RegisterScreen()),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
