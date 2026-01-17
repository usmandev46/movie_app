import 'package:flutter/material.dart';
import 'package:movie_booking_app/core/utils/app_size.dart';
import '../../../core/constants/colors.dart';
import '../custom_cached_image.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String? posterPath;
  final VoidCallback? onTap;

  const MovieCard({
    super.key,
    required this.title,
    this.posterPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    final imageUrl = posterPath != null && posterPath!.isNotEmpty
        ? "https://image.tmdb.org/t/p/w500$posterPath"
        : "https://via.placeholder.com/500x750?text=No+Image";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSize.h(22),
        margin: EdgeInsets.only(bottom: AppSize.h(3)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            CustomCachedImage(
              imageUrl: imageUrl,
              fit: BoxFit.fill,
              borderRadius: BorderRadius.circular(10),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                vertical: AppSize.h(2),
                horizontal: AppSize.w(3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}
