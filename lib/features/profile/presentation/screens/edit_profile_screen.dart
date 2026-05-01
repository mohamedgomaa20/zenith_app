import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenith_app/core/utils/app_snack_bar.dart';
import '../../../../core/common_widgets/custom_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';
import '../profile_bloc/profile_bloc.dart';
import '../widgets/edit_profile_image.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final currentUser = context.read<ProfileBloc>().state.user;
    if (currentUser != null) {
      _nameController.text = currentUser.name;
      _emailController.text = currentUser.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark ? AppColors.surface2 : Colors.grey.shade100;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.loaded) {
          AppSnackBar.success(context, "Profile Updated Successfully");

          Navigator.pop(context);
        }
        if (state.status == ProfileStatus.error) {
          AppSnackBar.error(context, state.errorMessage ?? "Update Failed");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                EditProfileImage(),
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.all(20),
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
                        label: "Full Name",
                        hint: "Enter your name",
                        controller: _nameController,
                        prefixIcon: Icon(Icons.person_outline),
                        validator: (value) =>
                            value!.isEmpty ? "Name cannot be empty" : null,
                      ),
                      const SizedBox(height: 24),
                      Opacity(
                        opacity: 0.6,
                        child: CustomAuthField(
                          label: "Email Address",
                          hint: "Email",
                          controller: _emailController,
                          prefixIcon: const Icon(Icons.email_outlined),
                          enabled: false,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: "Save Changes",
                      isLoading: state.status == ProfileStatus.loading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ProfileBloc>().add(
                            UpdateProfileEvent(
                              name: _nameController.text.trim(),
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
        ),
      ),
    );
  }
}
