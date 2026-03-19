import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';

class PlutoNotificationCartContent extends StatelessWidget {
  const PlutoNotificationCartContent({super.key, required this.data,});

  final NotificationModelData? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: data?.isRead == true ? Colors.white : Branding.colors.primaryLight.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: data?.isRead == true ? Colors.grey.shade100 : Branding.colors.primaryLight.withValues(alpha: 0.15),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200, width: 1.5),
              ),
              child: ClipOval(
                child: (data?.image != null && data!.image!.isNotEmpty)
                    ? CachedNetworkImage(
                        height: 40.h,
                        width: 40.w,
                        fit: BoxFit.cover,
                        imageUrl: data!.image!,
                        placeholder: (context, url) => Container(
                          height: 40.h, width: 40.w,
                          color: Colors.grey.shade100,
                          child: Icon(Icons.notifications_outlined, color: Colors.grey.shade400, size: 20),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 40.h, width: 40.w,
                          color: Colors.grey.shade100,
                          child: Icon(Icons.notifications_outlined, color: Colors.grey.shade400, size: 20),
                        ),
                      )
                    : Container(
                        height: 40.h, width: 40.w,
                        color: Colors.grey.shade100,
                        child: Icon(Icons.notifications_outlined, color: Colors.grey.shade400, size: 20),
                      ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data?.title ?? '',
                          style: TextStyle(
                            fontWeight: data?.isRead == true ? FontWeight.w500 : FontWeight.w700,
                            fontSize: 13.r,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (data?.isRead == false)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Branding.colors.primaryLight,
                          ),
                        ),
                    ],
                  ),
                  Html(
                    data: data?.body,
                    style: {
                      "body": Style(
                        fontSize: FontSize(12.r),
                        padding: HtmlPaddings.zero,
                        margin: Margins.zero,
                        maxLines: 2,
                        color: Colors.black54,
                      ),
                    },
                  ),
                  SizedBox(height: 4.h),
                  if (data?.date != null)
                    Text(
                      data!.date!,
                      style: TextStyle(color: Colors.black38, fontSize: 10.r),
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
