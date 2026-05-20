import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class WallpaperCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onFavorite;
  final VoidCallback? onSetWallpaper;

  const WallpaperCard({
    super.key,
    required this.imageUrl,
    this.onFavorite,
    this.onSetWallpaper,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSetWallpaper,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF1A1A1A),
        ),
        child: Stack(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: const Color(0xFF1A1A1A),
                  highlightColor: const Color(0xFF2A2A2A),
                  child: Container(color: const Color(0xFF1A1A1A)),
                ),
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFF1A1A1A),
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: Color(0xFF444444),
                    size: 32,
                  ),
                ),
              ),
            ),

            // Gradient overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),

            // Action buttons
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                children: [
                  _buildActionButton(
                    icon: Icons.favorite_outline,
                    onTap: onFavorite,
                  ),
                  const SizedBox(width: 6),
                  _buildActionButton(
                    icon: Icons.wallpaper_outlined,
                    onTap: onSetWallpaper,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
