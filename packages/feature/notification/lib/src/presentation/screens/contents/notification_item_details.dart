import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:notification/src/data/database_entities/notification_db_entity.dart';
import 'package:notification/src/presentation/cubits/add_notification_cubit.dart';

class NotificationItemDetails extends StatelessWidget {
  final NotificationDbEntity notification;
  final String dateFormat;

  const NotificationItemDetails({super.key, required this.notification, required this.dateFormat});

  @override
  Widget build(BuildContext context) {
    context.read<AddEditNotificationCubit>().onNotificationUpdated(notification: notification);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('Notification')),
        iconTheme: IconThemeData(color: Branding.colors.textInversePrimary),
        backgroundColor: Branding.colors.primaryLight,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Branding.colors.primaryLight.withOpacity(0.06),
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HtmlWidget(
                    notification.title,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.r,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 14, color: Colors.black45),
                      SizedBox(width: 6.w),
                      Text(
                        notification.created.getFormattedDate(),
                        style: TextStyle(
                          fontSize: 12.r,
                          color: Colors.black45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Body content
            Padding(
              padding: EdgeInsets.all(20.w),
              child: HtmlWidget(
                notification.description,
                textStyle: TextStyle(
                  fontSize: 14.r,
                  color: Colors.black87,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
