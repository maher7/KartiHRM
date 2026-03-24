import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:core/core.dart';

class PlutoEventCard extends StatelessWidget {
  const PlutoEventCard({super.key, required this.data, this.days = false, this.onPressed});

  final TodayData? data;
  final bool? days;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
              child: SizedBox(
                width: 100.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data?.image != null && data!.image!.isNotEmpty)
                      Image.network(
                        '${data?.image}',
                        height: 20.h,
                        width: 20.w,
                        color: Branding.colors.primaryLight,
                        errorBuilder: (_, __, ___) => Icon(Icons.bar_chart_rounded, size: 20.r, color: Branding.colors.primaryLight),
                      )
                    else
                      Icon(Icons.bar_chart_rounded, size: 20.r, color: Branding.colors.primaryLight),
                    SizedBox(width: 8.w),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data?.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11.r, color: Colors.grey.shade600),
                        ).tr(),
                        Text(
                          '${data?.number}',
                          style: TextStyle(fontSize: 20.r, fontWeight: FontWeight.bold, height: 1.5, color: Colors.black87),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
