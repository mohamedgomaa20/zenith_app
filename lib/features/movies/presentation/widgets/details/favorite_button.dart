import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.black.withOpacity(0.45),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: isFavorite ? AppColors.red : Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
