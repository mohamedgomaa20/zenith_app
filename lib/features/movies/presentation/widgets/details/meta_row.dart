import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class MetaRow extends StatelessWidget {
  final String year;
  final String rating;
  final bool isDark;

  const MetaRow({
    super.key,
    required this.year,
    required this.rating,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDark ? AppColors.textSecondary : AppColors.lightSubText;
    return Row(
      children: [
        _MetaChip(
          icon: Icons.calendar_today_rounded,
          label: year,
          color: color,
        ),
        _dot(color),
        _MetaChip(
          icon: Icons.star_rounded,
          label: '$rating / 10',
          color: AppColors.gold,
          bold: true,
        ),
        _dot(color),
        _MetaChip(
          icon: Icons.movie_filter_rounded,
          label: 'Movie',
          color: color,
        ),
      ],
    );
  }

  Widget _dot(Color color) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ),
  );
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool bold;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
