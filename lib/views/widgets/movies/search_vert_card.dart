import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/app_size.dart';
import '../custom_cached_image.dart';

class SearchVertCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback? onTap;

  const SearchVertCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSize.h(2)),
        padding: EdgeInsets.all(AppSize.w(2)),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: CustomCachedImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            SizedBox(width: AppSize.w(3)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSize.h(0.5)),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),

            Icon(Icons.more_horiz, size: 40, color: AppColors.secondary),
          ],
        ),
      ),
    );
  }
}
