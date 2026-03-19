import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:notification/src/data/database_entities/notification_db_entity.dart';

class NotificationItem extends StatelessWidget {
  final NotificationDbEntity notification;
  final VoidCallback onTap;

  const NotificationItem({super.key, required this.notification, required this.onTap});

  IconData _getNotificationIcon() {
    final title = notification.title.toLowerCase();
    if (title.contains('check in') || title.contains('checkin') || title.contains('attendance')) {
      return Icons.login_rounded;
    } else if (title.contains('check out') || title.contains('checkout')) {
      return Icons.logout_rounded;
    } else if (title.contains('leave')) {
      return Icons.event_busy_rounded;
    } else if (title.contains('notice') || title.contains('announcement')) {
      return Icons.campaign_rounded;
    } else if (title.contains('birthday')) {
      return Icons.cake_rounded;
    } else if (title.contains('meeting') || title.contains('appointment')) {
      return Icons.groups_rounded;
    } else if (title.contains('expense') || title.contains('salary') || title.contains('payroll')) {
      return Icons.payments_rounded;
    } else if (title.contains('task')) {
      return Icons.task_alt_rounded;
    }
    return Icons.notifications_rounded;
  }

  Color _getIconColor() {
    final title = notification.title.toLowerCase();
    if (title.contains('check in') || title.contains('checkin')) {
      return const Color(0xFF16a34a);
    } else if (title.contains('check out') || title.contains('checkout')) {
      return const Color(0xFFea580c);
    } else if (title.contains('leave')) {
      return const Color(0xFFdc2626);
    } else if (title.contains('notice') || title.contains('announcement')) {
      return const Color(0xFF2563eb);
    } else if (title.contains('birthday')) {
      return const Color(0xFFe11d48);
    } else if (title.contains('meeting') || title.contains('appointment')) {
      return const Color(0xFF7c3aed);
    } else if (title.contains('expense') || title.contains('salary')) {
      return const Color(0xFF059669);
    }
    return Branding.colors.primaryLight;
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.seen;
    final iconColor = _getIconColor();

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        color: isUnread ? iconColor.withOpacity(0.05) : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getNotificationIcon(),
                color: iconColor,
                size: 22,
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
                        child: HtmlWidget(
                          notification.title,
                          textStyle: TextStyle(
                            fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                            fontSize: 13.5.r,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: iconColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  HtmlWidget(
                    notification.description,
                    textStyle: TextStyle(
                      fontSize: 12.r,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    isoTimeAgoCustom(notification.date),
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 11.r,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.black26,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
