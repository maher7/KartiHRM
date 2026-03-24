import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:core/core.dart';

class DynamicImageViewer extends StatelessWidget {
  final String image;
  final double height;
  final double width;

  const DynamicImageViewer({super.key, required this.image, this.width = 25.0, this.height = 25.0});

  @override
  Widget build(BuildContext context) {
    final isValid = image.isNotEmpty && (Uri.tryParse(image)?.hasScheme ?? false);
    if (!isValid) {
      return Icon(Icons.image_outlined, size: height.h, color: Branding.colors.primaryLight);
    }
    return image.contains('svg') == true
        ? SvgPicture.network(
            image,
            height: height.h,
            width: width.w,
            colorFilter: ColorFilter.mode(Branding.colors.primaryLight, BlendMode.srcIn),
          )
        : CachedNetworkImage(
            imageUrl: image,
            height: height.h,
            width: width.w,
            color: Branding.colors.primaryLight,
            errorWidget: (context, url, error) => Icon(Icons.image_outlined, size: height.h, color: Branding.colors.primaryLight),
          );
  }
}
