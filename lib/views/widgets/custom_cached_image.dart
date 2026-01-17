import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.fill,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        width: double.maxFinite,
        imageUrl: imageUrl,
        fit: fit,
        placeholder: (context, url) => Container(
          color: Colors.black12,
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.black12,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      ),
    );
  }
}
