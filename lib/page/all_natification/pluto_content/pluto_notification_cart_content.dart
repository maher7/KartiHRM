import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';

class PlutoNotificationCartContent extends StatelessWidget {
  const PlutoNotificationCartContent({super.key, required this.data});

  final NotificationModelData? data;

  /// Pick icon & color based on notification slug/type
  ({IconData icon, Color color}) _notificationStyle() {
    final slug = (data?.slag ?? '').toLowerCase();
    if (slug.contains('leave')) {
      return (icon: Icons.event_note_rounded, color: const Color(0xFF1976D2));
    } else if (slug.contains('attendance') || slug.contains('check')) {
      return (icon: Icons.access_time_rounded, color: const Color(0xFF388E3C));
    } else if (slug.contains('appointment')) {
      return (icon: Icons.calendar_month_rounded, color: const Color(0xFF7B1FA2));
    } else if (slug.contains('task')) {
      return (icon: Icons.task_alt_rounded, color: const Color(0xFFE65100));
    } else if (slug.contains('travel') || slug.contains('expense')) {
      return (icon: Icons.flight_rounded, color: const Color(0xFF00838F));
    } else if (slug.contains('meeting')) {
      return (icon: Icons.groups_rounded, color: const Color(0xFF5D4037));
    } else if (slug.contains('visit')) {
      return (icon: Icons.place_rounded, color: const Color(0xFFC62828));
    } else if (slug.contains('support') || slug.contains('ticket')) {
      return (icon: Icons.support_agent_rounded, color: const Color(0xFF283593));
    } else {
      return (icon: Icons.notifications_rounded, color: Branding.colors.primaryLight);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _notificationStyle();
    final isUnread = data?.isRead == false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isUnread ? style.color.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread ? style.color.withValues(alpha: 0.15) : Colors.grey.shade100,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Colored icon avatar
            Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: style.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(style.icon, color: style.color, size: 22.r),
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
                            fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 13.r,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          margin: EdgeInsets.only(left: 8.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: style.color,
                          ),
                        ),
                    ],
                  ),
                  if (data?.body != null && data!.body!.trim().isNotEmpty) ...[
                    SizedBox(height: 2.h),
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
                  ],
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
