import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class ExpandableOverview extends StatefulWidget {
  final String overview;
  final bool isDark;

  const ExpandableOverview({
    super.key,
    required this.overview,
    required this.isDark,
  });

  @override
  State<ExpandableOverview> createState() => _ExpandableOverviewState();
}

class _ExpandableOverviewState extends State<ExpandableOverview> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            widget.overview,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: _buildTextStyle(),
          ),
          secondChild: Text(widget.overview, style: _buildTextStyle()),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded ? 'Show less' : 'Read more',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  TextStyle _buildTextStyle() {
    return TextStyle(
      fontSize: 17,
      height: 1.75,
      color: widget.isDark ? AppColors.textSecondary : AppColors.lightSubText,
    );
  }
}
