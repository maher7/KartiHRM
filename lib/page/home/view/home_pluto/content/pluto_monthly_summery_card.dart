import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';

class PlutoMonthlyEventCard extends StatelessWidget {
  const PlutoMonthlyEventCard({super.key, required this.data, this.days = false, this.onPressed});

  final CurrentMonthData? data;
  final bool? days;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (data?.image != null && data!.image!.isNotEmpty)
                      Image.network(
                        '${data?.image}',
                        height: 20.h,
                        width: 20.w,
                        color: Branding.colors.primaryLight,
                        errorBuilder: (_, __, ___) => Icon(Icons.calendar_today_rounded, size: 20.r, color: Branding.colors.primaryLight),
                      )
                    else
                      Icon(Icons.calendar_today_rounded, size: 20.r, color: Branding.colors.primaryLight),
                    SizedBox(height: 4.h),
                    Text(
                      '${data?.number}',
                      style: TextStyle(color: Colors.black87, fontSize: 20.r, fontWeight: FontWeight.w700, height: 1.5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            data?.title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12.r, fontWeight: FontWeight.w500),
                          ).tr(),
                        ),
                        SizedBox(width: 2.w),
                        Icon(Icons.arrow_forward_ios_rounded, size: 10.r, color: Colors.grey.shade400),
                      ],
                    ),
                    SizedBox(height: 4.h),
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
