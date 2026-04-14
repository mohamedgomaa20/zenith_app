import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenith_app/core/utils/app_snack_bar.dart';
import 'package:zenith_app/features/main_app/MainScreen.dart';

import '../../../../core/common_widgets/custom_button.dart';
import '../../../../core/common_widgets/theme_toggle_button.dart';

import '../../data/models/user_data_class.dart';
import '../auth_bloc/auth_bloc.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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
          if (state.status == AuthStatus.error && state.registerError != null) {
            AppSnackBar.error(context, state.registerError!);
          }
          if (state.status == AuthStatus.registerSuccess) {
            AppSnackBar.success(context, "Account created successfully");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
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
                  Text("Create Account", style: theme.textTheme.headlineSmall),
                  SizedBox(height: 6),
                  Text(
                    "Let's Create Account Together",
                    style: theme.textTheme.bodySmall,
                  ),
                  SizedBox(height: 30),
                  CustomAuthField(
                    label: "Your Name",
                    hint: "Mohamed Gomaa",
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    prefixIcon: Icon(Icons.person_outline),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter your name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
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
                  SizedBox(height: 30),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: "Sign Up",
                        isLoading: state.registerLoading,
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          context.read<AuthBloc>().add(
                            RegisterEvent(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: theme.textTheme.bodySmall,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Sign In",
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
