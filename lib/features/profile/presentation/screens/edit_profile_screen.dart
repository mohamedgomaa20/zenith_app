import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common_widgets/custom_button.dart';
import '../../../auth/presentation/auth_bloc/auth_bloc.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';
import '../widgets/edit_profile_image.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
              CustomAuthField(
                label: "Full Name",
                hint: "Enter your name",
                controller: _nameController,
                prefixIcon: Icon(Icons.person_outline),
                validator: (v) => v!.isEmpty ? "Name cannot be empty" : null,
              ),
              SizedBox(height: 20),
              CustomAuthField(
                label: "Bio",
                hint: "Tell us about yourself",
                maxLines: 5,
                controller: _bioController,
                prefixIcon: const Icon(Icons.info_outline),
              ),
              SizedBox(height: 30),
              CustomButton(
                text: "Save Changes",
                isLoading: false,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
