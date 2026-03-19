import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:core/src/widgets/shimmers.dart';

class SummeryTile extends StatelessWidget {
  const SummeryTile(
      {super.key,
      required this.title,
      this.titleValue,
      required this.color,
      this.onTap});

  final String title;
  final String? titleValue;
  final Color color;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 4.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13.r,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ).tr(),
            ),
            titleValue != null
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      titleValue!,
                      style: TextStyle(
                        fontSize: 15.r,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  )
                : RectangularCardShimmer(
                    height: 30.h,
                    width: 20.w,
                  ),
          ],
        ),
      ),
    );
  }
}
