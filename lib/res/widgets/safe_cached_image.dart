import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A wrapper around CachedNetworkImage that guards against empty/invalid URLs.
/// Use this instead of CachedNetworkImage directly to prevent
/// "No host specified in URI" crashes.
class SafeCachedImage extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;

  const SafeCachedImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
    this.color,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl ?? '';
    final isValid = url.isNotEmpty && (Uri.tryParse(url)?.hasScheme ?? false);

    if (!isValid) {
      return errorWidget?.call(context, url, 'Invalid URL') ??
          Image.asset(
            'assets/images/placeholder_image.png',
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
          );
    }

    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      color: color,
      placeholder: placeholder,
      errorWidget: errorWidget ?? (context, url, error) => Image.asset(
        'assets/images/placeholder_image.png',
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
      ),
    );
  }
}
