import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'custom_circle_pro_ind.dart';

class CacheImage extends StatelessWidget {
  const CacheImage({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  final String url;
  final double width;
  final double height;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        height: height,
        width: width,
        imageUrl: url,
        placeholder: (context, url) => const SizedBox(
          height: 200,
          child: CustomCircleProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error_outline),
      ),
    );
  }
}
