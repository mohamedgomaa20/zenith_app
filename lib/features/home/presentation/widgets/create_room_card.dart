import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'section_card.dart';

class CreateRoomCard extends StatelessWidget {
  final TextEditingController controller;
  final bool loading;
  final VoidCallback onCreate;

  const CreateRoomCard({
    super.key,
    required this.controller,
    required this.loading,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      label: 'Start a new room',
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'What\'s your name?',
            ),
            textAlign: TextAlign.right,
            maxLength: 20,
            style: const TextStyle(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loading ? null : onCreate,
              child: loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.background,
                      ),
                    )
                  : const Text('Start movie night 🍿'),
            ),
          ),
        ],
      ),
    );
  }
}
