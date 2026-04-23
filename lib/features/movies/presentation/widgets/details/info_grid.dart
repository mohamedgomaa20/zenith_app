import 'package:flutter/material.dart';
import '../../../data/models/movie_model.dart';
import '../../../../../core/theme/app_colors.dart';

class InfoGrid extends StatelessWidget {
  final Movie movie;
  final String year;
  final bool isDark;

  const InfoGrid({
    super.key,
    required this.movie,
    required this.year,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _InfoItem(
        icon: Icons.calendar_month_rounded,
        label: 'Release Year',
        value: year,
      ),
      _InfoItem(
        icon: Icons.star_rounded,
        label: 'TMDB Score',
        value: '${movie.voteAverage.toStringAsFixed(1)} / 10',
      ),
      _InfoItem(
        icon: Icons.language_rounded,
        label: 'Language',
        value: 'English',
      ),
      _InfoItem(icon: Icons.movie_rounded, label: 'Type', value: 'Movie'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _InfoCard(
        item: items[index],
        cardColor: AppColors.grey.withValues(alpha: 0.07),
        isDark: isDark,
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _InfoCard extends StatelessWidget {
  final _InfoItem item;
  final Color cardColor;
  final bool isDark;

  const _InfoCard({
    required this.item,
    required this.cardColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.textDim : AppColors.lightSubText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimary : AppColors.lightText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
