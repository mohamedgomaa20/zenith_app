import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          
          CachedNetworkImage(
            imageUrl: movie.posterUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: AppColors.surface2,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.gold,
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (_, __, ___) => Container(
              color: AppColors.surface2,
              child: const Icon(
                Icons.movie,
                color: AppColors.textDim,
                size: 64,
              ),
            ),
          ),

          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xCC000000)],
                stops: [0.4, 1.0],
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    movie.title,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 30,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        movie.year,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('⭐', style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 4),
                      Text(
                        movie.ratingFormatted,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: movie.genres
                        .take(3)
                        .map(
                          (g) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              g,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
